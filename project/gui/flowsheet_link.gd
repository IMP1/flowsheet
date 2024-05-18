class_name FlowsheetLinkGui
extends Control

signal node_deleted
signal selected

const INVISIBLE_COLOUR := Color(Color.WHITE, 0.2)
const DISTANCE_TO_CLICK := 8
const CurveStyle := FlowsheetLinkStyle.CurveStyle

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
@onready var _icon := $Path2D/PathFollow2D/Icon as Sprite2D
@onready var _icon_offset := $Path2D/PathFollow2D as PathFollow2D
@onready var _text := $CurvedText2D as CurvedText2D


func _ready() -> void:
	unselect()
	source_node.deleted.connect(func(): node_deleted.emit())
	target_node.deleted.connect(func(): node_deleted.emit())
	# TODO: Use Project.sheet.default_node_styles to style node


func set_formula(code: String) -> void:
	data.formula = code
	if code.is_empty():
		formula = null
		return
	var expr := FlowsheetFormula.new()
	var parse_result := expr.parse(code)
	if parse_result != OK:
		Logger.log_error("Couldn't parse formula '%s'.\n%s" % [code, expr.get_error_text()])
		formula = null
		return
	formula = expr


func set_style(property: StringName, value) -> void:
	style_overrides[property] = value
	refresh_style()


func refresh_style() -> void:
	var is_invisible: bool
	if style_overrides.has(&"visible"):
		is_invisible = not style_overrides[&"visible"] as bool
	else:
		is_invisible = not Project.sheet.default_link_style.visible
	if is_invisible and Project.view_mode == FlowsheetCanvas.View.TEST:
		visible = false
	else:
		visible = true
	if is_invisible and Project.view_mode == FlowsheetCanvas.View.STYLE:
		modulate = INVISIBLE_COLOUR
	else:
		modulate = Color.WHITE
	
	var width: float
	if style_overrides.has(&"line_width"):
		width = style_overrides[&"line_width"] as int
	else:
		width = Project.sheet.default_link_style.line_width
	_line.width = width
	_selection_indicator.width = width + 3
	_text.vertical_offset = width + 6.0
	
	if style_overrides.has(&"line_colour"):
		_line.default_color = style_overrides[&"line_colour"] as Color
	else:
		_line.default_color = Project.sheet.default_link_style.line_colour
	
	if style_overrides.has(&"text"):
		_text.text = style_overrides[&"text"] as String
	else:
		_text.text = Project.sheet.default_link_style.text
	
	if style_overrides.has(&"text_offset"):
		_text.path_offset_ratio = style_overrides[&"text_offset"] as float
	else:
		_text.path_offset_ratio = Project.sheet.default_link_style.text_offset
	
	if style_overrides.has(&"text_size"):
		_text.text_size = style_overrides[&"text_size"] as int
	else:
		_text.text_size = Project.sheet.default_link_style.text_size
	
	if style_overrides.has(&"text_colour"):
		_text.colour = style_overrides[&"text_colour"] as Color
	else:
		_text.colour = Project.sheet.default_link_style.text_colour
	
	var font_name: String
	if style_overrides.has(&"text_font_name"):
		font_name = style_overrides[&"text_font_name"] as String
	else:
		font_name = Project.sheet.default_link_style.text_font_name
	_text.font = Project.get_font(font_name)
	
	var icon_path: String
	if style_overrides.has(&"icon_path"):
		icon_path = style_overrides[&"icon_path"] as String
	else:
		icon_path = Project.sheet.default_link_style.icon_path
	if not icon_path.is_empty():
		var image := Image.load_from_file(icon_path)
		var texture := ImageTexture.create_from_image(image)
		_icon.texture = texture
	
	if style_overrides.has(&"icon_offset"):
		_icon_offset.progress_ratio = style_overrides[&"icon_offset"] as float
	else:
		_icon_offset.progress_ratio = Project.sheet.default_link_style.icon_offset
	
	_redraw_line()


func _set_view_mode(view: FlowsheetCanvas.View) -> void:
	match view:
		FlowsheetCanvas.View.EDIT:
			_selection_indicator.visible = _is_selected
			_is_selectable = true
			modulate = Color.WHITE
			visible = true
		FlowsheetCanvas.View.STYLE:
			_selection_indicator.visible = _is_selected
			_is_selectable = true
			modulate = Color.WHITE
			visible = true
			if style_overrides.has(&"visible") and not style_overrides[&"visible"]:
				modulate = INVISIBLE_COLOUR
			elif not Project.sheet.default_link_style.visible:
				modulate = INVISIBLE_COLOUR
		FlowsheetCanvas.View.TEST:
			_selection_indicator.visible = false
			_is_selectable = false
			modulate = Color.WHITE
			visible = true
			if style_overrides.has(&"visible") and not style_overrides[&"visible"]:
				visible = false
			elif not Project.sheet.default_link_style.visible:
				visible = false


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
		curve_style =  Project.sheet.default_link_style.curve_style
	if style_overrides.has(&"curve_param_1"):
		curve_param_1 = style_overrides[&"curve_param_1"]
	else:
		curve_param_1 = Project.sheet.default_link_style.curve_param_1
	if style_overrides.has(&"curve_param_2"):
		curve_param_2 = style_overrides[&"curve_param_2"]
	else:
		curve_param_2 = Project.sheet.default_link_style.curve_param_2
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


#------------------------------#
# Scripting Related Sandboxing #
#------------------------------#


func __index(ref: LuaAPI, index) -> Variant:
	if index == "source":
		return source_node
	if index == "target":
		return target_node
	if index == "formula":
		return formula
	return null


func __newindex(ref: LuaAPI, index, value) -> void:
	pass # Ignore attempts to set fields

