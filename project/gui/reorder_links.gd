class_name LinkOrderEditor
extends PopupPanel

signal link_reordered(old_index: int, new_index: int)

const LIST_ITEM := preload("res://gui/link_reordering_link.tscn")

@export var outgoing_node: FlowsheetNodeGui
@export var incoming_links: Array[FlowsheetLinkGui]
@export var incoming_nodes: Array[FlowsheetNodeGui]

@onready var _link_list := $Contents/ScrollContainer/Links as Control


func _ready() -> void:
	visible = false
	about_to_popup.connect(_setup)


func _setup() -> void:
	for child in _link_list.get_children():
		_link_list.remove_child(child)
	# TODO: Show node info
	for i in incoming_links.size():
		var list_item := LIST_ITEM.instantiate() as LinkReorderingLink
		list_item.incoming_node = incoming_nodes[i]
		list_item.link = incoming_links[i]
		list_item.moved_up.connect(_move_link.bind(list_item, -1))
		list_item.moved_down.connect(_move_link.bind(list_item, 1))
		if i == 0:
			list_item.can_move_up = false
		if i == incoming_links.size() - 1:
			list_item.can_move_down = false
		_link_list.add_child(list_item)


func _move_link(list_item: LinkReorderingLink, offset: int) -> void:
	var old_index := list_item.get_index()
	var new_index := old_index + offset
	_link_list.move_child(list_item, new_index)
	for i in _link_list.get_child_count():
		var child := _link_list.get_child(i) as LinkReorderingLink
		child.can_move_up = (i > 0)
		child.can_move_down = (i < _link_list.get_child_count() - 1)
	link_reordered.emit(old_index, new_index)

