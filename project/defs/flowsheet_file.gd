class_name FlowsheetFile
extends RefCounted


static func has_access(path: String) -> bool:
	# TODO: Not sure if this works as a way to test. Does it overwrite the file?
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		Logger.log_error("[File] %s" % FileAccess.get_open_error())
		return false
	var open := file.is_open()
	file.close()
	if not open:
		print("[File] %s" % file.get_error())
	return open


static func save_binary(sheet: Flowsheet, path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		Logger.log_error("[File] Cannot open '%s'" % path)
	var version: String = str(ProjectSettings.get_setting("application/config/version", "0.0.0"))
	Logger.log_message("Saving v%s flowsheet file" % version)
	file.store_pascal_string(version)
	file.store_32(sheet._current_id)
	# Sheet Data
	file.store_32(sheet.size.x)
	file.store_32(sheet.size.y)
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
	# Sheet Style
	file.store_8(sheet.sheet_style.background_colour.r8)
	file.store_8(sheet.sheet_style.background_colour.g8)
	file.store_8(sheet.sheet_style.background_colour.b8)
	file.store_8(sheet.sheet_style.background_colour.a8)
	file.store_pascal_string(sheet.sheet_style.background_image_path)
	file.store_16(sheet.sheet_style.background_image_rect.position.x)
	file.store_16(sheet.sheet_style.background_image_rect.position.y)
	file.store_16(sheet.sheet_style.background_image_rect.size.x)
	file.store_16(sheet.sheet_style.background_image_rect.size.y)
	file.store_8(sheet.sheet_style.background_image_scaling)
	# Default Node Style
	file.store_8(int(sheet.default_node_style.visible))
	file.store_float(sheet.default_node_style.size.x)
	file.store_float(sheet.default_node_style.size.y)
	file.store_8(sheet.default_node_style.background_colour.r8)
	file.store_8(sheet.default_node_style.background_colour.g8)
	file.store_8(sheet.default_node_style.background_colour.b8)
	file.store_8(sheet.default_node_style.background_colour.a8)
	file.store_float(sheet.default_node_style.border_thickness)
	file.store_8(sheet.default_node_style.border_colour.r8)
	file.store_8(sheet.default_node_style.border_colour.g8)
	file.store_8(sheet.default_node_style.border_colour.b8)
	file.store_8(sheet.default_node_style.border_colour.a8)
	file.store_8(sheet.default_node_style.corner_radius)
	file.store_8(sheet.default_node_style.text_size)
	file.store_8(sheet.default_node_style.text_colour.r8)
	file.store_8(sheet.default_node_style.text_colour.g8)
	file.store_8(sheet.default_node_style.text_colour.b8)
	file.store_8(sheet.default_node_style.text_colour.a8)
	file.store_pascal_string(sheet.default_node_style.text_font_name)
	file.store_pascal_string(sheet.default_node_style.background_image_path)
	file.store_16(sheet.default_node_style.background_image_rect.position.x)
	file.store_16(sheet.default_node_style.background_image_rect.position.y)
	file.store_16(sheet.default_node_style.background_image_rect.size.x)
	file.store_16(sheet.default_node_style.background_image_rect.size.y)
	file.store_8(sheet.default_node_style.background_image_scaling)
	# Default Link Style
	file.store_8(int(sheet.default_link_style.visible))
	file.store_float(sheet.default_link_style.line_width)
	file.store_8(sheet.default_link_style.line_colour.r8)
	file.store_8(sheet.default_link_style.line_colour.g8)
	file.store_8(sheet.default_link_style.line_colour.b8)
	file.store_8(sheet.default_link_style.line_colour.a8)
	file.store_pascal_string(sheet.default_link_style.text)
	file.store_float(sheet.default_link_style.text_offset)
	file.store_8(sheet.default_link_style.text_size)
	file.store_8(sheet.default_link_style.text_colour.r8)
	file.store_8(sheet.default_link_style.text_colour.g8)
	file.store_8(sheet.default_link_style.text_colour.b8)
	file.store_8(sheet.default_link_style.text_colour.a8)
	file.store_pascal_string(sheet.default_link_style.text_font_name)
	file.store_pascal_string(sheet.default_link_style.icon_path)
	file.store_float(sheet.default_link_style.icon_offset)
	file.store_8(sheet.default_link_style.curve_style)
	file.store_float(sheet.default_link_style.curve_param_1)
	file.store_float(sheet.default_link_style.curve_param_2)
	# Node Styles
	file.store_32(sheet.node_styles.size())
	for n in sheet.node_styles:
		var node := n as FlowsheetNode
		var overrides := sheet.node_styles[node] as Dictionary
		file.store_32(node.id)
		file.store_8(overrides.size())
		for k in overrides:
			var key := k as String
			var value = overrides[key]
			file.store_pascal_string(key)
			file.store_var(value) # TEST: Does this work?
	# Link Styles
	file.store_32(sheet.link_styles.size())
	for n in sheet.link_styles:
		var link := n as FlowsheetLink
		var overrides := sheet.link_styles[link] as Dictionary
		file.store_32(link.source_id)
		file.store_32(link.target_id)
		file.store_8(overrides.size())
		for k in overrides:
			var key := k as String
			var value = overrides[key]
			file.store_pascal_string(key)
			file.store_var(value) # TEST: Does this work?
	# Scripts
	file.store_pascal_string(sheet.sheet_script)
	file.store_32(sheet.node_scripts.size())
	for n in sheet.node_scripts:
		var node := n as FlowsheetNode
		var script := sheet.node_scripts[node] as String
		file.store_32(node.id)
		file.store_pascal_string(script)
	file.close()


static func load_binary(path: String) -> Flowsheet:
	var sheet := Flowsheet.new()
	var file := FileAccess.open(path, FileAccess.READ)
	var version := file.get_pascal_string()
	Logger.log_message("Loading v%s flowsheet file" % version)
	if version.begins_with("0.3."):
		load_binary_v0_3(sheet, file)
	elif version.begins_with("0.2."):
		load_binary_v0_2(sheet, file)
	elif version.begins_with("0.1."):
		load_binary_v0_1(sheet, file)
	else:
		Logger.log_error("Unrecognised Flowsheet version '%s'" % version)
		load_binary_v0_1(sheet, file)
	file.close()
	return sheet


static func load_binary_v0_1(sheet: Flowsheet, file: FileAccess) -> void:
	sheet._current_id = file.get_32()
	sheet.size.x = file.get_32()
	sheet.size.y = file.get_32()
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


static func load_binary_v0_2(sheet: Flowsheet, file: FileAccess) -> void:
	load_binary_v0_1(sheet, file)
	# Sheet Style
	var r: int
	var g: int
	var b: int
	var a: int
	r = file.get_8()
	g = file.get_8()
	b = file.get_8()
	a = file.get_8()
	sheet.sheet_style.background_colour = Color8(r, g, b, a)
	sheet.sheet_style.background_image_path = file.get_pascal_string()
	var x: int
	var y: int
	var w: int
	var h: int
	x = file.get_16()
	y = file.get_16()
	w = file.get_16()
	h = file.get_16()
	sheet.sheet_style.background_image_rect = Rect2i(x, y, w, h)
	sheet.sheet_style.background_image_scaling = file.get_8() as FlowsheetStyle.StretchMode
	# Default Node Style
	sheet.default_node_style.visible = bool(file.get_8())
	sheet.default_node_style.size.x = file.get_float()
	sheet.default_node_style.size.y = file.get_float()
	r = file.get_8()
	g = file.get_8()
	b = file.get_8()
	a = file.get_8()
	sheet.default_node_style.background_colour = Color8(r, g, b, a)
	sheet.default_node_style.border_thickness = file.get_float()
	r = file.get_8()
	g = file.get_8()
	b = file.get_8()
	a = file.get_8()
	sheet.default_node_style.border_colour = Color8(r, g, b, a)
	sheet.default_node_style.corner_radius = file.get_8()
	sheet.default_node_style.text_size = file.get_8()
	r = file.get_8()
	g = file.get_8()
	b = file.get_8()
	a = file.get_8()
	sheet.default_node_style.text_colour = Color8(r, g, b, a)
	sheet.default_node_style.text_font_name = file.get_pascal_string()
	sheet.default_node_style.background_image_path = file.get_pascal_string()
	x = file.get_16()
	y = file.get_16()
	w = file.get_16()
	h = file.get_16()
	sheet.default_node_style.background_image_rect = Rect2i(x, y, w, h)
	sheet.default_node_style.background_image_scaling = file.get_8() as FlowsheetNodeStyle.StretchMode
	# Default Link Style
	sheet.default_link_style.visible = bool(file.get_8())
	sheet.default_link_style.line_width = file.get_float()
	r = file.get_8()
	g = file.get_8()
	b = file.get_8()
	a = file.get_8()
	sheet.default_link_style.line_colour = Color8(r, g, b, a)
	sheet.default_link_style.text = file.get_pascal_string()
	sheet.default_link_style.text_offset = file.get_float()
	sheet.default_link_style.text_size = file.get_8()
	r = file.get_8()
	g = file.get_8()
	b = file.get_8()
	a = file.get_8()
	sheet.default_link_style.text_colour = Color8(r, g, b, a)
	sheet.default_link_style.text_font_name = file.get_pascal_string()
	sheet.default_link_style.icon_path = file.get_pascal_string()
	sheet.default_link_style.icon_offset = file.get_float()
	sheet.default_link_style.curve_style = file.get_8() as FlowsheetLinkStyle.CurveStyle
	sheet.default_link_style.curve_param_1 = file.get_float()
	sheet.default_link_style.curve_param_2 = file.get_float()
	# Node Styles
	sheet.node_styles = {}
	var styled_node_count := file.get_32()
	for i in styled_node_count:
		var node_id := file.get_32()
		var override_count := file.get_8()
		var node := sheet.get_node(node_id)
		sheet.node_styles[node] = {}
		for j in override_count:
			var key := file.get_pascal_string()
			var value = file.get_var() # TEST: Does this work?
			sheet.node_styles[node][key] = value
	# Link Styles
	sheet.link_styles = {}
	var styled_link_count := file.get_32()
	for i in styled_link_count:
		var source_id := file.get_32()
		var target_id := file.get_32()
		var override_count := file.get_8()
		var link := sheet.get_links_between(sheet.get_node(source_id), sheet.get_node(target_id))[0]
		sheet.link_styles[link] = {}
		for j in override_count:
			var key := file.get_pascal_string()
			var value = file.get_var() # TEST: Does this work?
			sheet.link_styles[link][key] = value


static func load_binary_v0_3(sheet: Flowsheet, file: FileAccess) -> void:
	load_binary_v0_2(sheet, file)
	sheet.sheet_script = file.get_pascal_string()
	var script_count := file.get_32()
	sheet.node_scripts = {}
	for i in script_count:
		var node_id := file.get_32()
		var script_text := file.get_pascal_string()
		var node := sheet.get_node(node_id)
		sheet.node_scripts[node] = script_text
