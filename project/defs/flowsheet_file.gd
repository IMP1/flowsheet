class_name FlowsheetFile
extends Object


static func has_access(path: String) -> bool:
	# TODO: Not sure if this works as a way to test. Does it overwrite the file?
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("[File] %s" % FileAccess.get_open_error())
		return false
	var open := file.is_open()
	file.close()
	if not open:
		print("[File] %s" % file.get_error())
	return open


static func save_binary(sheet: Flowsheet, path: String) -> void:
	print("[File] Saving binary to '%s'." % path)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("[File] Cannot open '%s'" % path)
	var version: String = str(ProjectSettings.get_setting("application/config/version", "0.0.0"))
	file.store_pascal_string(version)
	file.store_32(sheet._current_id)
	file.store_32(sheet.nodes.size())
	for node in sheet.nodes:
		file.store_32(node.id)
		file.store_pascal_string(node.name)
		var type_and_editable: int = int(node.type)
		if node.accepts_input:
			type_and_editable += 128
		file.store_8(type_and_editable)
		file.store_var(node.initial_value)
		file.store_float(node.position.x)
		file.store_float(node.position.y)
	file.store_32(sheet.links.size())
	for link in sheet.links:
		file.store_32(link.source_id)
		file.store_32(link.target_id)
		file.store_16(link.target_ordering)
		file.store_pascal_string(link.formula)
	file.close()


static func load_binary(path: String) -> Flowsheet:
	print("[File] Loading binary from '%s'." % path)
	var sheet := Flowsheet.new()
	var file := FileAccess.open(path, FileAccess.READ)
	var version := file.get_pascal_string()
	if version == "0.1.0":
		load_binary_v0_1_0(sheet, file)
	elif version == "v0.1.0":
		push_warning("Deprecated Flowsheet version '%s'" % version)
		load_binary_v0_1_0(sheet, file)
	else:
		push_error("Unrecognised Flowsheet version '%s'" % version)
		load_binary_v0_1_0(sheet, file)
	file.close()
	return sheet


static func load_binary_v0_1_0(sheet: Flowsheet, file: FileAccess):
	sheet._current_id = file.get_32()
	var node_count := file.get_32()
	for i in node_count:
		var node := FlowsheetNode.new()
		node.id = file.get_32()
		node.name = file.get_pascal_string()
		var type_and_editable:= file.get_8()
		node.accepts_input = type_and_editable & 128
		if node.accepts_input:
			type_and_editable -= 128
		node.type = FlowsheetNode.Type.values()[type_and_editable] as FlowsheetNode.Type
		node.initial_value = file.get_var()
		node.position.x = file.get_float()
		node.position.y = file.get_float()
		sheet.add_node(node)
	var link_count := file.get_32()
	for i in link_count:
		var link := FlowsheetLink.new()
		link.source_id = file.get_32()
		link.target_id = file.get_32()
		link.target_ordering = file.get_16()
		link.formula = file.get_pascal_string()
		sheet.add_link(link)

