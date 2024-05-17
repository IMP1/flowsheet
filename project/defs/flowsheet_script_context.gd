class_name FlowsheetScriptContext
extends RefCounted

const MAIN_NODE_FUNCTION := "value_changed"
const DEFAULT_NODE_CODE := \
"-- This function is called when the node's value changes.
function %s(new_value)
\t
end\n" % MAIN_NODE_FUNCTION

const MAIN_SHEET_FUNCTION := "sheet_loaded"
const DEFAULT_SHEET_CODE := \
"-- This function is called when the node's value changes.
function %s(new_value)
\t
end\n" % MAIN_SHEET_FUNCTION


static func setup_context(context: LuaAPI, sheet: FlowsheetGui) -> void:
	var canvas := sheet.get_parent() as FlowsheetCanvas
	# TODO: Maybe this should be a coroutine that has a hook which awaits a process frame every instruction?
	#       Then lines can use nodes created in previous lines, it doesn't make flowsheet hang
	#       The only downside is that the scripts will take longer to run
	
	context.object_metatable.permissive = false # TODO: Sets lua_fields() to a whitelist
	context.bind_libraries(["base", "table", "string", "math"])
	
	# Object Constructors
	context.push_variant("Vec2", func(x:float, y:float): return Vector2(x, y))
	context.push_variant("Color", func(r:float, g:float, b:float, a:float): return Color(r, g, b, a))
	
	# Constants
	for t in FlowsheetNode.Type:
		context.push_variant("NODE_TYPE_%s" % t, FlowsheetNode.Type.get(t))
	
	# Misc Functions
	context.push_variant("print", Logger.log_message)
	
	# Sheet Commands
	context.push_variant("clear_sheet", sheet.clear_sheet)
	context.push_variant("import_sheet", sheet.import_sheet)
	context.push_variant("resize_sheet_edge", canvas._resize_sheet_edge)
	context.push_variant("select", sheet.select_item)
	context.push_variant("get_all_nodes", sheet._node_list.get_children)
	context.push_variant("get_all_links", sheet._link_list.get_children)
	context.push_variant("get_sheet_size", func() -> Vector2: return sheet.size)
	# Node Commands
	context.push_variant("add_node", sheet.add_node)
	context.push_variant("remove_node", sheet.delete_node)
	context.push_variant("duplicate_node", sheet.duplicate_node)
	context.push_variant("set_node_type", sheet.set_node_type)
	context.push_variant("set_node_editable", sheet.set_node_editable)
	context.push_variant("set_node_initial_value", sheet.set_node_value)
	context.push_variant("set_node_style", sheet.set_node_style)
	context.push_variant("get_node", sheet.get_node_by_id)
	context.push_variant("move_node_to", sheet.move_node_to)
	context.push_variant("move_node_by", sheet.move_node_by)
	# Link Commands
	context.push_variant("add_link", sheet.add_link)
	context.push_variant("remove_link", sheet.delete_link)
	context.push_variant("set_link_formula", sheet.set_link_formula)
	context.push_variant("set_link_style", sheet.set_link_style)
	context.push_variant("get_link", sheet.get_link_by_ids)
	# Styles
	context.push_variant("set_sheet_style", sheet.set_sheet_style)
	context.push_variant("set_default_node_style", sheet.set_default_node_style)
	context.push_variant("set_default_link_style", sheet.set_default_link_style)
	# Scripts
	context.push_variant("set_sheet_script", sheet.set_sheet_script)
	context.push_variant("set_node_script", sheet.set_node_script)


static func execute_string(context: LuaAPI, code: String, sheet: FlowsheetGui) -> Variant:
	Logger.log_message("Current Script State:")
	Logger.log_message(str(sheet.script_global_vars))
	context.push_variant("state", sheet.script_global_vars)
	var result = context.do_string(code)
	if result is LuaError:
		var err := result as LuaError
		Logger.log_error(err.message)
		return null
	sheet.script_global_vars = context.pull_variant("state")
	return result


