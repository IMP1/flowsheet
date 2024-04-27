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
const EDIT_IMPORT := 0
const EDIT_UNDO := 2
const EDIT_REDO := 3
const VIEW_EDIT := 0
const VIEW_STYLE := 1
const VIEW_TEST := 2
const VIEW_GRID_SNAP := 4
const VIEW_GRID_VISIBLE := 5
const VIEW_GRID_CONFIG := 6
const VIEW_RESET_ZOOM := 8
const PREF_SETTINGS_SHORTCUTS := 0
const HELP_ONLINE_DOCS := 0
const HELP_SOURCE_CODE := 2
const HELP_ABOUT := 3
const SETTINGS_SHORTCUTS_TAB := 0
const IMPORT_IMAGE_TAB := 0
const IMPORT_FONT_TAB := 1
const PALETTE_ADD_NODE := 0
const PALETTE_STYLE_SHEET := 1
const PALETTE_STYLE_DEFAULT_NODE := 2
const PALETTE_STYLE_DEFAULT_LINK := 3
const PALETTE_IMPORT_FONT := 4
const PALETTE_IMPORT_IMAGE := 5

var _is_update_available: bool = false

@onready var _menu_file := ($Sections/MenuBar/Items/File as MenuButton).get_popup()
@onready var _menu_edit := ($Sections/MenuBar/Items/Edit as MenuButton).get_popup()
@onready var _menu_view := ($Sections/MenuBar/Items/View as MenuButton).get_popup()
@onready var _menu_preferences := ($Sections/MenuBar/Items/Preferences as MenuButton).get_popup()
@onready var _menu_help := ($Sections/MenuBar/Items/Help as MenuButton).get_popup()
@onready var _sheet := $Sections/VSplitContainer/Main/Canvas/Sheet as FlowsheetGui
@onready var _canvas := $Sections/VSplitContainer/Main/Canvas as FlowsheetCanvas
@onready var _menu_edit_grid := $EditGrid as PopupPanel
@onready var _menu_edit_grid_x := $EditGrid/Options/Size/GridX as SpinBox
@onready var _menu_edit_grid_y := $EditGrid/Options/Size/GridY as SpinBox
@onready var _menu_edit_opacity := $EditGrid/Options/Colour/Opacity as Slider
@onready var _open_dialog := $OpenFile as FileDialog
@onready var _save_dialog := $SaveFile as FileDialog
@onready var _about_dialog := $About as PopupPanel
@onready var _settings_dialog := $Settings as PopupPanel
@onready var _settings_tabs := $Settings/TabContainer as TabContainer
@onready var _import_dialog := $ImportWindow as PopupPanel
@onready var _import_tabs := $ImportWindow/TabContainer as TabContainer
@onready var _info_bar_view := $Sections/InfoBar/ViewMode as Label
@onready var _info_bar_version := $Sections/InfoBar/Version as Button
@onready var _update_checker := $UpdateChecker as HTTPRequest
@onready var _update_prompt := $UpdatePrompt as PopupPanel
@onready var _palette := $Sections/VSplitContainer/Main/Palette as Control
@onready var _palette_edit := $Sections/VSplitContainer/Main/Palette/Margin/Views/Edit as Control
@onready var _palette_style := $Sections/VSplitContainer/Main/Palette/Margin/Views/Style as Control
@onready var _console := $Sections/VSplitContainer/Console as Console


func _ready() -> void:
	_update_checker.request_completed.connect(_update_check_response)
	_update_checker.request("https://api.github.com/repos/IMP1/flowsheet/releases")
	_update_prompt.visible = false
	_about_dialog.visible = false
	_open_dialog.visible = false
	_save_dialog.visible = false
	_menu_edit_grid.visible = false
	_settings_dialog.visible = false
	_import_dialog.visible = false
	_console.visible = false
	Logger.console = _console
	_info_bar_version.text = "Flowsheet v" + str(ProjectSettings.get_setting("application/config/version", "0.0.0"))
	_info_bar_version.disabled = true
	_info_bar_version.mouse_default_cursor_shape = Control.CURSOR_ARROW
	_menu_file.index_pressed.connect(_file_pressed)
	_menu_edit.index_pressed.connect(_edit_pressed)
	_menu_view.index_pressed.connect(_view_pressed)
	_menu_preferences.index_pressed.connect(_preferences_pressed)
	_menu_help.index_pressed.connect(_help_pressed)
	_menu_view.set_item_checked(VIEW_EDIT, _canvas._view == FlowsheetCanvas.View.EDIT)
	_menu_view.set_item_checked(VIEW_STYLE, _canvas._view == FlowsheetCanvas.View.STYLE)
	_menu_view.set_item_checked(VIEW_TEST, _canvas._view == FlowsheetCanvas.View.TEST)
	_menu_view.set_item_checked(VIEW_GRID_SNAP, Project.snap_to_grid)
	_menu_view.set_item_checked(VIEW_GRID_VISIBLE, Project.visible_grid)
	_menu_edit_grid_x.value_changed.connect(func(x: float): 
		_update_grid_size(x, Project.grid_size.y))
	_menu_edit_grid_y.value_changed.connect(func(y: float): 
		_update_grid_size(Project.grid_size.x, y))
	_menu_edit_opacity.value_changed.connect(_update_grid_opacity)
	_sheet.sheet_changes_made.connect(func(): 
		Project.unsaved_changes = true
		if Project.filepath.is_empty():
			DisplayServer.window_set_title("(*) %s - %s" % [UNTITLED_TITLE, "Flowsheet"])
		else:
			DisplayServer.window_set_title("(*) %s - %s" % [Project.filepath, "Flowsheet"]))
	Project.unsaved_changes = false
	DisplayServer.window_set_title("%s - %s" % [UNTITLED_TITLE, "Flowsheet"])
	_view_pressed(VIEW_EDIT)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"view_edit"):
		_view_pressed(VIEW_EDIT)
	if event.is_action_pressed(&"view_style"):
		_view_pressed(VIEW_STYLE)
	if event.is_action_pressed(&"view_test"):
		_view_pressed(VIEW_TEST)


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
	match index:
		EDIT_IMPORT:
			_import()
		EDIT_UNDO:
			undo()
		EDIT_REDO:
			redo()


func _view_pressed(index: int) -> void:
	match index:
		VIEW_EDIT:
			_canvas.set_view(FlowsheetCanvas.View.EDIT)
			_menu_view.set_item_checked(VIEW_EDIT, true)
			_menu_view.set_item_checked(VIEW_STYLE, false)
			_menu_view.set_item_checked(VIEW_TEST, false)
			_palette_edit.visible = true
			_palette_style.visible = false
			_palette.visible = true
			_info_bar_view.text = "Edit"
		VIEW_STYLE:
			_canvas.set_view(FlowsheetCanvas.View.STYLE)
			_menu_view.set_item_checked(VIEW_EDIT, false)
			_menu_view.set_item_checked(VIEW_STYLE, true)
			_menu_view.set_item_checked(VIEW_TEST, false)
			_palette_edit.visible = false
			_palette_style.visible = true
			_palette.visible = true
			_info_bar_view.text = "Style"
		VIEW_TEST:
			_canvas.set_view(FlowsheetCanvas.View.TEST)
			_menu_view.set_item_checked(VIEW_EDIT, false)
			_menu_view.set_item_checked(VIEW_STYLE, false)
			_menu_view.set_item_checked(VIEW_TEST, true)
			_palette_edit.visible = false
			_palette_style.visible = false
			_palette.visible = false
			_info_bar_view.text = "Test"
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
		VIEW_RESET_ZOOM:
			_canvas.reset_zoom()


func _preferences_pressed(index: int) -> void:
	match index:
		PREF_SETTINGS_SHORTCUTS:
			_settings_tabs.current_tab = SETTINGS_SHORTCUTS_TAB
			_settings_dialog.popup_centered()


func _help_pressed(index: int) -> void:
	match index:
		HELP_ONLINE_DOCS:
			OS.shell_open("https://github.com/IMP1/flowsheet/wiki")
		HELP_SOURCE_CODE:
			OS.shell_open("https://github.com/IMP1/flowsheet")
		HELP_ABOUT:
			_about_dialog.popup_centered()


func _palette_option_selected(index: int) -> void:
	match index:
		PALETTE_ADD_NODE:
			_sheet.prepare_adding_node()
		PALETTE_STYLE_SHEET:
			_sheet.select_item(null)
			_canvas._refresh_style_info(_sheet.sheet.sheet_style)
		PALETTE_STYLE_DEFAULT_NODE:
			_sheet.select_item(null)
			_canvas._refresh_style_info(_sheet.sheet.default_node_style)
		PALETTE_STYLE_DEFAULT_LINK:
			_sheet.select_item(null)
			_canvas._refresh_style_info(_sheet.sheet.default_link_style)
		PALETTE_IMPORT_FONT:
			_import_dialog.popup_centered()
			_import_tabs.current_tab = IMPORT_FONT_TAB
		PALETTE_IMPORT_IMAGE:
			_import_dialog.popup_centered()
			_import_tabs.current_tab = IMPORT_IMAGE_TAB


func _new() -> void:
	if Project.unsaved_changes:
		pass # TODO: Prompt for save if file has changes
	_sheet.clear_sheet()
	Project.unsaved_changes = false
	DisplayServer.window_set_title("%s - %s" % [UNTITLED_TITLE, "Flowsheet"])


func _open() -> void:
	if Project.unsaved_changes:
		pass # TODO: Prompt for save if file has changes
	_open_dialog.popup_centered()
	var result := await _open_dialog.about_to_close as bool # TODO: Test this works; Seems like a hack of await usage
	if not result:
		return
	var path := _open_dialog.current_path
	var sheet := FlowsheetFile.load_binary(path)
	await _sheet.open_sheet(sheet)
	Project.filepath = path
	print("No unsaved changes")
	Project.unsaved_changes = false
	DisplayServer.window_set_title("%s - %s" % [path, "Flowsheet"])


func _import() -> void:
	_open_dialog.popup_centered()
	var result := await _open_dialog.about_to_close as bool # TODO: Test this works; Seems like a hack of await usage
	if not result:
		return
	var path := _open_dialog.current_path
	var sheet := FlowsheetFile.load_binary(path)
	await _sheet.import_sheet(sheet)
	Project.unsaved_changes = true


func _save_as() -> void:
	_save_dialog.popup_centered()
	var result := await _save_dialog.about_to_close as bool # TODO: Test this works; Seems like a hack of await usage
	if not result:
		return
	var path := _save_dialog.current_path
	if not path.ends_with(FLOWSHEET_FILE_EXTENTION):
		path += FLOWSHEET_FILE_EXTENTION
	Project.filepath = path
	_save()


func _save() -> void:
	if Project.filepath.is_empty():
		_save_as() # Get filepath for project
		return
	var sheet := _sheet.sheet
	FlowsheetFile.save_binary(sheet, Project.filepath)
	Project.unsaved_changes = false
	DisplayServer.window_set_title("%s - %s" % [Project.filepath, "Flowsheet"])


func _exit() -> void:
	if Project.unsaved_changes:
		pass # TODO: Prompt for save if file has changes
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit.call_deferred(0)


func _about_link_clicked(url: String) -> void:
	OS.shell_open(url)


func _update_check_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		return
	Logger.log_message("HTTP Response:") # TODO: Remove
	Logger.log_message(body.get_string_from_utf8()) # TODO: Remove
	_is_update_available = false
	if _is_update_available:
		_info_bar_version.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		_info_bar_version.text += " (Update Available)"
		_update_version()


func _update_version() -> void:
	_update_prompt.popup_centered()


func undo() -> void:
	Logger.log_warning("UNDO not yet implemented")


func redo() -> void:
	Logger.log_warning("REDO not yet implemented")


func _toggle_console() -> void:
	_console.visible = not _console.visible
