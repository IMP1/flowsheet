extends Control

@onready var _input := $HBoxContainer/Input as LineEdit


func _grab_focus() -> void:
	_input.grab_focus.call_deferred()
