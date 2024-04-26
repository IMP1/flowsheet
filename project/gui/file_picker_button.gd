class_name FilePickerButton
extends Button

signal file_selected(path: String)

@export var dialog: FileDialog


func _ready() -> void:
	dialog.hide()
	dialog.close_requested.connect(func(): button_pressed = false)
	dialog.file_selected.connect(func(path: String): file_selected.emit(path))


func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		dialog.popup_centered()
	else:
		dialog.hide()
