class_name Console
extends Control

signal command_ran(command: String)

@export var sheet: FlowsheetGui

var lua_context: LuaAPI

@onready var _command_input := $Input/CodeEdit as CodeEdit
@onready var _log := $Log/Contents/Text as RichTextLabel


func _ready() -> void:
	_command_input.text_submitted.connect(func(text: String):
		_command_input.clear()
		run_command(text))
	focus_entered.connect(_grab_focus)
	lua_context = LuaAPI.new()
	FlowsheetScriptContext.setup_context(lua_context, sheet)


func _grab_focus() -> void:
	_command_input.grab_focus.call_deferred()


func log_message(message: String) -> void:
	_log.newline()
	_log.append_text(message)
	_log.scroll_to_line(_log.get_line_count()-1)


func log_error(message: String) -> void:
	_log.newline()
	_log.push_color(Color.RED)
	_log.append_text(message)
	_log.pop()
	_log.scroll_to_line(_log.get_line_count()-1)


func log_warning(message: String) -> void:
	_log.newline()
	_log.push_color(Color.ORANGE)
	_log.append_text(message)
	_log.pop()
	_log.scroll_to_line(_log.get_line_count()-1)


func run_command(command: String) -> void:
	log_message(">>> " + command)
	FlowsheetScriptContext.execute_string(lua_context, command, sheet)
	command_ran.emit(command)


func _input(event: InputEvent) -> void:
	if not get_viewport().gui_get_focus_owner():
		return
	if get_viewport().gui_get_focus_owner() != _command_input:
		return
	if event.is_action_pressed(&"cancel"):
		_command_input.release_focus()
