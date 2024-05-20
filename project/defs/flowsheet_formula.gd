class_name FlowsheetFormula
extends RefCounted

# TODO: Make this its own thing D:
#var _lua_context: LuaAPI
#var _formula: String
#var _lua_error: LuaError

var _expr: Expression = Expression.new()

#
#func _setup_lua_context(context: LuaAPI) -> void:
	#context.object_metatable.permissive = false
	## Formulae
	#context.push_variant("clear_sheet", 0)


func parse(code: String) -> Error:
	#_formula = "return " + code
	#return OK
	return _expr.parse(code, ["IN", "OUT"])


func execute(in_value, out_value):
	#_lua_error = null
	#_lua_context = LuaAPI.new()
	#_setup_lua_context(_lua_context)
	#_lua_context.push_variant("IN", in_value)
	#_lua_context.push_variant("OUT", out_value)
	#
	#var result = _lua_context.do_string(_formula)
	#if result is LuaError:
		#var err := result as LuaError
		#Logger.log_error(err.message)
		#return null
	#return result
	var args := [in_value, out_value]
	var context := FlowsheetFormulaContext.new()
	return _expr.execute(args, context)


func get_error_text() -> String:
	#return _lua_error.message
	return _expr.get_error_text()


func has_execute_failed() -> bool:
	#return _lua_error != null
	return _expr.has_execute_failed()
