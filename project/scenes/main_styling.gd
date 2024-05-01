class_name StylePalette
extends Panel

@export var sheet: FlowsheetGui

var _sheet_style: FlowsheetStyle
var _default_node_style: FlowsheetNodeStyle
var _default_link_style: FlowsheetLinkStyle

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
@onready var _node_bg_image_path := $Contents/Styles/NodeStyling/BackgroundImage/Values/Path as FilePickerButton
@onready var _node_bg_image_rect := $Contents/Styles/NodeStyling/BackgroundImage/Values/Rect as TextureRectPickerButton
@onready var _node_bg_image_scale := $Contents/Styles/NodeStyling/BackgroundImage/Values/Scale as OptionButton
@onready var _node_bg_image_overridden := $Contents/Styles/NodeStyling/BackgroundImage/Button as Button

@onready var _link_visible := $Contents/Styles/LinkStyling/Visible/Value as CheckButton
@onready var _link_visible_overridden := $Contents/Styles/LinkStyling/Visible/Button as Button
@onready var _link_width := $Contents/Styles/LinkStyling/LineWidth/Value as SpinBox
@onready var _link_width_overridden := $Contents/Styles/LinkStyling/LineWidth/Button as Button
@onready var _link_colour := $Contents/Styles/LinkStyling/LineColour/Value as ColorPickerButton
@onready var _link_colour_overridden := $Contents/Styles/LinkStyling/LineColour/Button as Button
@onready var _link_icon_path := $Contents/Styles/LinkStyling/IconPath/Value as FilePickerButton
@onready var _link_icon_path_overridden := $Contents/Styles/LinkStyling/IconPath/Button as Button
@onready var _link_icon_offset := $Contents/Styles/LinkStyling/IconOffset/Value as HSlider
@onready var _link_icon_offset_overridden := $Contents/Styles/LinkStyling/IconOffset/Button as Button
@onready var _link_text := $Contents/Styles/LinkStyling/Text/Value as LineEdit
@onready var _link_text_overridden := $Contents/Styles/LinkStyling/Text/Button as Button
@onready var _link_text_offset := $Contents/Styles/LinkStyling/TextOffset/Value as HSlider
@onready var _link_text_offset_overridden := $Contents/Styles/LinkStyling/TextOffset/Button as Button
@onready var _link_text_size := $Contents/Styles/LinkStyling/TextSize/Value as SpinBox
@onready var _link_text_size_overridden := $Contents/Styles/LinkStyling/TextSize/Button as Button
@onready var _link_text_colour := $Contents/Styles/LinkStyling/TextColour/Value as ColorPickerButton
@onready var _link_text_colour_overridden := $Contents/Styles/LinkStyling/TextColour/Button as Button
@onready var _link_text_font := $Contents/Styles/LinkStyling/TextFont/Value as OptionButton
@onready var _link_text_font_overridden := $Contents/Styles/LinkStyling/TextFont/Button as Button
@onready var _link_curve_style := $Contents/Styles/LinkStyling/CurveStyle/Value as OptionButton
@onready var _link_curve_style_overridden := $Contents/Styles/LinkStyling/CurveStyle/Button as Button
@onready var _link_curve_param_1 := $Contents/Styles/LinkStyling/CurveParam1/Value as SpinBox
@onready var _link_curve_param_1_overridden := $Contents/Styles/LinkStyling/CurveParam1/Button as Button
@onready var _link_curve_param_2 := $Contents/Styles/LinkStyling/CurveParam2/Value as SpinBox
@onready var _link_curve_param_2_overridden := $Contents/Styles/LinkStyling/CurveParam2/Button as Button

@onready var _sheet_bg_colour := $Contents/Styles/SheetStyling/BackgroundColour/Value as ColorPickerButton
@onready var _sheet_bg_image_path := $Contents/Styles/SheetStyling/BackgroundImage/Values/Path as FilePickerButton
@onready var _sheet_bg_image_rect := $Contents/Styles/SheetStyling/BackgroundImage/Values/Rect as TextureRectPickerButton
@onready var _sheet_bg_image_scale := $Contents/Styles/SheetStyling/BackgroundImage/Values/Scaling as OptionButton

@onready var _default_node_visible := $Contents/Styles/DefaultNodeStyling/Visible/Value as CheckButton
@onready var _default_node_size_x := $Contents/Styles/DefaultNodeStyling/Size/Values/X as SpinBox
@onready var _default_node_size_y := $Contents/Styles/DefaultNodeStyling/Size/Values/Y as SpinBox
@onready var _default_node_bg_colour := $Contents/Styles/DefaultNodeStyling/BackgroundColour/Value as ColorPickerButton
@onready var _default_node_border_thickness := $Contents/Styles/DefaultNodeStyling/BorderThickness/Value as SpinBox
@onready var _default_node_border_colour := $Contents/Styles/DefaultNodeStyling/BorderColour/Value as ColorPickerButton
@onready var _default_node_corner_radius := $Contents/Styles/DefaultNodeStyling/CornerRadius/Value as SpinBox
@onready var _default_node_text_colour := $Contents/Styles/DefaultNodeStyling/TextColour/Value as ColorPickerButton
@onready var _default_node_text_size := $Contents/Styles/DefaultNodeStyling/TextSize/Value as SpinBox
@onready var _default_node_text_font := $Contents/Styles/DefaultNodeStyling/TextFont/Value as OptionButton
@onready var _default_node_bg_image_path := $Contents/Styles/DefaultNodeStyling/BackgroundImage/Values/Path as FilePickerButton
@onready var _default_node_bg_image_rect := $Contents/Styles/DefaultNodeStyling/BackgroundImage/Values/Rect as TextureRectPickerButton
@onready var _default_node_bg_image_scale := $Contents/Styles/DefaultNodeStyling/BackgroundImage/Values/Scale as OptionButton

@onready var _default_link_visible := $Contents/Styles/DefaultLinkStyling/Visible/Value as CheckButton
@onready var _default_link_width := $Contents/Styles/DefaultLinkStyling/LineWidth/Value as SpinBox
@onready var _default_link_colour := $Contents/Styles/DefaultLinkStyling/LineColour/Value as ColorPickerButton
@onready var _default_link_icon_path := $Contents/Styles/DefaultLinkStyling/IconPath/Value as FilePickerButton
@onready var _default_link_icon_offset := $Contents/Styles/DefaultLinkStyling/IconOffset/Value as HSlider
@onready var _default_link_text := $Contents/Styles/DefaultLinkStyling/Text/Value as LineEdit
@onready var _default_link_text_offset := $Contents/Styles/DefaultLinkStyling/TextOffset/Value as HSlider
@onready var _default_link_text_size := $Contents/Styles/DefaultLinkStyling/TextSize/Value as SpinBox
@onready var _default_link_text_colour := $Contents/Styles/DefaultLinkStyling/TextColour/Value as ColorPickerButton
@onready var _default_link_text_font := $Contents/Styles/DefaultLinkStyling/TextFont/Value as OptionButton
@onready var _default_link_curve_style := $Contents/Styles/DefaultLinkStyling/CurveStyle/Value as OptionButton
@onready var _default_link_curve_param_1 := $Contents/Styles/DefaultLinkStyling/CurveParams/Values/Param1 as SpinBox
@onready var _default_link_curve_param_2 := $Contents/Styles/DefaultLinkStyling/CurveParams/Values/Param2 as SpinBox


func _ready() -> void:
	_sheet_style = sheet.sheet.sheet_style
	_default_node_style = sheet.sheet.default_node_style
	_default_link_style = sheet.sheet.default_link_style
	_setup_node_styling()
	_setup_link_styling()
	_setup_default_node_styling()
	_setup_default_link_styling()
	_setup_sheet_styling()


func _setup_node_styling() -> void:
	_node_visible_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"visible"] = _default_node_style.visible
		else:
			_item.style_overrides.erase(&"visible")
			_node_visible.set_pressed_no_signal(_default_node_style.visible)
		_node_visible.disabled = not on)
	_node_visible.toggled.connect(func(pressed: bool):
		sheet.set_node_style(_item, &"visible", pressed))
	
	_node_size_overridden.toggled.connect(func(on: bool): 
		if on:
			_item.style_overrides[&"size"] = _default_node_style.size
		else:
			_item.style_overrides.erase(&"size")
			_node_size_x.set_value_no_signal(_default_node_style.size.x)
			_node_size_y.set_value_no_signal(_default_node_style.size.y)
		_node_size_x.editable = on
		_node_size_y.editable = on)
	_node_size_x.value_changed.connect(func(x: float):
		var y := _node_size_y.value
		sheet.set_node_style(_item, &"size", Vector2(x, y)))
	_node_size_y.value_changed.connect(func(y: float):
		var x := _node_size_x.value
		sheet.set_node_style(_item, &"size", Vector2(x, y)))
	
	_node_bg_colour_overridden.toggled.connect(func(on: bool): 
		if on:
			_item.style_overrides[&"background_colour"] = _default_node_style.background_colour
		else:
			_item.style_overrides.erase(&"background_colour")
			_node_bg_colour.color = _default_node_style.background_colour
		_node_bg_colour.disabled = not on)
	_node_bg_colour.color_changed.connect(func(colour: Color):
		sheet.set_node_style(_item, &"background_colour", colour))
	
	_node_border_thickness_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"border_thickness"] = _default_node_style.border_thickness
		else:
			_item.style_overrides.erase(&"border_thickness")
			_node_border_thickness.set_value_no_signal(_default_node_style.border_thickness)
		_node_border_thickness.editable = on)
	_node_border_thickness.value_changed.connect(func(val: float) -> void:
		sheet.set_node_style(_item, &"border_thickness", val))
	
	_node_border_colour_overridden.toggled.connect(func(on: bool): 
		if on:
			_item.style_overrides[&"border_colour"] = _default_node_style.border_colour
		else:
			_item.style_overrides.erase(&"border_colour")
			_node_border_colour.color = _default_node_style.border_colour
		_node_border_colour.disabled = not on)
	_node_border_colour.color_changed.connect(func(colour: Color):
		sheet.set_node_style(_item, &"border_colour", colour))
	
	_node_corner_radius_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"corner_radius"] = _default_node_style.corner_radius
		else:
			_item.style_overrides.erase(&"corner_radius")
			_node_corner_radius.set_value_no_signal(_default_node_style.corner_radius)
		_node_corner_radius.editable = on)
	_node_corner_radius.value_changed.connect(func(val: float):
		sheet.set_node_style(_item, &"corner_radius", val))
	
	_node_text_colour_overridden.toggled.connect(func(on: bool): 
		if on:
			_item.style_overrides[&"text_colour"] = _default_node_style.text_colour
		else:
			_item.style_overrides.erase(&"text_colour")
			_node_text_colour.color = _default_node_style.text_colour
		_node_text_colour.disabled = not on)
	_node_text_colour.color_changed.connect(func(colour: Color):
		sheet.set_node_style(_item, &"text_colour", colour))
	
	_node_text_size_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"text_size"] = _default_node_style.text_size
		else:
			_item.style_overrides.erase(&"text_size")
			_node_text_size.set_value_no_signal(_default_node_style.text_size)
		_node_text_size.editable = on)
	_node_text_size.value_changed.connect(func(val: float):
		sheet.set_node_style(_item, &"text_size", val))
	
	_node_text_font_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"text_font_name"] = _default_node_style.text_font_name
		else:
			_item.style_overrides.erase(&"text_font_name")
			_node_text_font.selected = 0
		_node_text_font.disabled = not on)
	_node_text_font.item_selected.connect(func(selection: int):
		var font_name := _node_text_font.get_item_text(selection)
		sheet.set_node_style(_item, &"text_font_name", font_name))
	_node_text_font.clear()
	for font_name in Project.get_font_names():
		_node_text_font.add_item(font_name)
	# TODO: Add more when they're imported
	
	_node_bg_image_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"background_image_path"] = _default_node_style.background_image_path
			_item.style_overrides[&"background_image_rect"] = _default_node_style.background_image_rect
			_item.style_overrides[&"background_image_scaling"] = _default_node_style.background_image_scaling
		else:
			_item.style_overrides.erase(&"background_image_path")
			_item.style_overrides.erase(&"background_image_rect")
			_item.style_overrides.erase(&"background_image_scaling")
			var path := _default_node_style.background_image_path
			_node_bg_image_path.text = path
			var rect := _default_node_style.background_image_rect
			_node_bg_image_rect.text = "(%d, %d, %d, %d)" % [rect.position.x, rect.position.y, rect.size.x, rect.size.y]
			var idx := _default_node_style.background_image_scaling
			_node_bg_image_scale.select(idx)
		_node_bg_image_path.disabled = not on
		_node_bg_image_rect.disabled = not on
		_node_bg_image_scale.disabled = not on)
	_node_bg_image_path.file_selected.connect(func(path: String):
		sheet.set_node_style(_item, &"background_image_path", path))
	_node_bg_image_rect.rect_selected.connect(func(rect: Rect2i):
		sheet.set_node_style(_item, &"background_image_rect", rect))
	_node_bg_image_scale.item_selected.connect(func(idx: int):
		var scaling: FlowsheetNodeStyle.StretchMode = idx as FlowsheetNodeStyle.StretchMode
		sheet.set_node_style(_item, &"background_image_scaling", scaling))


func _setup_link_styling() -> void:
	_link_visible_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"visible"] = _default_link_style.visible
		else:
			_item.style_overrides.erase(&"visible")
			_link_visible.set_pressed_no_signal(_default_link_style.visible)
		_link_visible.disabled = not on)
	_link_visible.toggled.connect(func(on: bool):
		sheet.set_link_style(_item, &"visible", on))
	
	_link_width_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"line_width"] = _default_link_style.line_width
		else:
			_item.style_overrides.erase(&"line_width")
			_link_width.set_value_no_signal(_default_link_style.line_width)
		_link_width.editable = on)
	_link_width.value_changed.connect(func(value: float):
		sheet.set_link_style(_item, &"line_width", value))
	
	_link_colour_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"line_colour"] = _default_link_style.line_colour
		else:
			_item.style_overrides.erase(&"line_colour")
			_link_colour.color = _default_link_style.line_colour
		_link_colour.disabled = not on)
	_link_colour.color_changed.connect(func(colour: Color):
		sheet.set_link_style(_item, &"line_colour", colour))
	
	_link_icon_path_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"icon_path"] = _default_link_style.icon_path
		else:
			_item.style_overrides.erase(&"icon_path")
			_link_icon_path.text = _default_link_style.icon_path
		_link_icon_path.disabled = not on)
	_link_icon_path.file_selected.connect(func(path: String):
		sheet.set_link_style(_item, &"icon_path", path))
	
	_link_icon_offset_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"icon_offset"] = _default_link_style.icon_offset
		else:
			_item.style_overrides.erase(&"icon_offset")
			_link_icon_offset.set_value_no_signal(_default_link_style.icon_offset)
		_link_icon_offset.editable = on)
	_link_icon_offset.value_changed.connect(func(value: float):
		sheet.set_link_style(_item, &"icon_offset", value))
	
	_link_text_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"text"] = _default_link_style.text
		else:
			_item.style_overrides.erase(&"text")
			_link_text.text = _default_link_style.text
		_link_text.editable = on)
	_link_text.text_changed.connect(func(text: String):
		sheet.set_link_style(_item, &"text", text))
	
	_link_text_offset_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"text_offset"] = _default_link_style.text_offset
		else:
			_item.style_overrides.erase(&"text_offset")
			_link_text_offset.set_value_no_signal(_default_link_style.text_offset)
		_link_text_offset.editable = on)
	_link_text_offset.value_changed.connect(func(value: float):
		sheet.set_link_style(_item, &"text_offset", value))
	
	_link_text_size_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"text_size"] = _default_link_style.text_size
		else:
			_item.style_overrides.erase(&"text_size")
			_link_text_size.set_value_no_signal(_default_link_style.text_size)
		_link_text_size.editable = on)
	_link_text_size.value_changed.connect(func(value: float):
		sheet.set_link_style(_item, &"text_size", value))
	
	_link_text_colour_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"text_colour"] = _default_link_style.text_colour
		else:
			_item.style_overrides.erase(&"text_colour")
			_link_text_colour.color = _default_link_style.text_colour
		_link_text_colour.disabled = not on)
	_link_text_colour.color_changed.connect(func(colour: Color):
		sheet.set_link_style(_item, &"text_colour", colour))
	
	_link_text_font_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"text_font_name"] = _default_link_style.text_font_name
		else:
			_item.style_overrides.erase(&"text_font_name")
			var idx := 0 # TODO: Get from _default_link_style.text_font_name
			_link_text_font.selected = idx
		_link_text_font.disabled = not on)
	_link_text_font.clear()
	for font_name in Project.get_font_names():
		_link_text_font.add_item(font_name)
	# TODO: Add/remove if imported ones are added/removed
	_link_text_font.item_selected.connect(func(index: int):
		var font_name := _link_text_font.get_item_text(index)
		sheet.set_link_style(_item, &"text_font_name", font_name))
	
	_link_curve_style_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"curve_style"] = _default_link_style.curve_style
		else:
			_item.style_overrides.erase(&"curve_style")
			_link_curve_style.select(_default_link_style.curve_style)
		_link_curve_style.disabled = not on)
	_link_curve_style.item_selected.connect(func(index: int):
		sheet.set_link_style(_item, &"curve_style", index)
		match index:
			0:
				_link_curve_param_1_overridden.text = "Midpoint offset X"
				_link_curve_param_2_overridden.text = "Midpoint offset Y"
			1:
				_link_curve_param_1_overridden.text = "Midpoint offset"
				_link_curve_param_2_overridden.text = "Curve radius"
			2:
				_link_curve_param_1_overridden.text = "Control point X"
				_link_curve_param_2_overridden.text = "Control point Y"
		)
	
	_link_curve_param_1_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"curve_param_1"] = _default_link_style.curve_param_1
		else:
			_item.style_overrides.erase(&"curve_param_1")
			_link_curve_param_1.set_value_no_signal(_default_link_style.curve_param_1)
		_link_curve_param_1.editable = on)
	_link_curve_param_1.value_changed.connect(func(value: float):
		sheet.set_link_style(_item, &"curve_param_1", value))
	
	_link_curve_param_2_overridden.toggled.connect(func(on: bool):
		if on:
			_item.style_overrides[&"curve_param_2"] = _default_link_style.curve_param_2
		else:
			_item.style_overrides.erase(&"curve_param_2")
			_link_curve_param_2.set_value_no_signal(_default_link_style.curve_param_2)
		_link_curve_param_2.editable = on)
	_link_curve_param_2.value_changed.connect(func(value: float):
		sheet.set_link_style(_item, &"curve_param_2", value))


func _setup_default_node_styling() -> void:
	_default_node_visible.button_pressed = sheet.sheet.default_node_style.visible
	_default_node_visible.toggled.connect(func(on: bool):
		sheet.set_default_node_style(&"visible", on))
	
	_default_node_size_x.set_value_no_signal(sheet.sheet.default_node_style.size.x)
	_default_node_size_x.value_changed.connect(func(x: float):
		var y := _default_node_size_y.value
		sheet.set_default_node_style(&"size", Vector2(x, y)))
	
	_default_node_size_y.set_value_no_signal(sheet.sheet.default_node_style.size.y)
	_default_node_size_y.value_changed.connect(func(y: float):
		var x := _default_node_size_x.value
		sheet.set_default_node_style(&"size", Vector2(x, y)))
	
	_default_node_bg_colour.color = sheet.sheet.default_node_style.background_colour
	_default_node_bg_colour.color_changed.connect(func(colour: Color):
		sheet.set_default_node_style(&"background_colour", colour))
	
	_default_node_border_thickness.set_value_no_signal(sheet.sheet.default_node_style.border_thickness)
	_default_node_border_thickness.value_changed.connect(func(value: float):
		sheet.set_default_node_style(&"border_thickness", value))
	
	_default_node_border_colour.color = sheet.sheet.default_node_style.border_colour
	_default_node_border_colour.color_changed.connect(func(colour: Color):
		sheet.set_default_node_style(&"border_colour", colour))
		
	_default_node_corner_radius.set_value_no_signal(sheet.sheet.default_node_style.corner_radius)
	_default_node_corner_radius.value_changed.connect(func(value: float):
		sheet.set_default_node_style(&"corner_radius", value))
	
	_default_node_text_colour.color = sheet.sheet.default_node_style.text_colour
	_default_node_text_colour.color_changed.connect(func(colour: Color):
		sheet.set_default_node_style(&"text_colour", colour))
	
	_default_node_text_size.set_value_no_signal(sheet.sheet.default_node_style.text_size)
	_default_node_text_size.value_changed.connect(func(value: float):
		sheet.set_default_node_style(&"text_size", value))
	
	_default_node_text_font.clear()
	for font_name in Project.get_font_names():
		_default_node_text_font.add_item(font_name)
	var idx := 0 # TODO: Use sheet.sheet.default_node_style.text_font_name
	_default_node_text_font.select(idx)
	_default_node_text_font.item_selected.connect(func(selection: int):
		var font_name := _default_node_text_font.get_item_text(selection)
		sheet.set_default_node_style(&"text_font_name", font_name))
	
	_default_node_bg_image_path.text = sheet.sheet.default_node_style.background_image_path
	_default_node_bg_image_path.file_selected.connect(func(path: String):
		sheet.set_default_node_style(&"background_image_path", path)
		if not path.is_empty():
			var image := Image.load_from_file(path)
			var texture := ImageTexture.create_from_image(image)
			_default_node_bg_image_rect.texture = texture)
	
	if not sheet.sheet.default_node_style.background_image_path.is_empty():
		var image := Image.load_from_file(sheet.sheet.default_node_style.background_image_path)
		var texture := ImageTexture.create_from_image(image)
		_default_node_bg_image_rect.texture = texture
	_default_node_bg_image_rect.rect = sheet.sheet.default_node_style.background_image_rect
	_default_node_bg_image_rect.rect_selected.connect(func(rect: Rect2i):
		sheet.set_default_node_style(&"background_image_rect", rect))
	
	_default_node_bg_image_scale.select(sheet.sheet.default_node_style.background_image_scaling)
	_default_node_bg_image_scale.item_selected.connect(func(selection: int):
		sheet.set_default_node_style(&"background_image_scaling", selection))


func _setup_default_link_styling() -> void:
	_default_link_visible.button_pressed = sheet.sheet.default_link_style.visible
	_default_link_visible.pressed.connect(func(on: bool):
		sheet.set_default_link_style(&"visible", on))
	
	_default_link_width.set_value_no_signal(sheet.sheet.default_link_style.line_width)
	_default_link_width.value_changed.connect(func(val: float):
		sheet.set_default_link_style(&"line_width", val))
	
	_default_link_colour.color = sheet.sheet.default_link_style.line_colour
	_default_link_colour.color_changed.connect(func(colour: Color):
		sheet.set_default_link_style(&"line_colour", colour))
	
	_default_link_icon_path.text = sheet.sheet.default_link_style.icon_path
	_default_link_icon_path.file_selected.connect(func(path: String):
		sheet.set_default_link_style(&"icon_path", path))
	
	_default_link_icon_offset.set_value_no_signal(sheet.sheet.default_link_style.icon_offset)
	_default_link_icon_offset.value_changed.connect(func(val: float):
		sheet.set_default_link_style(&"icon_offset", val))
	
	_default_link_text.text = sheet.sheet.default_link_style.text
	_default_link_text.text_changed.connect(func(text: String):
		sheet.set_default_link_style(&"text", text))
	
	_default_link_text_offset.set_value_no_signal(sheet.sheet.default_link_style.text_offset)
	_default_link_text_offset.value_changed.connect(func(val: float):
		sheet.set_default_link_style(&"text_offset", val))
	
	_default_link_text_size.set_value_no_signal(sheet.sheet.default_link_style.text_size)
	_default_link_text_size.value_changed.connect(func(val: float):
		sheet.set_default_link_style(&"text_size", val))
	
	_default_link_text_colour.color = sheet.sheet.default_link_style.text_colour
	_default_link_text_colour.color_changed.connect(func(colour: Color):
		sheet.set_default_link_style(&"text_colour", colour))
	
	_default_link_text_font.clear()
	for font_name in Project.get_font_names():
		_default_link_text_font.add_item(font_name)
	var idx := 0 # TODO: Get from sheet.sheet.default_link_style.text_font_name
	_default_link_text_font.select(idx)
	_default_link_text_font.item_selected.connect(func(selection: int):
		var font_name := _default_link_text_font.get_item_text(selection)
		sheet.set_default_link_style(&"text_font_name", font_name))
	
	_default_link_curve_style.select(sheet.sheet.default_link_style.curve_style)
	_default_link_curve_style.item_selected.connect(func(selection: int):
		sheet.set_default_link_style(&"curve_style", selection))
	
	_default_link_curve_param_1.set_value_no_signal(sheet.sheet.default_link_style.curve_param_1)
	_default_link_curve_param_1.value_changed.connect(func(val: float):
		sheet.set_default_link_style(&"curve_param_1", val))
	
	_default_link_curve_param_2.set_value_no_signal(sheet.sheet.default_link_style.curve_param_2)
	_default_link_curve_param_2.value_changed.connect(func(val: float):
		sheet.set_default_link_style(&"curve_param_2", val))


func _setup_sheet_styling() -> void:
	_sheet_bg_colour.color = sheet.sheet.sheet_style.background_colour
	_sheet_bg_colour.color_changed.connect(func(colour: Color):
		sheet.set_sheet_style(&"background_colour", colour))
	
	_sheet_bg_image_path.text = sheet.sheet.sheet_style.background_image_path
	_sheet_bg_image_path.file_selected.connect(func(path: String):
		var image := Image.load_from_file(path)
		var texture := ImageTexture.create_from_image(image)
		sheet.set_sheet_style(&"background_image_path", path)
		_sheet_bg_image_rect.texture = texture
		_sheet_bg_image_rect.rect = Rect2i(Vector2.ZERO, texture.get_size())
		_sheet_bg_image_rect.rect_selected.emit(_sheet_bg_image_rect.rect))
	
	if not sheet.sheet.sheet_style.background_image_path.is_empty():
		var image := Image.load_from_file(sheet.sheet.sheet_style.background_image_path)
		var texture := ImageTexture.create_from_image(image)
		_sheet_bg_image_rect.texture = texture
	_sheet_bg_image_rect.rect = sheet.sheet.sheet_style.background_image_rect
	_sheet_bg_image_rect.rect_selected.connect(func(rect: Rect2i):
		_sheet_bg_image_rect.text = "(%d, %d, %d, %d)" % [rect.position.x, rect.position.y, rect.size.x, rect.size.y]
		sheet.set_sheet_style(&"background_image_rect", rect))
	
	_sheet_bg_image_scale.select(sheet.sheet.sheet_style.background_image_scaling)
	_sheet_bg_image_scale.item_selected.connect(func(selection: int):
		sheet.set_sheet_style(&"background_image_scaling", selection))


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
	elif _item is FlowsheetLinkStyle:
		_title.text = "Default Link Styling"
		_node_styles.visible = false
		_link_styles.visible = false
		_sheet_styles.visible = false
		_default_node_styles.visible = false
		_default_link_styles.visible = true
	elif _item is FlowsheetStyle:
		_title.text = "Sheet Styling"
		_node_styles.visible = false
		_link_styles.visible = false
		_sheet_styles.visible = true
		_default_node_styles.visible = false
		_default_link_styles.visible = false


func _set_node(node: FlowsheetNodeGui) -> void:
	_node_visible_overridden.button_pressed = node.style_overrides.has(&"visible")
	if node.style_overrides.has(&"visible"):
		_node_visible.button_pressed = node.style_overrides[&"visible"]
	else:
		_node_visible_overridden.toggled.emit(_node_visible_overridden.button_pressed)
	
	_node_size_overridden.button_pressed = node.style_overrides.has(&"size")
	if node.style_overrides.has(&"size"):
		_node_size_x.set_value_no_signal(node.style_overrides[&"size"].x)
		_node_size_y.set_value_no_signal(node.style_overrides[&"size"].y)
	else:
		_node_size_overridden.toggled.emit(_node_size_overridden.button_pressed)
	
	_node_bg_colour_overridden.button_pressed = node.style_overrides.has(&"background_colour")
	if node.style_overrides.has(&"background_colour"):
		_node_bg_colour.color = node.style_overrides[&"background_colour"]
	else:
		_node_bg_colour_overridden.toggled.emit(_node_bg_colour_overridden.button_pressed)
	
	_node_border_thickness_overridden.button_pressed = node.style_overrides.has(&"border_thickness")
	if node.style_overrides.has(&"border_thickness"):
		_node_border_thickness.set_value_no_signal(node.style_overrides[&"border_thickness"])
	else:
		_node_border_thickness_overridden.toggled.emit(_node_border_thickness_overridden.button_pressed)
	
	_node_border_colour_overridden.button_pressed = node.style_overrides.has(&"border_colour")
	if node.style_overrides.has(&"border_colour"):
		_node_border_colour.set_value_no_signal(node.style_overrides[&"border_colour"])
	else:
		_node_border_colour_overridden.toggled.emit(_node_border_colour_overridden.button_pressed)
	
	_node_corner_radius_overridden.button_pressed = node.style_overrides.has(&"corner_radius")
	if node.style_overrides.has(&"corner_radius"):
		_node_corner_radius.set_value_no_signal(node.style_overrides[&"corner_radius"])
	else:
		_node_corner_radius_overridden.toggled.emit(_node_corner_radius_overridden.button_pressed)
	
	_node_text_colour_overridden.button_pressed = node.style_overrides.has(&"text_colour")
	if node.style_overrides.has(&"text_colour"):
		_node_text_colour.color = node.style_overrides[&"text_colour"]
	else:
		_node_text_colour_overridden.toggled.emit(_node_text_colour_overridden.button_pressed)
	
	_node_text_size_overridden.button_pressed = node.style_overrides.has(&"text_size")
	if node.style_overrides.has(&"text_size"):
		_node_text_size.set_value_no_signal(node.style_overrides[&"text_size"])
	else:
		_node_text_size_overridden.toggled.emit(_node_text_size_overridden.button_pressed)
	
	_node_text_font_overridden.button_pressed = node.style_overrides.has(&"text_font")
	if node.style_overrides.has(&"text_font"):
		var idx := 0# TODO: Use node.style_overrides[&"text_font"] as int 
		_node_text_font.select(idx)
	else:
		_node_text_font_overridden.toggled.emit(_node_text_font_overridden.button_pressed)
	
	_node_bg_image_overridden.button_pressed = node.style_overrides.has(&"background_image_path")
	if node.style_overrides.has(&"background_image_path"):
		var path := node.style_overrides[&"background_image_path"] as String
		_node_bg_image_path.text = path
		var rect := node.style_overrides[&"background_image_rect"] as Rect2i
		_node_bg_image_rect.text = "(%d, %d, %d, %d)" % [rect.position.x, rect.position.y, rect.size.x, rect.size.y]
		var idx := node.style_overrides[&"background_image_scaling"] as int
		_node_bg_image_scale.select(idx)
	else:
		_node_bg_image_overridden.toggled.emit(_node_bg_image_overridden.button_pressed)


func _set_link(link: FlowsheetLinkGui) -> void:
	_link_visible_overridden.button_pressed = link.style_overrides.has(&"visible")
	if link.style_overrides.has(&"visible"):
		_link_visible.button_pressed = link.style_overrides[&"visible"]
	else:
		_link_visible_overridden.toggled.emit(_link_visible_overridden.button_pressed)
		
	_link_width_overridden.button_pressed = link.style_overrides.has(&"line_width")
	if link.style_overrides.has(&"line_width"):
		_link_width.set_value_no_signal(link.style_overrides[&"line_width"])
	else:
		_link_width_overridden.toggled.emit(_link_width_overridden.button_pressed)
		
	_link_colour_overridden.button_pressed = link.style_overrides.has(&"line_colour")
	if link.style_overrides.has(&"line_colour"):
		_link_colour.color = link.style_overrides[&"line_colour"]
	else:
		_link_colour_overridden.toggled.emit(_link_colour_overridden.button_pressed)
		
	_link_icon_path_overridden.button_pressed = link.style_overrides.has(&"icon_path")
	if link.style_overrides.has(&"icon_path"):
		_link_icon_path.text = link.style_overrides[&"icon_path"]
	else:
		_link_icon_path_overridden.toggled.emit(_link_icon_path_overridden.button_pressed)
		
	_link_icon_offset_overridden.button_pressed = link.style_overrides.has(&"icon_offset")
	if link.style_overrides.has(&"icon_offset"):
		_link_icon_offset.set_value_no_signal(link.style_overrides[&"icon_offset"])
	else:
		_link_icon_offset_overridden.toggled.emit(_link_icon_offset_overridden.button_pressed)
	
	_link_text_overridden.button_pressed = link.style_overrides.has(&"text")
	if link.style_overrides.has(&"text"):
		_link_text.text = link.style_overrides[&"text"]
	else:
		_link_text_overridden.toggled.emit(_link_text_overridden.button_pressed)
		
	_link_text_offset_overridden.button_pressed = link.style_overrides.has(&"text_offset")
	if link.style_overrides.has(&"text_offset"):
		_link_text_offset.set_value_no_signal(link.style_overrides[&"text_offset"])
	else:
		_link_text_offset_overridden.toggled.emit(_link_text_offset_overridden.button_pressed)
		
	_link_text_size_overridden.button_pressed = link.style_overrides.has(&"text_size")
	if link.style_overrides.has(&"text_size"):
		_link_text_size.set_value_no_signal(link.style_overrides[&"text_size"])
	else:
		_link_text_size_overridden.toggled.emit(_link_text_size_overridden.button_pressed)
	
	_link_text_colour_overridden.button_pressed = link.style_overrides.has(&"text_colour")
	if link.style_overrides.has(&"text_colour"):
		_link_text_colour.color = link.style_overrides[&"text_colour"]
	else:
		_link_text_colour_overridden.toggled.emit(_link_text_colour_overridden.button_pressed)
	
	_link_text_font_overridden.button_pressed = link.style_overrides.has(&"text_font")
	if link.style_overrides.has(&"text_font"):
		var idx := 0 # TODO: Get from link.style_overrides[&"text_font"]
		_link_text_font.select(idx)
	else:
		_link_text_font_overridden.toggled.emit(_link_text_font_overridden.button_pressed)
	
	_link_curve_style_overridden.button_pressed = link.style_overrides.has(&"curve_style")
	if link.style_overrides.has(&"curve_style"):
		_link_curve_style.select(link.style_overrides[&"curve_style"])
	else:
		_link_curve_style_overridden.toggled.emit(_link_curve_style_overridden.button_pressed)
	
	_link_curve_param_1_overridden.button_pressed = link.style_overrides.has(&"curve_param_1")
	if link.style_overrides.has(&"curve_param_1"):
		_link_curve_param_1.set_value_no_signal(link.style_overrides[&"curve_param_1"])
	else:
		_link_curve_param_1_overridden.toggled.emit(_link_curve_param_1_overridden.button_pressed)
	_link_curve_param_2_overridden.button_pressed = link.style_overrides.has(&"curve_param_2")
	if link.style_overrides.has(&"curve_param_2"):
		_link_curve_param_2.set_value_no_signal(link.style_overrides[&"curve_param_2"])
	else:
		_link_curve_param_2_overridden.toggled.emit(_link_curve_param_2_overridden.button_pressed)
