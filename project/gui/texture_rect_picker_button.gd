class_name TextureRectPickerButton
extends Button

@export var texture: Texture2D:
	set(value):
		rect.size = texture.get_size()
		rect.position = Vector2.ZERO
		_texture_rect.texture = value
@export var rect: Rect2

@export var popup: PopupPanel
@export var _texture_rect: TextureRect

func _ready() -> void:
	popup.hide()


func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		popup.popup_centered()
	else:
		popup.hide()
