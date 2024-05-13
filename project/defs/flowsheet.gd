class_name Flowsheet
extends Resource

@export var nodes: Array[FlowsheetNode]
@export var links: Array[FlowsheetLink]
@export var sheet_style: FlowsheetStyle
@export var default_node_style: FlowsheetNodeStyle
@export var default_link_style: FlowsheetLinkStyle
@export var node_styles: Dictionary # Dictionary[FlowsheetNode, Dictionary[StringName, Any]]
@export var link_styles: Dictionary # Dictionary[FlowsheetLink, Dictionary[StringName, Any]]
@export var sheet_script: String
@export var node_scripts: Dictionary # Dictionary[FlowsheetNode, String]


var _current_id: int = 0


func _init() -> void:
	_current_id = 0
	nodes = []
	links = []
	sheet_style = FlowsheetStyle.new()
	default_node_style = FlowsheetNodeStyle.new()
	default_link_style = FlowsheetLinkStyle.new()
	node_styles = {}
	link_styles = {}


func get_next_id() -> int:
	return _current_id


func get_incoming_links(node: FlowsheetNode) -> Array[FlowsheetLink]:
	var filter := func(link: FlowsheetLink): 
		return link.target_id == node.id
	return links.filter(filter)


func get_links_between(source: FlowsheetNode, target: FlowsheetNode) -> Array[FlowsheetLink]:
	var filter := func(link: FlowsheetLink):
		return link.target_id == target.id and link.source_id == source.id
	return links.filter(filter)


func add_node(node: FlowsheetNode) -> void:
	nodes.append(node)
	node_styles[node] = {}
	_current_id += 1


func remove_node(node: FlowsheetNode) -> void:
	if node_styles.has(node):
		node_styles.erase(node)
	var index := nodes.find(node)
	nodes.remove_at(index)


func get_node(id: int) -> FlowsheetNode:
	var nodes_with_id := nodes.filter(func(n: FlowsheetNode): return n.id == id)
	if nodes_with_id.size() > 1:
		push_error("Multiple nodes with id %d" % id)
		return nodes_with_id[0]
	elif nodes_with_id.size() == 0:
		return null
	else:
		return nodes_with_id[0]


func add_link(link: FlowsheetLink) -> void:
	links.append(link)
	link_styles[link] = {}


func remove_link(link: FlowsheetLink) -> void:
	if link_styles.has(link):
		link_styles.erase(link)
	var index := links.find(link)
	assert(index >= 0, "Could not find link to remove")
	links.remove_at(index)
