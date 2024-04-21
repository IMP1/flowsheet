class_name StylePalette
extends Panel

@export var sheet_style: FlowsheetStyle
@export var default_node_style: FlowsheetNodeStyle
@export var default_link_style: FlowsheetLinkStyle

var _item # Either a FlowsheetNodeGui, a FlowsheetLinkGui, a FlowsheetStyle,
		  # or 'default' Node/Link (FlowsheetNodeStyle/FlowsheetLinkStyle)

@onready var _title := $Title as Label
@onready var _node_styles := $Contents/Styles/NodeStyling as Control
@onready var _link_styles := $Contents/Styles/LinkStyling as Control
@onready var _sheet_styles := $Contents/Styles/SheetStyling as Control
#@onready var _default_node_styles := $Contents/Styles/?? as Control
#@onready var _default_link_styles := $Contents/Styles/?? as Control

@onready var _node_visible := $Contents/Styles/NodeStyling/Visible/Value as CheckBox
@onready var _node_visible_overridden := $Contents/Styles/NodeStyling/Visible/Button as Button
@onready var _node_size_x := $Contents/Styles/NodeStyling/Size/Values/X as SpinBox
@onready var _node_size_y := $Contents/Styles/NodeStyling/Size/Values/Y as SpinBox
@onready var _node_size_overridden := $Contents/Styles/NodeStyling/Size/Button as Button
@onready var _node_bg_colour := $Contents/Styles/NodeStyling/BackgroundColour/Value as ColorPickerButton
@onready var _node_bg_colour_overridden := $Contents/Styles/NodeStyling/BackgroundColour/Button as Button
@onready var _node_border_thickness := $Contents/Styles/NodeStyling/BorderThickness/Value as SpinBox
@onready var _node_border_thickness_overridden := $Contents/Styles/NodeStyling/BorderThickness/Button as Button
@onready var _node_border_colour := $Contents/Styles/NodeStyling/BorderColour/Value as ColorPickerButton
@onready var _node_border_colour_overridden := $Contents/Styles/NodeStyling/BorderColour/Button as Button
@onready var _node_corner_radius := $Contents/Styles/NodeStyling/CornerRadius/Value as SpinBox
@onready var _node_corner_radius_overridden := $Contents/Styles/NodeStyling/CornerRadius/Button as Button
@onready var _node_text_colour := $Contents/Styles/NodeStyling/TextColour/Value as ColorPickerButton
@onready var _node_text_colour_overridden := $Contents/Styles/NodeStyling/TextColour/Button as Button
@onready var _node_text_size := $Contents/Styles/NodeStyling/TextSize/Value as SpinBox
@onready var _node_text_size_overridden := $Contents/Styles/NodeStyling/TextSize/Button as Button
@onready var _node_text_font := $Contents/Styles/NodeStyling/TextFont/Value as OptionButton
@onready var _node_text_font_overridden := $Contents/Styles/NodeStyling/TextFont/Button as Button
@onready var _node_bg_image_texture := $Contents/Styles/NodeStyling/BackgroundImage/Values/Texture as Button
@onready var _node_bg_image_rect := $Contents/Styles/NodeStyling/BackgroundImage/Values/Rect as Button
@onready var _node_bg_image_scale := $Contents/Styles/NodeStyling/BackgroundImage/Values/Scale as OptionButton
@onready var _node_bg_image_overridden := $Contents/Styles/NodeStyling/BackgroundImage/Button as Button

# TODO: Hook up changes to inputs to change the styles
# TODO: Have 'reset' buttons to ignore/inherit values for those properties
# TODO: Add option buttons for background images for scale vs tile vs keep centred


func _ready() -> void:
	_node_visible_overridden.toggled.connect(func(on: bool): _node_visible.disabled = not on)


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
	if node.style_overrides.has(&"visible"):
		_node_visible_overridden.button_pressed = true
		_node_visible.disabled = false
		_node_visible.button_pressed = node.style_overrides[&"visible"]
	else:
		_node_visible_overridden.button_pressed = false
		_node_visible.disabled = true
		_node_visible.button_pressed = default_node_style.visible
	if node.style_overrides.has(&"size"):
		_node_size_overridden.button_pressed = true
		_node_size_x.editable = true
		_node_size_y.editable = true
		_node_size_x.value = node.style_overrides[&"size"].x
		_node_size_y.value = node.style_overrides[&"size"].y
	else:
		_node_size_overridden.button_pressed = false
		_node_size_x.editable = false
		_node_size_y.editable = false
		_node_size_x.value = default_node_style.size.x
		_node_size_y.value = default_node_style.size.y


func _set_link(link: FlowsheetLinkGui) -> void:
	pass
