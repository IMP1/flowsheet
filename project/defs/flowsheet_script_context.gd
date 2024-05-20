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
"-- This function is called when the sheet loads.
function %s()
\t
end\n" % MAIN_SHEET_FUNCTION


static func setup_context(api: LuaAPI, context: LuaCoroutine, sheet: FlowsheetGui) -> void:
	var canvas := sheet.get_parent() as FlowsheetCanvas
	# TODO: Maybe this should be a coroutine that has a hook which awaits a process frame every instruction?
	#       Then lines can use nodes created in previous lines, it doesn't make flowsheet hang
	#       The only downside is that the scripts will take longer to run
	
	#context.object_metatable.permissive = false # TODO: Sets lua_fields() to a whitelist
	api.bind_libraries(["base", "table", "string", "math"])
	
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
	context.push_variant("get_sheet_size", func() -> Vector2: 
		return sheet.size)
	#context.push_variant("set_state", func(key: String, value: Variant) -> void: 
		#sheet.script_global_vars[key] = value)
	#context.push_variant("get_state", func(key: String) -> Variant: 
		#return sheet.script_global_vars.get(key, null))
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


static func execute_string(context: LuaCoroutine, code: String, sheet: FlowsheetGui) -> Variant:
	var state := State.from_dict(sheet.script_global_vars)
	state.data["TIME"] = 0
	context.push_variant("state", state)
	context.load_string(code)
	var result = context.resume([])
	if result is LuaError:
		var err := result as LuaError
		Logger.log_error(err.message)
		return null
	return result


class State:
	
	var data: Dictionary = {}
	
	func __index(ref: LuaAPI, index) -> Variant:
		return data.get(index, null)
	
	func __newindex(ref: LuaAPI, index, value):
		data[index] = value
	
	static func from_dict(dict: Dictionary) -> State:
		var s := State.new()
		s.data = dict
		return s
