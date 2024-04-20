class_name StylePalette
extends Panel

var _item # Either a FlowsheetNode, a FlowsheetLink, a 'default' Node, or the sheet itself

@onready var _title := $Title as Label
@onready var _node_styles := $Contents/Styles/NodeStyling as Control
@onready var _link_styles := $Contents/Styles/LinkStyling as Control
@onready var _sheet_styles := $Contents/Styles/SheetStyling as Control
#@onready var _default_node_styles := $Contents/Styles/NodeStyling as Control

@onready var _node_visible := $Contents/Styles/NodeStyling/Visible/Value as CheckBox
@onready var _node_size_x := $Contents/Styles/NodeStyling/Size/VBoxContainer/X as CheckBox
@onready var _node_size_y := $Contents/Styles/NodeStyling/Size/VBoxContainer/Y as CheckBox

# TODO: Hook up changes to inputs to change the styles
# TODO: Have 'reset' buttons to ignore/inherit values for those properties
# TODO: Add option buttons for background images and background frames for scale vs tile vs keep centred

func set_item(item) -> void:
	_item = item
	if _item == null:
		_title.text = "Nothing Selected"
		_node_styles.visible = false
		_link_styles.visible = false
		_sheet_styles.visible = false
	elif _item is FlowsheetNodeGui:
		_title.text = "Node Styling"
		_node_styles.visible = true
		_link_styles.visible = false
		_sheet_styles.visible = false
		_set_node(_item as FlowsheetNodeGui)
	elif _item is FlowsheetLinkGui:
		_title.text = "Link Styling"
		_node_styles.visible = false
		_link_styles.visible = true
		_sheet_styles.visible = false
		_set_link(_item as FlowsheetLinkGui)


func _set_node(node: FlowsheetNodeGui) -> void:
	pass


func _set_link(link: FlowsheetLinkGui) -> void:
	pass
