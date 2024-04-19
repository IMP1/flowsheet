class_name Flowsheet
extends Resource

@export var nodes: Array[FlowsheetNode]
@export var links: Array[FlowsheetLink]
# TODO: User styling



var _current_id: int = 0


func _init() -> void:
	_current_id = 0
	nodes = []
	links = []


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
	_current_id += 1


func remove_node(node: FlowsheetNode) -> void:
	var index := nodes.find(node)
	nodes.remove_at(index)


func add_link(link: FlowsheetLink) -> void:
	links.append(link)


func remove_link(link: FlowsheetLink) -> void:
	var index := links.find(link)
	assert(index >= 0, "Could not find link to remove")
	links.remove_at(index)
