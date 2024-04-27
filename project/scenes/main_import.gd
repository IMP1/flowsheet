extends PopupPanel

@export var image_filters: PackedStringArray = ["*.png", "*.jpg, *.jpeg"]
@export var font_filters: PackedStringArray = ["*.ttf"]

# TODO: Handle populating list
# TODO: Handle showing information on selected item when it's selected

@onready var _file_dialog := $ImportFiles as FileDialog


func _ready() -> void:
	pass


func _import_font() -> void:
	_file_dialog.clear_filters()
	for font_type in font_filters:
		_file_dialog.add_filter(font_type, "Font")
	_file_dialog.files_selected.disconnect(_import_images)
	_file_dialog.files_selected.disconnect(_import_fonts)
	_file_dialog.files_selected.connect(_import_fonts)
	_file_dialog.popup_centered()


func _import_fonts(font_paths: PackedStringArray) -> void:
	_file_dialog.files_selected.disconnect(_import_fonts)
	Logger.log_message(str(font_paths))


func _import_image() -> void:
	_file_dialog.clear_filters()
	for image_type in image_filters:
		_file_dialog.add_filter(image_type, "Image")
	_file_dialog.files_selected.disconnect(_import_images)
	_file_dialog.files_selected.disconnect(_import_fonts)
	_file_dialog.files_selected.connect(_import_images)
	_file_dialog.popup_centered()


func _import_images(image_paths: PackedStringArray) -> void:
	_file_dialog.files_selected.disconnect(_import_fonts)
	Logger.log_message(str(image_paths))
