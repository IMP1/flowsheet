extends Node

const IMAGE_FILETYPES: PackedStringArray = ["*.png", "*.jpg, *.jpeg"]
const FONT_FILETYPES: PackedStringArray = ["*.ttf"]
const RESOURCE_DIR := "resources"
const RESOURCE_DIR_ABSOLUTE := "user://" + RESOURCE_DIR
const GLOBAL_DIR := ".global"
const FONT_DIR := "fonts"
const IMAGE_DIR := "images"

# Settings
@export var snap_to_grid: bool = true
@export var visible_grid: bool = true
@export var grid_size: Vector2 = Vector2(32, 32)
@export var grid_colour: Color = Color(0.0, 0.0, 0.0, 0.5)
# Project Info
@export var filepath: String = ""
var view_mode: FlowsheetCanvas.View
var sheet: Flowsheet
var unsaved_changes: bool = false


func _ready() -> void:
	_initial_setup()


func _initial_setup() -> void:
	if DirAccess.dir_exists_absolute(RESOURCE_DIR_ABSOLUTE):
		return
	Logger.log_message("Initial Flowsheet setup...")
	DirAccess.make_dir_recursive_absolute(RESOURCE_DIR_ABSOLUTE)
	Logger.log_message("Setup complete")


func get_font_names() -> Array[String]:
	var list: Array[String] = []
	var _global_font_paths := RESOURCE_DIR_ABSOLUTE.path_join(GLOBAL_DIR).path_join(FONT_DIR)
	var _project_font_paths := RESOURCE_DIR_ABSOLUTE.path_join(GLOBAL_DIR).path_join(FONT_DIR)
	# Flowsheet Fonts
	list.append("AtkinsonHyperlegible-Regular.ttf")
	# TODO: Search through resources for fonts? Just search them all
	return list


func _get_paths(path: String, file_types: PackedStringArray) -> Array[String]:
	if filepath.is_empty():
		return []
	if not DirAccess.dir_exists_absolute(path):
		Logger.log_warning("There is no project resource folder as the project has not been saved yet.")
		return []

	var list: Array[String] = []
	var dir := DirAccess.open(path)
	
	if not dir:
		Logger.log_error(error_string(DirAccess.get_open_error()))
		return list
	
	var file_iterator := FileIterator.new(dir, FileIterator.ContentType.FILES)
	for file_name in file_iterator:
		var extenstion := file_name.get_extension()
		if file_types.has(extenstion):
			list.append(file_name)
	return list
