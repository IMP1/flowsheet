class_name Console
extends Control

signal command_ran(command: String)

@export var sheet: FlowsheetGui

var lua_context: LuaAPI

@onready var _input := $Input/CodeEdit as CodeEdit
@onready var _log := $Log/Contents/Text as RichTextLabel


func _ready() -> void:
	_input.text_submitted.connect(func(text: String):
		_input.clear()
		run_command(text))
	lua_context = LuaAPI.new()
	FlowsheetScriptContext.setup_context(lua_context, sheet)
	#_setup_lua_context(lua_context)


func _grab_focus() -> void:
	_input.grab_focus.call_deferred()


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
	var result = lua_context.do_string(command)
	if result is LuaError:
		var err := result as LuaError
		log_error(err.message)
		return
	command_ran.emit(command)


func _lua_print(message) -> void:
	print(message)
	log_message(str(message))
