class_name NodeInput
extends Control

signal value_changed(new_value)

var type := FlowsheetNode.Type.BOOL:
	set = _set_type
var value:
	set = _set_value,
	get = _get_value
var _text_size: int
var _text_colour: Color
var _text_font: Font

@onready var _input := $Input as Control


func _ready() -> void:
	_input.gui_input.connect(func(event): gui_input.emit(event))
	_set_type(FlowsheetNode.Type.INT)


func _get_value():
	match type:
		FlowsheetNode.Type.BOOL:
			return (_input as CheckButton).button_pressed as bool
		FlowsheetNode.Type.INT:
			return (_input as SpinBox).value as int
		FlowsheetNode.Type.DECIMAL:
			return (_input as SpinBox).value as float
		FlowsheetNode.Type.PERCENTAGE:
			return (_input as HSlider).value as float
		FlowsheetNode.Type.TEXT:
			return (_input as LineEdit).text as String
		FlowsheetNode.Type.DATETIME:
			return null # TODO: Make a datepicker control
		FlowsheetNode.Type.BUTTON:
			return (_input as Button).button_pressed as bool


func _set_value(new_value) -> void:
	match type:
		FlowsheetNode.Type.BOOL:
			(_input as CheckButton).button_pressed = (new_value as bool)
		FlowsheetNode.Type.INT:
			(_input as SpinBox).value = (new_value as int)
		FlowsheetNode.Type.DECIMAL:
			(_input as SpinBox).value = (new_value as float)
		FlowsheetNode.Type.PERCENTAGE:
			(_input as HSlider).value = (new_value as float)
		FlowsheetNode.Type.TEXT:
			(_input as LineEdit).text = (new_value as String)
		FlowsheetNode.Type.DATETIME:
			pass # TODO: Make a datepicker control
		FlowsheetNode.Type.BUTTON:
			(_input as Button).button_pressed = (new_value as bool)


func _set_type(new_type: FlowsheetNode.Type) -> void:
	if type == new_type:
		return
	assert(get_child_count() > 0)
	remove_child(_input)
	type = new_type
	match type:
		FlowsheetNode.Type.BOOL:
			_input = CheckButton.new()
			_input.flat = true
			_input.alignment = HORIZONTAL_ALIGNMENT_CENTER
			_input.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			_input.toggled.connect(func(val): value_changed.emit(val))
		FlowsheetNode.Type.INT:
			_input = SpinBox.new()
			_input.allow_greater = true
			_input.allow_lesser = true
			_input.rounded = true
			_input.step = 1
			_input.value_changed.connect(func(val): value_changed.emit(val))
		FlowsheetNode.Type.DECIMAL:
			_input = SpinBox.new()
			_input.allow_greater = true
			_input.allow_lesser = true
			_input.rounded = false
			_input.step = 0.01
			_input.value_changed.connect(func(val): value_changed.emit(val))
		FlowsheetNode.Type.PERCENTAGE:
			_input = HSlider.new()
			_input.max_value = 1.0
			_input.min_value = 0.0
			_input.step = 0.01
			_input.value_changed.connect(func(val): value_changed.emit(val))
		FlowsheetNode.Type.TEXT:
			_input = LineEdit.new()
			_input.text_changed.connect(func(val): value_changed.emit(val))
		FlowsheetNode.Type.DATETIME:
			_input = Button.new()
			_input.disabled = true # TODO: Make a datepicker control
		FlowsheetNode.Type.BUTTON:
			_input = Button.new()
			_input.button_down.connect(func(): value_changed.emit(true))
			_input.button_up.connect(func(): value_changed.emit(false))
			_input.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_input.name = "Input"
	_input.anchor_left = 0.0
	_input.anchor_top = 0.0
	_input.anchor_bottom = 1.0
	_input.anchor_right = 1.0
	_input.gui_input.connect(func(event): gui_input.emit(event))
	_input.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child.call_deferred(_input)


func set_text_colour(colour: Color) -> void:
	_text_colour = colour
	refresh_style()


func set_text_size(text_size: int) -> void:
	_text_size = text_size
	refresh_style()
	

func set_text_font(font: Font) -> void:
	_text_font = font
	refresh_style()


func refresh_style() -> void:
	if Project.view_mode == FlowsheetCanvas.View.EDIT:
		clear_styles()
		return
	
	match type:
		FlowsheetNode.Type.BOOL:
			pass
		FlowsheetNode.Type.INT:
			_input.get_line_edit().add_theme_color_override(&"font_color", _text_colour)
			_input.get_line_edit().add_theme_font_size_override(&"font_size", _text_size)
			if _text_font:
				_input.get_line_edit().add_theme_font_override(&"font", _text_font)
		FlowsheetNode.Type.DECIMAL:
			_input.get_line_edit().add_theme_color_override(&"font_color", _text_colour)
			_input.get_line_edit().add_theme_font_size_override(&"font_size", _text_size)
			if _text_font:
				_input.get_line_edit().add_theme_font_override(&"font", _text_font)
		FlowsheetNode.Type.PERCENTAGE:
			pass
		FlowsheetNode.Type.TEXT:
			_input.get_line_edit().add_theme_color_override(&"font_color", _text_colour)
			_input.get_line_edit().add_theme_font_size_override(&"font_size", _text_size)
			if _text_font:
				_input.get_line_edit().add_theme_font_override(&"font", _text_font)
		FlowsheetNode.Type.DATETIME:
			pass
		FlowsheetNode.Type.BUTTON:
			pass


func clear_styles() -> void:
	match type:
		FlowsheetNode.Type.BOOL:
			pass
		FlowsheetNode.Type.INT:
			_input.get_line_edit().remove_theme_color_override(&"font_color")
			_input.get_line_edit().remove_theme_font_size_override(&"font_size")
			_input.get_line_edit().remove_theme_font_override(&"font")
		FlowsheetNode.Type.DECIMAL:
			_input.get_line_edit().remove_theme_color_override(&"font_color")
			_input.get_line_edit().remove_theme_font_size_override(&"font_size")
			_input.get_line_edit().remove_theme_font_override(&"font")
		FlowsheetNode.Type.PERCENTAGE:
			pass
		FlowsheetNode.Type.TEXT:
			_input.get_line_edit().remove_theme_color_override(&"font_color")
			_input.get_line_edit().remove_theme_font_size_override(&"font_size")
			_input.get_line_edit().remove_theme_font_override(&"font")
		FlowsheetNode.Type.DATETIME:
			pass
		FlowsheetNode.Type.BUTTON:
			pass

