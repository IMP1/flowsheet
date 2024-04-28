class_name FlowsheetNodeGui
extends Panel

signal deleted
signal selected
signal connection_started
signal connection_ended
signal initial_value_changed
signal moved

const INVISIBLE_COLOUR := Color(Color.WHITE, 0.2)
const EDIT_THEME := preload("res://gui/theme_node.tres") as Theme

@export var data: FlowsheetNode

var style_overrides: Dictionary
var style_box: StyleBoxFlat
var calculated_value:
	set = _set_calculated_value,
	get = _get_calculated_value
var _pre_drag_position: Vector2
var _is_dragging: bool = false
var _drag_offset: Vector2
var _is_mouse_over: bool = false
var _is_selected: bool = false
var _is_selectable: bool = true

@onready var connector_in := $Connectors/In as FlowsheetNodeConnector
@onready var connector_out := $Connectors/Out as FlowsheetNodeConnector
@onready var _drag_handle := $DragHandle as Button
@onready var _calculated_value := $CalculatedValue as Label
@onready var _initial_value := $InitialValue as NodeInput
@onready var _selection_indicator := $Selection as Control


func _ready() -> void:
	style_overrides = {}
	style_box = StyleBoxFlat.new()
	mouse_entered.connect(func(): _is_mouse_over = true)
	mouse_exited.connect(func(): _is_mouse_over = false)
	_drag_handle.button_down.connect(_begin_drag)
	_drag_handle.button_up.connect(_end_drag)
	var select_on_event := func(event: InputEvent):
		if not event is InputEventMouseMotion and not _selection_indicator.visible and _is_selectable:
			selected.emit()
	gui_input.connect(select_on_event)
	_initial_value.gui_input.connect(select_on_event)
	connector_in.node_id = data.id
	connector_out.node_id = data.id
	connector_out.starting_connection.connect(func():
		selected.emit() 
		connection_started.emit())
	connector_in.ending_connection.connect(func(source, target): connection_ended.emit(source, target))
	_initial_value.value_changed.connect(_initial_value_changed)
	set_type.call_deferred(data.type)
	set_inital_value.call_deferred(data.initial_value)
	set_editable.call_deferred(data.accepts_input)
	_set_calculated_value.call_deferred(data.calculated_value)
	unselect()


func _set_calculated_value(value) -> void:
	calculated_value = value
	_calculated_value.text = str(value)


func _get_calculated_value():
	return calculated_value


func set_type(new_type: FlowsheetNode.Type) -> void:
	data.type = new_type
	_initial_value.type = new_type
	# TODO: Check whether the previous value is still valid? int <-> decimal, decimal <-> percentage?
	set_inital_value(FlowsheetNode.default_value(new_type))


func set_editable(editable: bool) -> void:
	data.accepts_input = editable
	if editable:
		_calculated_value.visible = false
		_initial_value.visible = true
	else:
		_initial_value.visible = false
		_calculated_value.visible = true


func set_inital_value(new_value, ignore_input: bool = false) -> void:
	data.initial_value = new_value
	if not ignore_input:
		_initial_value.value = new_value
	calculated_value = new_value


func set_style(property: StringName, value) -> void:
	style_overrides[property] = value
	match property:
		&"visible":
			if not value and Project.view_mode == FlowsheetCanvas.View.TEST:
				visible = false
			else:
				visible = true
			if not value and Project.view_mode == FlowsheetCanvas.View.STYLE:
				modulate = INVISIBLE_COLOUR
			else:
				modulate = Color.WHITE
		&"size":
			size = value as Vector2
		&"background_colour":
			style_box.bg_color = value as Color
		&"border_thickness":
			style_box.border_width_top = value
			style_box.border_width_bottom = value
			style_box.border_width_left = value
			style_box.border_width_right = value
		&"border_colour":
			style_box.border_color = value
		&"corner_radius":
			style_box.corner_radius_top_left = value
			style_box.corner_radius_top_right = value
			style_box.corner_radius_bottom_left = value
			style_box.corner_radius_bottom_right = value
		&"text_colour":
			pass # TODO: Set text colour
		&"text_size":
			pass # TODO: Set text size
		&"text_font_name":
			pass # TODO: Set text font
		&"background_image_path":
			pass # TODO: Set background
		&"background_image_rect":
			pass # TODO: Set background
		&"background_image_scaling":
			pass # TODO: Set background


func _set_view_mode(view: FlowsheetCanvas.View) -> void:
	match view:
		FlowsheetCanvas.View.EDIT:
			theme = EDIT_THEME
			remove_theme_stylebox_override(&"panel")
			_selection_indicator.visible = _is_selected
			_drag_handle.visible = true
			connector_in.visible = true
			connector_out.visible = true
			_is_selectable = true
			visible = true
			modulate = Color.WHITE
		FlowsheetCanvas.View.STYLE:
			theme = null
			add_theme_stylebox_override(&"panel", style_box)
			_selection_indicator.visible = _is_selected
			_drag_handle.visible = false
			connector_in.visible = false
			connector_out.visible = false
			_is_selectable = true
			visible = true
			modulate = Color.WHITE
			if style_overrides.has(&"visible") and not style_overrides[&"visible"]:
				modulate = INVISIBLE_COLOUR
			elif not Project.sheet.default_node_style.visible:
				modulate = INVISIBLE_COLOUR
		FlowsheetCanvas.View.TEST:
			theme = null
			add_theme_stylebox_override(&"panel", style_box)
			_selection_indicator.visible = false
			_drag_handle.visible = false
			connector_in.visible = false
			connector_out.visible = false
			_is_selectable = false
			visible = true
			modulate = Color.WHITE
			if style_overrides.has(&"visible") and not style_overrides[&"visible"]:
				visible = false
			elif not Project.sheet.default_node_style.visible:
				visible = false


# Called when user changes the value on the node, rather than in the bar at the top of the canvas
func _initial_value_changed(new_value) -> void:
	set_inital_value(new_value, true)
	initial_value_changed.emit()


func _begin_drag() -> void:
	if _is_dragging:
		return
	_is_dragging = true
	_pre_drag_position = position
	_drag_offset = get_local_mouse_position()
	selected.emit()


func _end_drag() -> void:
	if not _is_dragging:
		return
	_is_dragging = false
	data.position = position
	moved.emit()


func _cancel_drag() -> void:
	if not _is_dragging:
		return
	_is_dragging = false
	position = _pre_drag_position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _is_dragging:
		var new_pos := get_parent_control().get_local_mouse_position() - _drag_offset
		if Project.snap_to_grid:
			new_pos = snapped(new_pos, Project.grid_size)
		position = new_pos
	if event.is_action_pressed("drag_cancel") and _is_dragging:
		_cancel_drag()
	if event.is_action_pressed(&"mouse_select") and _is_selectable:
		if _is_mouse_over:
			selected.emit()


func select() -> void:
	_is_selected = true
	_selection_indicator.visible = true


func unselect() -> void:
	_is_selected = false
	_selection_indicator.visible = false
