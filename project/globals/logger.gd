extends Node

@export var console: Console


func log_error(message) -> void:
	if console:
		console.log_error(str(message))
	if OS.has_feature("debug"):
		push_error(message)


func log_warning(message) -> void:
	if console:
		console.log_warning(str(message))
	if OS.has_feature("debug"):
		push_warning(message)


func log_message(message) -> void:
	if console:
		console.log_message(str(message))
	if OS.has_feature("debug"):
		print(message)


func log_debug(message) -> void:
	if not OS.has_feature("debug"):
		return
	if console:
		console.log_message(str(message))
	print_debug(message)

