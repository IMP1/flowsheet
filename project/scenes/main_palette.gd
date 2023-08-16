extends Panel

signal tool_chosen(tool: Tool)

enum Tool {
	SELECTION,
	MOVE_ITEMS,
	ADD_NODE,
	CONNECT_NODES,
	# TODO: Add style tools
	# TODO: Think about what tools there actually are
}


