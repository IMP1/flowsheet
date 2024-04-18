class_name CommandRunner
extends Node

signal command_ran(command: String)

@export var sheet: FlowsheetGui

var lua_context: LuaAPI


func run_command(command: String) -> void:
	print("[Command] Running Command")
	print(command)
	# TODO: Have an API object and don't just pass the entire sheet?
	lua_context = LuaAPI.new()
	lua_context.object_metatable.permissive = false
	lua_context.push_variant("Vector2", func(x, y): return Vector2(x, y))
	lua_context.push_variant("add_node", sheet.add_node)
	
	var result = lua_context.do_string(command)
	if result is LuaError:
		var err := result as LuaError
		push_error("[Command] Lua Error: " + err.message)
		return
		
	command_ran.emit(command)
