class_name LinkReorderingLink
extends HBoxContainer

signal moved_up
signal moved_down

@export var incoming_node: FlowsheetNodeGui
@export var link: FlowsheetLinkGui
@export var can_move_up: bool = true:
	set(value):
		can_move_up = value
		if _up_button:
			_up_button.disabled = not can_move_up
@export var can_move_down: bool = true:
	set(value):
		can_move_down = value
		if _down_button:
			_down_button.disabled = not can_move_down
@onready var _node_id := $IncomingNodeId as Label
@onready var _node_value := $IncomingNodeValue as Label
@onready var _formula := $Formula as Label
@onready var _up_button := $MoveOptions/MoveUp as Button
@onready var _down_button := $MoveOptions/MoveDown as Button


func _ready() -> void:
	_up_button.pressed.connect(func(): moved_up.emit())
	_down_button.pressed.connect(func(): moved_down.emit())
	_down_button.disabled = not can_move_down
	_up_button.disabled = not can_move_up
	_node_id.text = "#" + incoming_node.name
	_node_value.text = "(%s)" % str(incoming_node.calculated_value) # TODO: Connect for this changing?
	_formula.text = link.data.formula
