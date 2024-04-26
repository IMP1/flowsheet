class_name FlowsheetLinkGui
extends Control

signal node_deleted
signal selected

const DISTANCE_TO_CLICK = 8

@export var source_node: FlowsheetNodeGui
@export var target_node: FlowsheetNodeGui
@export var data: FlowsheetLink
@export var style_overrides: Dictionary

var formula: FlowsheetFormula
var _source_position: Vector2
var _target_position: Vector2
var _is_selected: bool = false
var _is_selectable: bool = true

@onready var _path := $Path2D as Path2D
@onready var _line := $Line as CurvedLine2D
@onready var _selection_indicator := $Selection as CurvedLine2D


func _ready() -> void:
	unselect()
	source_node.deleted.connect(func(): node_deleted.emit())
	target_node.deleted.connect(func(): node_deleted.emit())


func set_formula(code: String) -> void:
	print("[LinkGui] Setting formula to '%s'." % code)
	data.formula = code
	if code.is_empty():
		formula = null
		return
	var expr := FlowsheetFormula.new()
	var parse_result := expr.parse(code)
	if parse_result != OK:
		# TODO: Communicate this error to the user
		push_error("Couldn't parse formula '%s'.\n%s" % [code, expr.get_error_text()])
		formula = null
		return
	formula = expr


func _set_view_mode(view: FlowsheetCanvas.View) -> void:
	match view:
		FlowsheetCanvas.View.EDIT:
			_selection_indicator.visible = _is_selected
			_is_selectable = true
		FlowsheetCanvas.View.STYLE:
			_selection_indicator.visible = _is_selected
			_is_selectable = true
		FlowsheetCanvas.View.TEST:
			_selection_indicator.visible = false
			_is_selectable = false


func _process(_delta: float) -> void:
	if _source_position != source_node.position or _target_position != target_node.position:
		_redraw_line()
		_source_position = source_node.position
		_target_position = target_node.position


func _redraw_line() -> void:
	var source := source_node.position + source_node.connector_out.position + Vector2(12, 12)
	var target := target_node.position + target_node.connector_in.position + Vector2(12, 12)
	var midpoint := (source + target) / 2
	var anchor_size := (midpoint.x - source.x)
	_path.curve.clear_points()
	_path.curve.add_point(source)
	_path.curve.add_point(midpoint)
	_path.curve.add_point(target)
	_path.curve.set_point_out(0, Vector2(anchor_size, 0))
	_path.curve.set_point_in(2, Vector2(-anchor_size, 0))
	_line.calculate_line.call_deferred()
	_selection_indicator.calculate_line.call_deferred()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"mouse_select"):
		if _is_point_over(_path.get_local_mouse_position()) and _is_selectable:
			selected.emit()


func _is_point_over(point: Vector2) -> bool:
	var line_pos := _path.curve.get_closest_point(point)
	var distance_squared := (line_pos - point).length_squared()
	return distance_squared <= (DISTANCE_TO_CLICK * DISTANCE_TO_CLICK)


func select() -> void:
	_is_selected = true
	_selection_indicator.visible = true


func unselect() -> void:
	_is_selected = false
	_selection_indicator.visible = false
