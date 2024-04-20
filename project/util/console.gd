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
	_setup_lua_context(lua_context)


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


func _setup_lua_context(context: LuaAPI) -> void:
	context.object_metatable.permissive = false
	# Object Constructors
	context.push_variant("Vector2", func(x:float, y:float): return Vector2(x, y))
	# Constants
	for t in FlowsheetNode.Type:
		context.push_variant("NODE_TYPE_%s" % t, FlowsheetNode.Type.get(t))
	
	# Sheet Commands
	context.push_variant("clear_sheet", sheet.clear_sheet)
	context.push_variant("select", sheet.select_item)
	context.push_variant("add_node", sheet.add_node)
	context.push_variant("add_link", sheet.add_link)
	context.push_variant("remove_node", sheet.delete_node)
	context.push_variant("remove_link", sheet.delete_link)
	context.push_variant("set_node_type", sheet.change_node_type)
	context.push_variant("set_node_editable", sheet.change_node_editable)
	context.push_variant("set_node_initial_value", sheet.change_node_value)
	context.push_variant("set_link_formula", sheet.change_link_formula)
	# Misc
	context.push_variant("print", _lua_print)

