extends Node

# Settings
@export var snap_to_grid: bool = true
@export var visible_grid: bool = true
@export var grid_size: Vector2 = Vector2(32, 32)
@export var grid_colour: Color = Color(0.0, 0.0, 0.0, 0.5)
# Project Info
@export var filepath: String = ""
var unsaved_changes: bool = false


func get_textures_paths() -> Array[String]:
	return []


func get_font_paths() -> Array[String]:
	var list: Array[String] = []
	# Flowsheet Fonts
	list.append("res://assets/fonts/Atkinson_Hyperlegible/AtkinsonHyperlegible-Regular.ttf")
	# TODO: Append system fonts?
	
	# User Global Fonts
	var dir := DirAccess.open("user://")
	if dir.dir_exists("resources".path_join(".globals")):
		pass # TODO: Add global resources to list
	
	# User Project Fonts
	if filepath.is_empty():
		return list
	var project_name := filepath.get_file().get_slice(".", 0)
	if not dir.dir_exists("resources".path_join(project_name).path_join("fonts")):
		return list
	dir.change_dir("resources".path_join(project_name).path_join("fonts"))
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			# TODO: Add a check that the file is a font
			# TODO: Check the path is a full one, not relative to the current dir's directory
			list.append(file_name)
		file_name = dir.get_next()
	return list
