extends Node

@export var console: Console


func log_error(message: String) -> void:
	if console:
		console.log_error(message)
	if OS.has_feature("debug"):
		push_error(message)


func log_warning(message: String) -> void:
	if console:
		console.log_warning(message)
	if OS.has_feature("debug"):
		push_warning(message)


func log_message(message: String) -> void:
	if console:
		console.log_message(message)
	if OS.has_feature("debug"):
		print(message)


func log_debug(message: String) -> void:
	if not OS.has_feature("debug"):
		return
	if console:
		console.log_message(message)
	print_debug(message)

