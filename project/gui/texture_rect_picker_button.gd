class_name TextureRectPickerButton
extends Button

signal rect_selected(rect: Rect2i)

@export var texture: Texture2D:
	set = _set_texture
@export var rect: Rect2i = Rect2i(0, 0, 0, 0):
	set = _set_rect
@export var popup: PopupPanel

@onready var _texture_rect := $PopupPanel/VBoxContainer/Control/Panel/TextureRect as TextureFrame
@onready var _x_input := $PopupPanel/VBoxContainer/Control/VBoxContainer/X as SpinBox
@onready var _y_input := $PopupPanel/VBoxContainer/Control/VBoxContainer/Y as SpinBox
@onready var _w_input := $PopupPanel/VBoxContainer/Control/VBoxContainer/Width as SpinBox
@onready var _h_input := $PopupPanel/VBoxContainer/Control/VBoxContainer/Height as SpinBox
@onready var _confirm_button := $PopupPanel/VBoxContainer/Actions/Confirm as Button
@onready var _cancel_button := $PopupPanel/VBoxContainer/Actions/Cancel as Button


func _ready() -> void:
	popup.hide()
	popup.popup_hide.connect(func(): button_pressed = false)
	_set_texture(texture)
	_set_rect(rect)
	_x_input.value_changed.connect(func(val: float): 
		rect.position.x = val
		_texture_rect.rect = rect)
	_y_input.value_changed.connect(func(val: float): 
		rect.position.y = val
		_texture_rect.rect = rect)
	_w_input.value_changed.connect(func(val: float): 
		rect.size.x = val
		_texture_rect.rect = rect)
	_h_input.value_changed.connect(func(val: float): 
		rect.size.y = val
		_texture_rect.rect = rect)
	_confirm_button.pressed.connect(func():
		popup.hide()
		rect_selected.emit(rect))
	_cancel_button.pressed.connect(popup.hide)


func _set_texture(value: Texture2D) -> void:
	texture = value
	if _texture_rect:
		_texture_rect.texture = texture
		_x_input.max_value = texture.get_width()
		_y_input.max_value = texture.get_height()


func _set_rect(value: Rect2i) -> void:
	rect = value
	if _texture_rect:
		_texture_rect.rect = rect
		_x_input.value = rect.position.x
		_y_input.value = rect.position.y
		_w_input.value = rect.size.x
		_h_input.value = rect.size.y


func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		popup.popup_centered()
	else:
		popup.hide()

