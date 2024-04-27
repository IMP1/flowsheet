class_name FlowsheetLinkGui
extends Control

signal node_deleted
signal selected

const DISTANCE_TO_CLICK = 8
const CurveStyle = FlowsheetLinkStyle.CurveStyle

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


func set_style(property: StringName, value) -> void:
	style_overrides[property] = value
	match property:
		&"visible":
			visible = value as bool
		&"line_width":
			_line.width = value as float
			_selection_indicator.width = (value as float) + 3
		&"line_colour":
			_line.default_color = value as Color
		&"text":
			pass # TODO: Not yet implemented
		&"text_offset":
			pass # TODO: Not yet implemented
		&"text_size":
			pass # TODO: Not yet implemented
		&"text_colour":
			pass # TODO: Not yet implemented
		&"text_font_name":
			pass # TODO: Not yet implemented
		&"icon_path":
			pass # TODO: Not yet implemented
		&"icon_offset":
			pass # TODO: Not yet implemented
		&"curve_style":
			_redraw_line()
		&"curve_param_1":
			_redraw_line()
		&"curve_param_2":
			_redraw_line()


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
	var curve_style: CurveStyle
	var curve_param_1: float
	var curve_param_2: float
	if style_overrides.has(&"curve_style"):
		curve_style = style_overrides[&"curve_style"]
	else:
		curve_style = CurveStyle.ELBOW # TODO: Get from default link style
	if style_overrides.has(&"curve_param_1"):
		curve_param_1 = style_overrides[&"curve_param_1"]
	else:
		curve_param_1 = 0.5 # TODO: Get from default link style
	if style_overrides.has(&"curve_param_2"):
		curve_param_2 = style_overrides[&"curve_param_2"]
	else:
		curve_param_2 = 0.5 # TODO: Get from default link style
	var source := source_node.position + source_node.connector_out.position + Vector2(12, 12)
	var target := target_node.position + target_node.connector_in.position + Vector2(12, 12)
	var midpoint := (source + target) / 2
	_path.curve.clear_points()
	match curve_style:
		CurveStyle.STRAIGHT:
			midpoint.x += curve_param_1
			midpoint.y += curve_param_1
			_path.curve.add_point(source)
			_path.curve.add_point(midpoint)
			_path.curve.add_point(target)
		CurveStyle.ELBOW:
			midpoint.x = source.x * (1 - curve_param_1) + target.x * curve_param_1
			var y_flip = 1 if target.y >= source.y else -1
			var radius := curve_param_2 * absf(target.y - source.y)
			var bend_1_before := Vector2(midpoint.x - radius, source.y)
			var bend_1_after := Vector2(midpoint.x, source.y + radius * y_flip)
			var bend_2_before := Vector2(midpoint.x, target.y - radius * y_flip)
			var bend_2_after := Vector2(midpoint.x + radius, target.y)
			_path.curve.add_point(source)
			_path.curve.add_point(bend_1_before)
			_path.curve.add_point(bend_1_after)
			_path.curve.add_point(midpoint)
			_path.curve.add_point(bend_2_before)
			_path.curve.add_point(bend_2_after)
			_path.curve.add_point(target)
			_path.curve.set_point_out(1, Vector2(radius, 0))
			_path.curve.set_point_in(2, Vector2(0, -radius * y_flip))
			_path.curve.set_point_out(4, Vector2(0, radius * y_flip))
			_path.curve.set_point_in(5, Vector2(-radius, 0))
		CurveStyle.BEZIER:
			var angle := curve_param_1
			var distance := curve_param_2 * (midpoint.x - source.x)
			_path.curve.add_point(source)
			_path.curve.add_point(midpoint)
			_path.curve.add_point(target)
			_path.curve.set_point_out(0, distance * Vector2.from_angle(angle))
			_path.curve.set_point_in(2, distance * Vector2.from_angle(angle + PI))
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
