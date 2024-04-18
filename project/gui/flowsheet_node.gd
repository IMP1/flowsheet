class_name FlowsheetNodeGui
extends Panel

signal deleted
signal selected
signal connection_started
signal connection_ended
signal initial_value_changed
signal moved

@export var data: FlowsheetNode

var calculated_value:
	set = _set_calculated_value,
	get = _get_calculated_value
var _pre_drag_position: Vector2
var _is_dragging: bool = false
var _drag_offset: Vector2

@onready var connector_in := $Connectors/In as FlowsheetNodeConnector
@onready var connector_out := $Connectors/Out as FlowsheetNodeConnector
@onready var _drag_handle := $DragHandle as Button
@onready var _calculated_value := $CalculatedValue as Label
@onready var _initial_value := $InitialValue as NodeInput
@onready var _selection_indicator := $Selection as Control


func _ready() -> void:
	_drag_handle.button_down.connect(_begin_drag)
	_drag_handle.button_up.connect(_end_drag)
	var select_on_event := func(event: InputEvent):
		if not event is InputEventMouseMotion and not _selection_indicator.visible:
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


func select() -> void:
	_selection_indicator.visible = true


func unselect() -> void:
	_selection_indicator.visible = false
