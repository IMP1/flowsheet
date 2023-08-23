class_name NodeInput
extends Control

signal value_changed(new_value)

var type := FlowsheetNode.Type.BOOL:
	set = _set_type
var value:
	set = _set_value,
	get = _get_value

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


func _set_type(new_type: FlowsheetNode.Type) -> void:
	if type == new_type:
		return
	assert(get_child_count() > 0)
	remove_child(_input)
	type = new_type
	match type:
		FlowsheetNode.Type.BOOL:
			_input = CheckButton.new()
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
	_input.name = "Input"
	_input.anchor_bottom = 1.0
	_input.anchor_right = 1.0
	_input.gui_input.connect(func(event): gui_input.emit(event))
	add_child.call_deferred(_input)
