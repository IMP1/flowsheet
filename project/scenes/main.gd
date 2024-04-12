extends Panel

# TODO: Allow for duplication for links and nodes
# TODO: When making a connection, prompt for formula then?
# TODO: Allow for custom 'Common Formulae'
# TODO: Allow for sheet resizing
# TODO: Have an undo/redo history
# TODO: Have (rebindable) hotkeys for all functions

const FLOWSHEET_FILE_EXTENTION := ".flow"
const UNTITLED_TITLE := "Untitled" + FLOWSHEET_FILE_EXTENTION

const FILE_NEW := 0
const FILE_OPEN := 1
const FILE_SAVE := 3
const FILE_SAVE_AS := 4
const FILE_EXIT := 6
const VIEW_GRID_SNAP := 4
const VIEW_GRID_VISIBLE := 5
const VIEW_GRID_CONFIG := 6
const HELP_ONLINE_DOCS := 0
const HELP_SOURCE_CODE := 2
const HELP_ABOUT := 3

var _current_project_filepath: String

@onready var _menu_file := ($MenuBar/File as MenuButton).get_popup()
@onready var _menu_edit := ($MenuBar/Edit as MenuButton).get_popup()
@onready var _menu_view := ($MenuBar/View as MenuButton).get_popup()
@onready var _menu_help := ($MenuBar/Help as MenuButton).get_popup()
@onready var _sheet := $HSplitContainer/Canvas/Sheet as FlowsheetGui
@onready var _menu_edit_grid := $EditGrid as PopupPanel
@onready var _menu_edit_grid_x := $EditGrid/Options/Size/GridX as SpinBox
@onready var _menu_edit_grid_y := $EditGrid/Options/Size/GridY as SpinBox
@onready var _menu_edit_opacity := $EditGrid/Options/Colour/Opacity as Slider
@onready var _open_dialog := $OpenFile as FileDialog
@onready var _save_dialog := $SaveFile as FileDialog
@onready var _about_dialog := $About as PopupPanel
@onready var _console := $Console/HBoxContainer/Input as LineEdit


func _ready() -> void:
	_menu_file.index_pressed.connect(_file_pressed)
	_menu_edit.index_pressed.connect(_edit_pressed)
	_menu_view.index_pressed.connect(_view_pressed)
	_menu_help.index_pressed.connect(_help_pressed)
	_menu_view.set_item_checked(VIEW_GRID_SNAP, Project.snap_to_grid)
	_menu_view.set_item_checked(VIEW_GRID_VISIBLE, Project.visible_grid)
	_menu_edit_grid_x.value_changed.connect(func(x: float): _update_grid_size(x, Project.grid_size.y))
	_menu_edit_grid_y.value_changed.connect(func(y: float): _update_grid_size(Project.grid_size.x, y))
	_menu_edit_opacity.value_changed.connect(_update_grid_opacity)
	DisplayServer.window_set_title("%s - %s" % [UNTITLED_TITLE, "Flowsheet"])


func _update_grid_size(x: float, y: float) -> void:
	Project.grid_size = Vector2(x, y)
	_sheet.queue_redraw()


func _update_grid_opacity(opacity: float) -> void:
	Project.grid_colour.a = opacity
	_sheet.queue_redraw()


func _file_pressed(index: int) -> void:
	match index:
		FILE_NEW:
			_new()
		FILE_OPEN:
			_open()
		FILE_SAVE:
			_save()
		FILE_SAVE_AS:
			_save_as()
		FILE_EXIT:
			_exit()


func _edit_pressed(index: int) -> void:
	pass # TODO


func _view_pressed(index: int) -> void:
	match index:
		VIEW_GRID_SNAP:
			var checked := not _menu_view.is_item_checked(VIEW_GRID_SNAP)
			_menu_view.set_item_checked(VIEW_GRID_SNAP, checked)
			Project.snap_to_grid = checked
		VIEW_GRID_VISIBLE:
			var checked := not _menu_view.is_item_checked(VIEW_GRID_VISIBLE)
			_menu_view.set_item_checked(VIEW_GRID_VISIBLE, checked)
			Project.visible_grid = checked
			_sheet.queue_redraw()
		VIEW_GRID_CONFIG:
			_menu_edit_grid_x.value = Project.grid_size.x
			_menu_edit_grid_y.value = Project.grid_size.y
			_menu_edit_opacity.value = Project.grid_colour.a
			_menu_edit_grid.popup_centered()


func _help_pressed(index: int) -> void:
	match index: # TODO
		HELP_ONLINE_DOCS:
			OS.shell_open("https://github.com/IMP1/flowsheet/wiki")
		HELP_SOURCE_CODE:
			OS.shell_open("https://github.com/IMP1/flowsheet")
		HELP_ABOUT:
			_about_dialog.popup_centered()


func _new() -> void:
	# TODO: Prompt for save if file has changes
	_sheet.clear_sheet()


func _open() -> void:
	# TODO: Prompt for save if file has changes
	_open_dialog.popup_centered()
	var result := await _open_dialog.about_to_close as bool
	if not result:
		return
	var path := _open_dialog.current_path
	var sheet := FlowsheetFile.load_binary(path)
	_sheet.open_sheet(sheet)
	_current_project_filepath = path
	get_window().title = path + " - Flowsheet"


func _save_as() -> void:
	_save_dialog.popup_centered()
	var result := await _save_dialog.about_to_close as bool
	if not result:
		return
	var path := _save_dialog.current_path
	if not path.ends_with(FLOWSHEET_FILE_EXTENTION):
		path += FLOWSHEET_FILE_EXTENTION
	_current_project_filepath = path
	_save()


func _save() -> void:
	if _current_project_filepath.is_empty():
		_save_as() # Get filepath for project
		return
	var sheet := _sheet.sheet
	FlowsheetFile.save_binary(sheet, _current_project_filepath)


func _exit() -> void:
	# TODO: Prompt for save if file has changes
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit.call_deferred(0)



func _run_command(command: String) -> void:
	_console.text = ""
	var words := command.strip_edges().split(" ")
	# TODO: Have a console and a language for manipulating the flowsheet itself
	#       Think about the API. Stuff like add_node, duplicate_node
	#       Anything that can be done graphically should be able to be automated
	print(words)

