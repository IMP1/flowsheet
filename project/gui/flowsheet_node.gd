class_name FlowsheetNodeGui
extends Panel

signal deleted
signal selected
signal connection_started
signal connection_ended
signal initial_value_changed
signal calculated_value_changed
signal moved

const INVISIBLE_COLOUR := Color(Color.WHITE, 0.2)
const EDIT_THEME := preload("res://resources/node_theme.tres") as Theme

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
@onready var _background := $Background as NinePatchRect


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
	# TODO: Use Project.sheet.default_node_styles to style node
	unselect()


func _set_calculated_value(value) -> void:
	if typeof(value) == typeof(calculated_value) and calculated_value != value:
		calculated_value_changed.emit()
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
	refresh_style()


func refresh_style() -> void:
	var is_invisible: bool
	if style_overrides.has(&"visible"):
		is_invisible = not style_overrides[&"visible"] as bool
	else:
		is_invisible = not Project.sheet.default_node_style.visible
	if is_invisible and Project.view_mode == FlowsheetCanvas.View.TEST:
		visible = false
	else:
		visible = true
	if is_invisible and Project.view_mode == FlowsheetCanvas.View.STYLE:
		modulate = INVISIBLE_COLOUR
	else:
		modulate = Color.WHITE
	
	if style_overrides.has(&"size"):
		size = style_overrides[&"size"] as Vector2
	else:
		size = Project.sheet.default_node_style.size
	
	if style_overrides.has(&"background_colour"):
		style_box.bg_color = style_overrides[&"background_colour"] as Color
	else:
		style_box.bg_color = Project.sheet.default_node_style.background_colour
	
	if style_overrides.has(&"border_thickness"):
		var value := style_overrides[&"border_thickness"] as float
		style_box.border_width_top = int(value)
		style_box.border_width_bottom = int(value)
		style_box.border_width_left = int(value)
		style_box.border_width_right = int(value)
	else:
		var border_thickness := Project.sheet.default_node_style.border_thickness
		style_box.border_width_top = int(border_thickness)
		style_box.border_width_bottom = int(border_thickness)
		style_box.border_width_left = int(border_thickness)
		style_box.border_width_right = int(border_thickness)
	
	if style_overrides.has(&"border_colour"):
		style_box.border_color = style_overrides[&"border_colour"] as Color
	else:
		style_box.border_color = Project.sheet.default_node_style.border_colour
	
	if style_overrides.has(&"corner_radius"):
		var value := style_overrides[&"corner_radius"] as int
		style_box.corner_radius_top_left = value
		style_box.corner_radius_top_right = value
		style_box.corner_radius_bottom_left = value
		style_box.corner_radius_bottom_right = value
		if Project.view_mode == FlowsheetCanvas.View.STYLE:
			_selection_indicator.get("theme_override_styles/panel").corner_radius_top_left = value
			_selection_indicator.get("theme_override_styles/panel").corner_radius_bottom_left = value
			_selection_indicator.get("theme_override_styles/panel").corner_radius_top_right = value
			_selection_indicator.get("theme_override_styles/panel").corner_radius_bottom_right = value
	else:
		var corner_radius := Project.sheet.default_node_style.corner_radius
		style_box.corner_radius_top_left = corner_radius
		style_box.corner_radius_top_right = corner_radius
		style_box.corner_radius_bottom_left = corner_radius
		style_box.corner_radius_bottom_right = corner_radius
		if Project.view_mode == FlowsheetCanvas.View.STYLE:
			_selection_indicator.get("theme_override_styles/panel").corner_radius_top_left = corner_radius
			_selection_indicator.get("theme_override_styles/panel").corner_radius_bottom_left = corner_radius
			_selection_indicator.get("theme_override_styles/panel").corner_radius_top_right = corner_radius
			_selection_indicator.get("theme_override_styles/panel").corner_radius_bottom_right = corner_radius
	
	if style_overrides.has(&"text_colour"):
		_initial_value.set_text_colour(style_overrides[&"text_colour"])
	else:
		_initial_value.set_text_colour(Project.sheet.default_node_style.text_colour)
	
	if style_overrides.has(&"text_size"):
		_initial_value.set_text_size(style_overrides[&"text_size"])
	else:
		_initial_value.set_text_size(Project.sheet.default_node_style.text_size)
	
	if style_overrides.has(&"text_font_name"):
		var font := Project.get_font(style_overrides[&"text_font_name"])
		_initial_value.set_text_font(font)
	else:
		var font := Project.get_font(Project.sheet.default_node_style.text_font_name)
		_initial_value.set_text_font(font)
	
	var image_path: String
	if style_overrides.has(&"background_image_path"):
		image_path = style_overrides[&"background_image_path"]
	else:
		image_path = Project.sheet.default_node_style.background_image_path
	if not image_path.is_empty():
		var image: Image = Image.load_from_file(image_path)
		var texture := ImageTexture.create_from_image(image)
		_background.texture = texture
	
	if style_overrides.has(&"background_image_rect"):
		_background.region_rect = style_overrides[&"background_image_rect"]
	else:
		_background.region_rect = Project.sheet.default_node_style.background_image_rect
	
	if style_overrides.has(&"background_image_scaling"):
		var stretch := int(style_overrides[&"background_image_scaling"])
		_background.axis_stretch_horizontal = stretch
		_background.axis_stretch_vertical = stretch
	else:
		var stretch := int(Project.sheet.default_node_style.background_image_scaling)
		_background.axis_stretch_horizontal = stretch
		_background.axis_stretch_vertical = stretch


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
			_selection_indicator.get("theme_override_styles/panel").corner_radius_top_left = 20
			_selection_indicator.get("theme_override_styles/panel").corner_radius_bottom_left = 20
			_selection_indicator.get("theme_override_styles/panel").corner_radius_top_right = 20
			_selection_indicator.get("theme_override_styles/panel").corner_radius_bottom_right = 20
			_background.visible = false
			_initial_value.clear_styles()
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
			var corner_radius: int = 0
			if style_overrides.has(&"corner_radius"):
				corner_radius = style_overrides[&"corner_radius"]
			else:
				corner_radius = Project.sheet.default_node_style.corner_radius
			_selection_indicator.get("theme_override_styles/panel").corner_radius_top_left = corner_radius
			_selection_indicator.get("theme_override_styles/panel").corner_radius_bottom_left = corner_radius
			_selection_indicator.get("theme_override_styles/panel").corner_radius_top_right = corner_radius
			_selection_indicator.get("theme_override_styles/panel").corner_radius_bottom_right = corner_radius
			_background.visible = true
			_initial_value.refresh_style()
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
			_background.visible = true
			_initial_value.refresh_style()


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
	z_index += 20


func _end_drag() -> void:
	if not _is_dragging:
		return
	_is_dragging = false
	move_node(position)
	z_index -= 20


func move_node(new_pos: Vector2) -> void:
	position = new_pos
	data.position = new_pos
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


#------------------------------#
# Scripting Related Sandboxing #
#------------------------------#


func __index(ref: LuaAPI, index) -> Variant:
	if index == "id":
		return data.id
	# TODO: Add fields for type, value (calculated & initial), editable?
	return null


func __newindex(ref: LuaAPI, index, value) -> void:
	if index == "position":
		position = value
	if index == "editable":
		set_editable(value)
	# TODO: Maybe allow some fields to be set, and call the relevant function?
	pass # Ignore attempts to set fields

