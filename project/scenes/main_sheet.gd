class_name FlowsheetGui
extends Panel

signal item_selected(item)
signal node_changes_made
signal sheet_changes_made # TODO: Have undo and redo actions sent with the signal

const NODE_OBJ := preload("res://gui/flowsheet_node.tscn") as PackedScene
const LINK_OBJ := preload("res://gui/flowsheet_link.tscn") as PackedScene

@export var cursor_icon: Control
@export var console: Console
@export var draw_grid: bool = true

var sheet: Flowsheet = Flowsheet.new()
var _graph: Graph = Graph.new()
var _selected_item
var _ignore_propogation: bool = false
var _adding_node: bool = false

@onready var _node_list := $Nodes as Control
@onready var _link_list := $Links as Control
@onready var _partial_link := $PartialFlowsheetLink as PartialFlowsheetLinkGui


func _ready() -> void:
	clear_sheet()


func clear_sheet() -> void:
	_graph = Graph.new()
	sheet = Flowsheet.new()
	for child in _node_list.get_children():
		_node_list.remove_child(child)
	for child in _link_list.get_children():
		_link_list.remove_child(child)
	_partial_link.visible = false
	cursor_icon.visible = false
	select_item.call_deferred(null)
	queue_redraw()


func import_sheet(new_sheet: Flowsheet) -> void:
	var id_offset := sheet.get_next_id()
	for data in new_sheet.nodes:
		var node_data := data.duplicate()
		node_data.id += id_offset
		sheet.add_node(node_data)
		# Add to view
		var node := NODE_OBJ.instantiate() as FlowsheetNodeGui
		node.name = str(node_data.id)
		node.data = node_data
		node.selected.connect(select_item.bind(node))
		node.connection_started.connect(_start_connection.bind(node))
		node.connection_ended.connect(_end_connection)
		node.initial_value_changed.connect(func(): 
			_propogate_values()
			node_changes_made.emit()
			sheet_changes_made.emit())
		node.moved.connect(func(): 
			sheet_changes_made.emit())
		_node_list.add_child.call_deferred(node)
		node.set_deferred("position", node_data.position)
		# Add to graph
		_graph.add_node(node_data.id)
	await get_tree().process_frame
	await get_tree().process_frame
	for data in new_sheet.links:
		var link_data := data.duplicate()
		link_data.source_id += id_offset
		link_data.target_id += id_offset
		sheet.add_link(link_data)
		# Add to view
		var link := LINK_OBJ.instantiate() as FlowsheetLinkGui
		link.data = link_data
		link.source_node = _node_list.get_node(str(link_data.source_id)) as FlowsheetNodeGui
		link.target_node = _node_list.get_node(str(link_data.target_id)) as FlowsheetNodeGui
		link.set_formula(link.data.formula)
		link.selected.connect(select_item.bind(link))
		link.node_deleted.connect(delete_link.bind(link))
		_link_list.add_child(link)
		# Add to graph
		_graph.connect_nodes(link_data.source_id, link_data.target_id)
	await get_tree().process_frame
	_propogate_values()


func open_sheet(new_sheet: Flowsheet) -> void:
	clear_sheet()
	sheet = new_sheet
	for node_data in sheet.nodes:
		# Add to view
		var node := NODE_OBJ.instantiate() as FlowsheetNodeGui
		node.name = str(node_data.id)
		node.data = node_data
		node.selected.connect(select_item.bind(node))
		node.connection_started.connect(_start_connection.bind(node))
		node.connection_ended.connect(_end_connection)
		node.initial_value_changed.connect(func(): 
			_propogate_values()
			node_changes_made.emit()
			sheet_changes_made.emit())
		node.moved.connect(func(): 
			sheet_changes_made.emit())
		_node_list.add_child.call_deferred(node)
		node.set_deferred("position", node_data.position)
		# Add to graph
		_graph.add_node(node_data.id)
	await get_tree().process_frame
	await get_tree().process_frame
	for link_data in sheet.links:
		# Add to view
		var link := LINK_OBJ.instantiate() as FlowsheetLinkGui
		link.data = link_data
		link.source_node = _node_list.get_node(str(link_data.source_id)) as FlowsheetNodeGui
		link.target_node = _node_list.get_node(str(link_data.target_id)) as FlowsheetNodeGui
		link.set_formula(link.data.formula)
		link.selected.connect(select_item.bind(link))
		link.node_deleted.connect(delete_link.bind(link))
		_link_list.add_child(link)
		# Add to graph
		_graph.connect_nodes(link_data.source_id, link_data.target_id)
	await get_tree().process_frame
	_propogate_values()


func select_item(item) -> void:
	if item == _selected_item:
		return
	if _selected_item:
		_selected_item.unselect()
	_selected_item = item
	if _selected_item != null:
		_selected_item.select()
	item_selected.emit(_selected_item)


func add_node(pos: Vector2) -> FlowsheetNodeGui:
	var id := sheet.get_next_id()
	print("[Sheet] Adding node %d" % id)
	# Add to model
	var node_data := FlowsheetNode.new()
	node_data.id = id
	node_data.position = pos
	sheet.add_node(node_data)
	# Add to view
	var node := NODE_OBJ.instantiate() as FlowsheetNodeGui
	node.name = str(id)
	node.data = node_data
	node.selected.connect(select_item.bind(node))
	node.connection_started.connect(_start_connection.bind(node))
	node.connection_ended.connect(_end_connection)
	node.initial_value_changed.connect(func(): 
		_propogate_values()
		node_changes_made.emit()
		sheet_changes_made.emit())
	node.moved.connect(func(): 
		sheet_changes_made.emit())
	_node_list.add_child.call_deferred(node)
	node.set_deferred("position", pos)
	select_item.call_deferred(node)
	# Add to graph
	_graph.add_node(id)
	sheet_changes_made.emit()
	return node


func add_link(source: FlowsheetNodeGui, target: FlowsheetNodeGui) -> FlowsheetLinkGui:
	print("[Sheet] Adding link between %d and %d" % [source.data.id, target.data.id])
	# Add to model
	var link_data := FlowsheetLink.new()
	link_data.source_id = source.data.id
	link_data.target_id = target.data.id
	link_data.target_ordering = 0 # TODO: Get this somehow
	link_data.formula = "" # TODO: What should a default be?
	sheet.add_link(link_data)
	# Add to view
	var link := LINK_OBJ.instantiate() as FlowsheetLinkGui
	link.data = link_data
	link.source_node = source
	link.target_node = target
	link.selected.connect(select_item.bind(link))
	link.node_deleted.connect(delete_link.bind(link))
	_link_list.add_child.call_deferred(link)
	select_item.call_deferred(link)
	# Add to graph
	_graph.connect_nodes(source.data.id, target.data.id)
	_propogate_values()
	return link


func duplicate_link(link: FlowsheetLinkGui) -> void:
	pass # TODO


func duplicate_node(node: FlowsheetNodeGui) -> void:
	pass # TODO


func delete_link(link: FlowsheetLinkGui) -> void:
	if link == _selected_item:
		print("[Sheet] Unselecting Link %d->%d" % [link.source_node.data.id, link.target_node.data.id])
		select_item(null)
	print("[Sheet] Deleting Link %d->%d" % [link.source_node.data.id, link.target_node.data.id])
	sheet.remove_link(link.data)
	_link_list.remove_child(link)
	link.queue_free()
	var source := link.source_node.data
	var target := link.target_node.data
	if sheet.get_links_between(source, target).size() == 0:
		_graph.disconnect_nodes(source.id, target.id)
	if not _ignore_propogation:
		_propogate_values.call_deferred()


func delete_node(node: FlowsheetNodeGui) -> void:
	if node == _selected_item:
		print("[Sheet] Unselecting Node %d" % node.data.id)
		select_item(null)
	# Wrapping the signal in code to ignore propogation is to stop the links' 
	# deletion also propogating values prematurely
	_ignore_propogation = true 
	node.deleted.emit()
	_ignore_propogation = false
	print("[Sheet] Deleting Node %d" % node.data.id)
	_graph.remove_node(node.data.id)
	sheet.remove_node(node.data)
	_node_list.remove_child(node)
	node.queue_free()
	_propogate_values.call_deferred()


func change_node_type(node: FlowsheetNodeGui, new_type: FlowsheetNode.Type) -> void:
	node.set_type(new_type)
	_propogate_values()


func change_node_value(node: FlowsheetNodeGui, value) -> void:
	node.set_inital_value(value)
	_propogate_values()


func change_node_editable(node: FlowsheetNodeGui, editable: bool) -> void:
	node.set_editable(editable)
	_propogate_values()


func change_link_formula(link: FlowsheetLinkGui, code: String) -> void:
	link.set_formula(code)
	_propogate_values()


func duplicate_selected_item() -> void:
	if not _selected_item:
		console.log_error("[Sheet] ERROR: No item to duplicate")
		return
	if _selected_item is FlowsheetLinkGui:
		duplicate_link(_selected_item as FlowsheetLinkGui)
	elif _selected_item is FlowsheetNodeGui:
		duplicate_node(_selected_item as FlowsheetNodeGui)


func delete_selected_item() -> void:
	if not _selected_item:
		console.log_error("[Sheet] ERROR: No item to delete")
		return
	if _selected_item is FlowsheetLinkGui:
		delete_link(_selected_item as FlowsheetLinkGui)
	elif _selected_item is FlowsheetNodeGui:
		delete_node(_selected_item as FlowsheetNodeGui)


func _propogate_values(changed_node = null) -> void:
	if changed_node == null:
		for id in _graph._root_nodes:
			var node = _node_list.get_node(str(id))
			_propogate_values(node)
		return
	_calculate_value(changed_node)
	for child_id in _graph.children(changed_node.data.id):
		var child_node = _node_list.get_node(str(child_id))
		_propogate_values(child_node)
	sheet_changes_made.emit()


func _calculate_value(node: FlowsheetNodeGui) -> void:
	var value = node.data.initial_value
	for l in _link_list.get_children():
		var link := l as FlowsheetLinkGui
		if link.target_node == node:
			var expr := link.formula
			if expr == null:
				continue
			var result = expr.execute([link.source_node.calculated_value, value])
			if expr.has_execute_failed():
				console.log_error("Couldn't execute formula.\n%s" % expr.get_error_text())
				continue
			value = result
	node.calculated_value = value


func _start_connection(source: FlowsheetNodeGui) -> void:
	_partial_link.source_node = source
	_partial_link.visible = true
	for n in _node_list.get_children():
		var node := n as FlowsheetNodeGui
		if node == source:
			continue
		if not _graph.is_descendent_of(source.data.id, node.data.id):
			node.connector_in.accept_connections()


func _end_connection(source_id: int, target_id: int) -> void:
	var source := _node_list.get_node(str(source_id)) as FlowsheetNodeGui
	var target := _node_list.get_node(str(target_id)) as FlowsheetNodeGui
	add_link(source, target)
	_cancel_connection()


func _cancel_connection() -> void:
	if not _partial_link.is_visible_in_tree():
		return
	_partial_link.visible = false
	for n in _node_list.get_children():
		var node := n as FlowsheetNodeGui
		node.connector_in.reject_connections()


func is_valid_node_position(pos: Vector2) -> bool:
	if pos.x < 0 or pos.y < 0 or pos.x > size.x or pos.y > size.y:
		return false
	return true


func _process(_delta: float) -> void:
	if _partial_link.visible:
		_partial_link.target_position = get_local_mouse_position()
	if _adding_node:
		cursor_icon.global_position = get_global_mouse_position()
		cursor_icon.visible = is_valid_node_position(get_local_mouse_position())


func _palette_option_selected(index: int) -> void:
	match index:
		0:
			_adding_node = true
			cursor_icon.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if _partial_link.is_visible_in_tree() and event.is_action_pressed(&"drag_cancel"):
		_cancel_connection()
	if event.is_action_pressed(&"unselect"):
		select_item(null)
	if event.is_action_pressed(&"delete_node") and _selected_item is FlowsheetNodeGui:
		delete_selected_item()
	if event.is_action_pressed(&"delete_link") and _selected_item is FlowsheetLinkGui:
		delete_selected_item()
	if event.is_action_pressed(&"add_node"):
		_adding_node = true
		cursor_icon.visible = true
	if event.is_action_pressed(&"cancel") and _adding_node:
		_adding_node = false
		cursor_icon.visible = false
	if event.is_action_pressed(&"act") and _adding_node:
		var pos := get_local_mouse_position()
		if not is_valid_node_position(pos):
			return
		if pos.x > size.x - 160:
			pos.x = size.x - 160
		if pos.y > size.y - 40:
			pos.y = size.y - 40
		if Project.snap_to_grid:
			pos = snapped(pos - Project.grid_size / 2, Project.grid_size)
		add_node(pos)
		_adding_node = false
		cursor_icon.visible = false


func _notification(what: int) -> void:
	if what != NOTIFICATION_DRAG_END:
		return
	if not _partial_link.source_node.is_drag_successful():
		_cancel_connection()


func _draw() -> void:
	if not Project.visible_grid:
		return
	if not draw_grid:
		return
	var grid_y := Project.grid_size.y
	var grid_x := Project.grid_size.x
	for y in ceili(size.y / grid_y):
		draw_line(Vector2(0, y * grid_y), Vector2(size.x, y * grid_y), Project.grid_colour)
	for x in ceili(size.x / grid_x):
		draw_line(Vector2(x * grid_x, 0), Vector2(x * grid_x, size.x), Project.grid_colour)

