class_name FilePickerButton
extends Button

signal file_selected(path: String)

@export var dialog: FileDialog
@export var root: String:
	set(value):
		root = value
		if dialog:
			dialog.root_subfolder = root
@export var filters: PackedStringArray:
	set(value):
		filters = value
		if dialog:
			dialog.filters = filters


func _ready() -> void:
	dialog.hide()
	dialog.close_requested.connect(func(): button_pressed = false)
	dialog.file_selected.connect(func(path: String):
		text = path.get_file()
		file_selected.emit(path)
		button_pressed = false)
	dialog.root_subfolder = root


func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		dialog.popup_centered()
	else:
		dialog.hide()
