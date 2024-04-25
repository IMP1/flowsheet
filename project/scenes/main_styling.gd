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
@onready var _default_node_styles := $Contents/Styles/DefaultNodeStyling as Control
@onready var _default_link_styles := $Contents/Styles/DefaultLinkStyling as Control

@onready var _node_visible := $Contents/Styles/NodeStyling/Visible/Value as CheckButton
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
	_node_visible_overridden.toggled.connect(func(on: bool):
		if on:
			(_item as FlowsheetNodeGui).style_overrides[&"visible"] = default_node_style.visible
		else:
			(_item as FlowsheetNodeGui).style_overrides.erase(&"visible")
			_node_visible.disabled = true
			_node_visible.button_pressed = default_node_style.visible
		_node_visible.disabled = not on)
	_node_size_overridden.toggled.connect(func(on: bool): 
		if on:
			pass # TODO: Add override
		else:
			# TODO: Remove override
			_node_size_x.editable = false
			_node_size_y.editable = false
			_node_size_x.value = default_node_style.size.x
			_node_size_y.value = default_node_style.size.y
		_node_size_x.editable = on
		_node_size_y.editable = on)
	_node_bg_colour_overridden.toggled.connect(func(on: bool): 
		if on:
			pass # TODO: Add override
		else:
			_node_bg_colour.disabled = true
			_node_bg_colour.color = default_node_style.background_colour
		_node_bg_colour.disabled = not on)
	_node_border_thickness_overridden.toggled.connect(func(on: bool):
		if on:
			pass # TODO: Add override
		else:
			# TODO: Remove override
			_node_border_thickness.editable = false
			_node_border_thickness.value = default_node_style.border_thickness
		_node_border_thickness.editable = on)
	_node_border_colour_overridden.toggled.connect(func(on: bool): 
		if on:
			pass # TODO: Add override
		else:
			# TODO: Remove override
			_node_border_colour.disabled = true
			_node_border_colour.color = default_node_style.border_colour
		_node_border_colour.disabled = not on)
	_node_corner_radius_overridden.toggled.connect(func(on: bool):
		if on:
			pass # TODO: Add override
		else:
			# TODO: Remove override
			_node_corner_radius.editable = false
			_node_corner_radius.value = default_node_style.corner_radius
		_node_corner_radius.editable = on)
	_node_text_colour_overridden.toggled.connect(func(on: bool): 
		if on:
			pass # TODO: Add override
		else:
			# TODO: Remove override
			_node_text_colour.disabled = true
			_node_text_colour.color = default_node_style.text_colour
		_node_text_colour.disabled = not on)
	_node_text_size_overridden.toggled.connect(func(on: bool):
		if on:
			pass # TODO: Add override
		else:
			# TODO: Remove override
			_node_text_size.editable = false
			_node_text_size.value = default_node_style.text_size
		_node_text_size.editable = on)
	_node_text_font_overridden.toggled.connect(func(on: bool):
		if on:
			pass # TODO: Add override
		else:
			# TODO: Remove override
			_node_text_font.disabled = true
			_node_text_font.selected = 0
		_node_text_font.disabled = not on)
	_node_bg_image_overridden.toggled.connect(func(on: bool):
		if on:
			pass # TODO: Add override
		else:
			# TODO: Remove override
			_node_bg_image_texture.disabled = true
			_node_bg_image_rect.disabled = true
			_node_bg_image_scale.disabled = true
			_node_bg_image_texture.icon = default_node_style.background_image_texture
			var rect := default_node_style.background_image_rect
			_node_bg_image_rect.text = "(%d, %d, %d, %d)" % [rect.position.x, rect.position.y, rect.size.x, rect.size.y]
			var idx := default_node_style.background_image_scaling
			_node_bg_image_scale.select(idx)
		_node_bg_image_texture.disabled = not on
		_node_bg_image_rect.disabled = not on
		_node_bg_image_scale.disabled = not on)


func set_item(item) -> void:
	_item = item
	if _item == null:
		_title.text = "Nothing Selected"
		_node_styles.visible = false
		_link_styles.visible = false
		_sheet_styles.visible = false
		_default_node_styles.visible = false
		_default_link_styles.visible = false
	elif _item is FlowsheetNodeGui:
		_title.text = "Node Styling"
		_node_styles.visible = true
		_link_styles.visible = false
		_sheet_styles.visible = false
		_default_node_styles.visible = false
		_default_link_styles.visible = false
		_set_node(_item as FlowsheetNodeGui)
	elif _item is FlowsheetLinkGui:
		_title.text = "Link Styling"
		_node_styles.visible = false
		_link_styles.visible = true
		_sheet_styles.visible = false
		_default_node_styles.visible = false
		_default_link_styles.visible = false
		_set_link(_item as FlowsheetLinkGui)
	elif _item is FlowsheetNodeStyle:
		_title.text = "Default Node Styling"
		_node_styles.visible = false
		_link_styles.visible = false
		_sheet_styles.visible = false
		_default_node_styles.visible = true
		_default_link_styles.visible = false
		#_set_default_node(_item as FlowsheetNodeStyle)
	elif _item is FlowsheetLinkStyle:
		_title.text = "Default Link Styling"
		_node_styles.visible = false
		_link_styles.visible = false
		_sheet_styles.visible = false
		_default_node_styles.visible = false
		_default_link_styles.visible = true
		#_set_default_link(_item as FlowsheetLinkStyle)
	elif _item is FlowsheetStyle:
		_title.text = "Sheet Styling"
		_node_styles.visible = false
		_link_styles.visible = false
		_sheet_styles.visible = true
		_default_node_styles.visible = false
		_default_link_styles.visible = false
		#_set_sheet(_item as FlowsheetStyle)


func _set_node(node: FlowsheetNodeGui) -> void:
	_node_visible_overridden.button_pressed = node.style_overrides.has(&"visible")
	if node.style_overrides.has(&"visible"):
		_node_visible.button_pressed = node.style_overrides[&"visible"]
	else:
		_node_visible_overridden.toggled.emit(_node_visible_overridden.button_pressed)
	
	_node_size_overridden.button_pressed = node.style_overrides.has(&"size")
	if node.style_overrides.has(&"size"):
		_node_size_x.value = node.style_overrides[&"size"].x
		_node_size_y.value = node.style_overrides[&"size"].y
	else:
		_node_size_overridden.toggled.emit(_node_size_overridden.button_pressed)
	
	_node_bg_colour_overridden.button_pressed = node.style_overrides.has(&"background_colour")
	if node.style_overrides.has(&"background_colour"):
		_node_bg_colour.color = node.style_overrides[&"background_colour"]
	else:
		_node_bg_colour_overridden.toggled.emit(_node_bg_colour_overridden.button_pressed)
	
	_node_border_thickness_overridden.button_pressed = node.style_overrides.has(&"border_thickness")
	if node.style_overrides.has(&"border_thickness"):
		_node_border_thickness.value = node.style_overrides[&"border_thickness"]
	else:
		_node_border_thickness_overridden.toggled.emit(_node_border_thickness_overridden.button_pressed)
	
	_node_border_colour_overridden.button_pressed = node.style_overrides.has(&"border_colour")
	if node.style_overrides.has(&"border_colour"):
		_node_border_colour.value = node.style_overrides[&"border_colour"]
	else:
		_node_border_colour_overridden.toggled.emit(_node_border_colour_overridden.button_pressed)
	
	_node_corner_radius_overridden.button_pressed = node.style_overrides.has(&"corner_radius")
	if node.style_overrides.has(&"corner_radius"):
		_node_corner_radius.value = node.style_overrides[&"corner_radius"]
	else:
		_node_corner_radius_overridden.toggled.emit(_node_corner_radius_overridden.button_pressed)
	
	_node_text_colour_overridden.button_pressed = node.style_overrides.has(&"text_colour")
	if node.style_overrides.has(&"text_colour"):
		_node_text_colour.color = node.style_overrides[&"text_colour"]
	else:
		_node_text_colour_overridden.toggled.emit(_node_text_colour_overridden.button_pressed)
	
	_node_text_size_overridden.button_pressed = node.style_overrides.has(&"text_size")
	if node.style_overrides.has(&"text_size"):
		_node_text_size.value = node.style_overrides[&"text_size"]
	else:
		_node_text_size_overridden.toggled.emit(_node_text_size_overridden.button_pressed)
	
	_node_text_font_overridden.button_pressed = node.style_overrides.has(&"text_font")
	if node.style_overrides.has(&"text_font"):
		var idx := 0# TODO: Use node.style_overrides[&"text_font"] as int 
		_node_text_font.select(idx)
	else:
		_node_text_font_overridden.toggled.emit(_node_text_font_overridden.button_pressed)
	
	_node_bg_image_overridden.button_pressed = node.style_overrides.has(&"background_image")
	if node.style_overrides.has(&"background_image"):
		_node_bg_image_texture.icon = node.style_overrides[&"background_image_texture"]
		var rect := node.style_overrides[&"background_image_rect"] as Rect2
		_node_bg_image_rect.text = "(%d, %d, %d, %d)" % [rect.position.x, rect.position.y, rect.size.x, rect.size.y]
		var idx := node.style_overrides[&"background_image_scaling"] as int
		_node_bg_image_scale.select(idx)
	else:
		_node_bg_image_overridden.toggled.emit(_node_bg_image_overridden.button_pressed)


func _set_link(link: FlowsheetLinkGui) -> void:
	pass
