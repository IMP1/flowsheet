class_name FilePickerButton
extends Button

@export var dialog: FileDialog


func _ready() -> void:
	dialog.hide()
	dialog.close_requested.connect(func(): button_pressed = false)


func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		dialog.popup_centered()
	else:
		dialog.hide()
