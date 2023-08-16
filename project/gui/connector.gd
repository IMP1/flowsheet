class_name FlowsheetNodeConnector
extends Panel

signal starting_connection
signal ending_connection(source: int, target: int)

enum Type { OUTPUT, INPUT }

@export var type: Type
@export var node_id: int = -1

var _accepting_connection: bool = false

@onready var _selection_indicator := $Highlight as Control


func accept_connections() -> void:
	_accepting_connection = true
	_selection_indicator.visible = true


func reject_connections() -> void:
	_accepting_connection = false
	_selection_indicator.visible = false


func _get_drag_data(_at_position: Vector2):
	if type == Type.INPUT:
		return null
	starting_connection.emit()
	return node_id


func _can_drop_data(_at_position: Vector2, _data) -> bool:
	return _accepting_connection


func _drop_data(_at_position: Vector2, data) -> void:
	ending_connection.emit(data, node_id)
