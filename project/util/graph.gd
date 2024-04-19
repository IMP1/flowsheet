class_name Graph # Technically a DAG
extends RefCounted

var _root_nodes: Array[int] = []
var _all_nodes: Array[int] = []
var _parents: Dictionary = {}
var _children: Dictionary = {}


func add_node(id: int) -> void:
	_root_nodes.append(id)
	_all_nodes.append(id)
	_parents[id] = []
	_children[id] = []


func connect_nodes(parent_id: int, child_id: int) -> void:
	assert(child_id != parent_id)
	assert(parent_id in _all_nodes)
	assert(child_id in _all_nodes)
	if child_id in _root_nodes:
		var index := _root_nodes.find(child_id)
		_root_nodes.remove_at(index)
	_parents[child_id].append(parent_id)
	_children[parent_id].append(child_id)


func disconnect_nodes(parent_id: int, child_id: int) -> void:
	assert(child_id != parent_id)
	assert(parent_id in _all_nodes)
	assert(child_id in _all_nodes)
	var parent_index := _parents[child_id].find(parent_id) as int
	_parents[child_id].remove_at(parent_index)
	var child_index := _children[parent_id].find(child_id) as int
	_children[parent_id].remove_at(child_index)
	if _parents[child_id].is_empty():
		_root_nodes.append(child_id)


func is_descendent_of(child_id: int, parent_id: int) -> bool:
	assert(child_id != parent_id)
	assert(parent_id in _all_nodes)
	assert(child_id in _all_nodes)
	if child_id in _root_nodes:
		return false
	var current_node: int = child_id
	for parent in _parents[current_node]:
		if parent == parent_id:
			return true
		if is_descendent_of(parent, parent_id):
			return true
	return false


func remove_node(id: int) -> void:
	assert(id in _all_nodes)
	var index = _all_nodes.find(id)
	_all_nodes.remove_at(index)
	if id in _root_nodes:
		var i = _root_nodes.find(id)
		_root_nodes.remove_at(i)
	
	for node in _all_nodes:
		if id in _parents[node]:
			var i = _parents[node].find(id)
			_parents[node].remove_at(i)
			if (_parents[node] as Array).is_empty():
				_root_nodes.append(node)


func children(node: int) -> Array:
	assert(node in _all_nodes)
	return _children[node]


func dump() -> void:
	print("digraph FS {")
	for node in _all_nodes:
		print("\t%d" % node)
	print("")
	for node in _parents:
		for parent in _parents[node]:
			print("\t%d -> %d" % [parent, node])
	print("}")
