extends PopupPanel

@export var image_filters: PackedStringArray = ["*.png", "*.jpg, *.jpeg"]
@export var font_filters: PackedStringArray = ["*.ttf"]

# TODO: Handle populating list
# TODO: Handle showing information on selected item when it's selected
# TODO: Only allow for importing on SAVED projects (maybe just prompt to save?)

@onready var _file_dialog := $ImportFiles as FileDialog


func _ready() -> void:
	about_to_popup.connect(_opening)


func _opening() -> void:
	pass


func _open_folder(resource_type: String) -> void:
	var project_name := Project.filepath.get_file().get_slice(".", 0)
	var path := "resources".path_join(project_name).path_join(resource_type)
	Logger.log_message(path)
	OS.shell_show_in_file_manager(path)


func _import_font() -> void:
	_file_dialog.clear_filters()
	for font_type in font_filters:
		_file_dialog.add_filter(font_type, "Font")
	if _file_dialog.files_selected.is_connected(_import_images):
		_file_dialog.files_selected.disconnect(_import_images)
	if _file_dialog.files_selected.is_connected(_import_fonts):
		_file_dialog.files_selected.disconnect(_import_fonts)
	_file_dialog.files_selected.connect(_import_fonts)
	_file_dialog.popup_centered()


func _import_fonts(font_paths: PackedStringArray) -> void:
	Logger.log_message(str(font_paths))


func _import_image() -> void:
	_file_dialog.clear_filters()
	for image_type in image_filters:
		_file_dialog.add_filter(image_type, "Image")
	if _file_dialog.files_selected.is_connected(_import_images):
		_file_dialog.files_selected.disconnect(_import_images)
	if _file_dialog.files_selected.is_connected(_import_fonts):
		_file_dialog.files_selected.disconnect(_import_fonts)
	_file_dialog.files_selected.connect(_import_images)
	_file_dialog.popup_centered()


func _import_images(image_paths: PackedStringArray) -> void:
	Logger.log_message(str(image_paths))
