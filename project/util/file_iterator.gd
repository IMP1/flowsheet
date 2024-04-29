class_name FileIterator
extends RefCounted

enum ContentType { DIRECTORIES = 1, FILES = 2 }

var _current: String
var _dir_access: DirAccess
var _include_directories: bool
var _include_files: bool


func _init(dir: DirAccess, content: ContentType) -> void:
	_dir_access = dir
	_include_directories = content & ContentType.DIRECTORIES
	_include_files = content & ContentType.FILES


func _iter_init(_arg) -> bool:
	print("Calling `list_dir_begin()` and opening the stream!")
	_dir_access.list_dir_begin()
	_current = _dir_access.get_next()
	return _current != ""


func _is_current_dir() -> bool:
	return _dir_access.current_is_dir()


func _is_current_file() -> bool:
	return _current != "" and not _dir_access.current_is_dir()


func _iter_next(_arg) -> bool:
	_current = _dir_access.get_next()
	while (_is_current_dir() and not _include_directories) or (_is_current_file() and not _include_files):
		_current = _dir_access.get_next()
	if _current != "":
		_dir_access.list_dir_end()
		print("Calling `list_dir_end()` and closing the stream!")
		return false
	return true


func _iter_get(_arg) -> String:
	return _current
