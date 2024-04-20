extends Node

@export var console: Console


func log_error(message: String) -> void:
	console.log_error(message)
	if OS.has_feature("debug"):
		push_error(message)


func log_message(message: String) -> void:
	console.log_message(message)
	if OS.has_feature("debug"):
		print(message)

