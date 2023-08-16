class_name PartialFlowsheetLinkGui
extends Control

signal deleted
signal selected

const DISTANCE_TO_CLICK = 8

@export var source_node: FlowsheetNodeGui
@export var target_position: Vector2

var _source_position: Vector2
var _target_position: Vector2

@onready var _path := $Path2D as Path2D
@onready var _line := $Line as CurvedLine2D


func _process(_delta: float) -> void:
	if not is_visible_in_tree():
		return
	if _source_position != source_node.position or _target_position != target_position:
		_redraw_line()
		_source_position = source_node.position
		_target_position = target_position


func _redraw_line() -> void:
	var source := source_node.position + source_node.connector_out.position + Vector2(12, 12)
	var target := target_position
	var midpoint := (source + target) / 2
	var anchor_size := (midpoint.x - source.x)
	_path.curve.clear_points()
	_path.curve.add_point(source)
	_path.curve.add_point(midpoint)
	_path.curve.add_point(target)
	_path.curve.set_point_out(0, Vector2(anchor_size, 0))
	_path.curve.set_point_in(2, Vector2(-anchor_size, 0))
	_line.calculate_line.call_deferred()
