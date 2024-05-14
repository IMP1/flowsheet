class_name FlowsheetCanvas
extends Panel

signal view_changed(view: View)

enum View { EDIT, STYLE, TEST }
enum SheetEdge { TOP, LEFT, RIGHT, BOTTOM }

@export var pan_speed: float = 30
@export var zoom_speed: float = 0.5

var _view: View = View.EDIT
var _resizing: bool = false
var _resize_edge: SheetEdge = SheetEdge.TOP
var _resizing_distance: Vector2 = Vector2.ZERO

@onready var _sheet := $Sheet as FlowsheetGui
@onready var _selection_info_pane := $SelectionInfo as Control
@onready var _selection_info := $SelectionInfo/Info as Control
@onready var _selection_node := $SelectionInfo/Info/Node as Control
@onready var _selection_link := $SelectionInfo/Info/Link as Control
@onready var _selection_node_id := $SelectionInfo/Info/Node/Id as Label
@onready var _selection_node_calculated_value := $SelectionInfo/Info/Node/CalculatedValue as Label
@onready var _selection_node_type := $SelectionInfo/Info/Node/Actions/ChangeType as OptionButton
@onready var _selection_node_initial_value := $SelectionInfo/Info/Node/Actions/InitialValue as NodeInput
@onready var _selection_node_editable := $SelectionInfo/Info/Node/Actions/ToggleEditable as Button
@onready var _selection_link_id := $SelectionInfo/Info/Link/Id as Label
@onready var _selection_link_order := $SelectionInfo/Info/Link/Order as Label
@onready var _selection_link_formula := $SelectionInfo/Info/Link/Formula as Label
@onready var _formula_editor := $EditFormula as LinkFormulaEditor
@onready var _link_order_editor := $ReorderLinks as LinkOrderEditor
@onready var _script_editor := $ScriptEditor as NodeScriptEditor
@onready var _styling_info := $Styling as StylePalette
@onready var _resize_sheet_top := $Sheet/SheetSizeHandles/Top as Button
@onready var _resize_sheet_left := $Sheet/SheetSizeHandles/Left as Button
@onready var _resize_sheet_right := $Sheet/SheetSizeHandles/Right as Button
@onready var _resize_sheet_bottom := $Sheet/SheetSizeHandles/Bottom as Button


func _ready() -> void:
	_sheet.node_changes_made.connect(func(): _refresh_selection_info(_sheet._selected_item))
	_sheet.item_selected.connect(_refresh_style_info)
	_sheet.position.y = 0
	_refresh_selection_info.call_deferred(null)
	_refresh_style_info.call_deferred(null)
	_styling_info.visible = (_view == View.STYLE)
	_link_order_editor.link_reordered.connect(func(old_index: int, new_index: int):
		_sheet.reorder_incoming_link(_link_order_editor.outgoing_node, old_index, new_index))
	_resize_sheet_top.button_down.connect(func():
		_resizing = true
		_resizing_distance = Vector2.ZERO
		_resize_edge = SheetEdge.TOP)
	_resize_sheet_top.button_up.connect(func(): _finish_resizing())
	_resize_sheet_left.button_down.connect(func():
		_resizing = true
		_resizing_distance = Vector2.ZERO
		_resize_edge = SheetEdge.LEFT)
	_resize_sheet_left.button_up.connect(func(): _finish_resizing())
	_resize_sheet_right.button_down.connect(func():
		_resizing = true
		_resizing_distance = Vector2.ZERO
		_resize_edge = SheetEdge.RIGHT)
	_resize_sheet_right.button_up.connect(func(): _finish_resizing())
	_resize_sheet_bottom.button_down.connect(func():
		_resizing = true
		_resizing_distance = Vector2.ZERO
		_resize_edge = SheetEdge.BOTTOM)
	_resize_sheet_bottom.button_up.connect(func(): _finish_resizing())
	Project.view_mode = _view


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed(&"mouse_pan_sheet") and event is InputEventMouseMotion:
		pan_sheet((event as InputEventMouseMotion).relative)
	if event.is_action_pressed(&"zoom_in"):
		zoom_sheet(zoom_speed)
	elif event.is_action_pressed(&"zoom_out"):
		zoom_sheet(-zoom_speed)
	elif event.is_action_pressed(&"zoom_reset"):
		reset_zoom()
	elif event.is_action_pressed(&"pan_left"):
		pan_sheet(Vector2.LEFT * pan_speed)
	elif event.is_action_pressed(&"pan_right"):
		pan_sheet(Vector2.RIGHT * pan_speed)
	elif event.is_action_pressed(&"pan_up"):
		pan_sheet(Vector2.DOWN * pan_speed)
	elif event.is_action_pressed(&"pan_down"):
		pan_sheet(Vector2.UP * pan_speed)
	elif event.is_action_pressed(&"reload_sheet"):
		_sheet.reload_sheet()


func _input(event: InputEvent) -> void:
	if _resizing and event is InputEventMouseMotion:
		var movement := (event as InputEventMouseMotion).relative
		_resizing_distance += movement
		queue_redraw()


func pan_sheet(motion: Vector2) -> void:
	_sheet.position += motion
	var min_pos := -_sheet.size / 2
	var max_pos := size - _sheet.size / 2
	_sheet.position.x = clampf(_sheet.position.x, min_pos.x, max_pos.x)
	_sheet.position.y = clampf(_sheet.position.y, min_pos.y, max_pos.y)


func zoom_sheet(factor: float) -> void:
	var scale_factor := pow(1.1, factor)
	var size_change := (_sheet.size * scale_factor) - _sheet.size
	var mouse_percentage := get_local_mouse_position() / size
	var relative_mouse_pos := mouse_percentage * size_change
	_sheet.scale *= scale_factor
	_sheet.position -= relative_mouse_pos


func reset_zoom() -> void:
	_sheet.scale = Vector2.ONE
	_sheet.position = (size - _sheet.size) / 2


func set_view(new_view: View) -> void:
	_view = new_view
	Project.view_mode = _view
	match _view:
		View.EDIT:
			_styling_info.visible = false
			_selection_info_pane.visible = true
			_sheet.draw_grid = true
		View.STYLE:
			_styling_info.visible = true
			_selection_info_pane.visible = true
			_sheet.draw_grid = false
		View.TEST:
			_styling_info.visible = false
			_selection_info_pane.visible = false
			_sheet.draw_grid = false
	_sheet.queue_redraw()
	view_changed.emit(_view)


func _refresh_selection_info(selected_item) -> void:
	if selected_item == null:
		_selection_info.visible = false
	elif selected_item is FlowsheetNodeGui:
		_selection_info.visible = true
		_selection_link.visible = false
		_selection_node.visible = true
		var node := selected_item as FlowsheetNodeGui
		_selection_node_id.text = "#%d" % node.data.id
		_selection_node_calculated_value.text = str(node.calculated_value)
		_selection_node_type.selected = FlowsheetNode.Type.values()[node.data.type]
		_selection_node_initial_value.type = node.data.type
		_selection_node_initial_value.value = node.data.initial_value
		_selection_node_editable.button_pressed = node.data.accepts_input
	elif selected_item is FlowsheetLinkGui:
		_selection_info.visible = true
		_selection_node.visible = false
		_selection_link.visible = true
		var link := selected_item as FlowsheetLinkGui
		_selection_link_id.text = "%d ⟶ %d" % [link.data.source_id, link.data.target_id]
		_selection_link_order.text = "(%d)" % link.data.target_ordering
		_selection_link_formula.text = link.data.formula


func _refresh_style_info(selected_item) -> void:
	var item_styling = selected_item
	# TODO: Check for sheet styling 
	# TODO: Check for default node styling 
	# TODO: Check for default link styling 
	_styling_info.set_item(item_styling)


func _duplicate() -> void:
	_sheet.duplicate_selected_item()


func _delete() -> void:
	_sheet.delete_selected_item()


func _show_formula_editor() -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetLinkGui:
		return
	var selected_link := selected_item as FlowsheetLinkGui
	var code := selected_link.data.formula
	_formula_editor.code = code
	_formula_editor.popup_centered()


func _hide_formula_editor() -> void:
	_formula_editor.hide()


func _confirm_formula_edit(new_formula: String) -> void:
	_hide_formula_editor()
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetLinkGui:
		return
	var selected_link := selected_item as FlowsheetLinkGui
	_sheet.set_link_formula(selected_link, new_formula)
	_refresh_selection_info(_sheet._selected_item)


func _show_incoming_link_reordering() -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	var incoming_links := _sheet.get_incoming_links(selected_node)
	var incoming_nodes: Array[FlowsheetNodeGui] = []
	incoming_nodes.assign(incoming_links.map(func(link: FlowsheetLinkGui): 
		return _sheet._node_list.get_node(str(link.data.source_id))))
	_link_order_editor.outgoing_node = selected_node
	_link_order_editor.incoming_links = incoming_links
	_link_order_editor.incoming_nodes = incoming_nodes
	_link_order_editor.popup_centered()


func _show_script_editor() -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	if _sheet.sheet.node_scripts.has(selected_node.data):
		var code := _sheet.sheet.node_scripts[selected_node.data] as String
		_script_editor.code = code
	else:
		_script_editor.code = NodeScriptEditor.DEFAULT_CODE
	_script_editor.popup_centered()


func _hide_script_editor() -> void:
	_script_editor.hide()


func _confirm_script_edit(new_code: String) -> void:
	_script_editor.hide()
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	_sheet.set_node_script(selected_node, new_code)
	_refresh_selection_info(_sheet._selected_item)


func _change_selected_node_type(option: int) -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	var new_type := option as FlowsheetNode.Type
	_sheet.set_node_type(selected_node, new_type)
	_refresh_selection_info(_sheet._selected_item)


func _change_selected_node_value(new_value) -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	_sheet.set_node_value(selected_node, new_value)
	# _refresh_selection_info(_sheet._selected_item)


func _change_selected_node_editable(editable: bool) -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	_sheet.set_node_editable(selected_node, editable)
	_refresh_selection_info(_sheet._selected_item)


func _finish_resizing() -> void:
	_resizing = false
	if Project.snap_to_grid:
		_resizing_distance = snapped(_resizing_distance, Project.grid_size)
	_resize_sheet(_resize_edge, _resizing_distance)
	queue_redraw()


func _resize_sheet(edge: SheetEdge, difference: Vector2) -> void:
	match edge:
		SheetEdge.TOP:
			var old_size := _sheet.size.y
			_sheet.size.y -= difference.y
			var actual_change := old_size - _sheet.size.y
			_sheet.position.y += actual_change
			for child in _sheet.get_node("Nodes").get_children(): child.position.y -= actual_change
			for child in _sheet.get_node("Links").get_children(): child.position.y -= actual_change
			# QUESTION: Anything else to move?
		SheetEdge.LEFT:
			var old_size := _sheet.size.x
			_sheet.size.x -= difference.x
			var actual_change := old_size - _sheet.size.x
			_sheet.position.x += actual_change
			for child in _sheet.get_node("Nodes").get_children(): child.position.x -= actual_change
			for child in _sheet.get_node("Links").get_children(): child.position.x -= actual_change
			# QUESTION: Anything else to move?
		SheetEdge.RIGHT:
			_sheet.size.x += difference.x
		SheetEdge.BOTTOM:
			_sheet.size.y += difference.y
	_sheet.sheet.size = _sheet.size


func _draw() -> void:
	if not _resizing:
		return
	var origin := _sheet.position
	var new_size := _sheet.size
	var difference := _resizing_distance
	var change_rect: Rect2
	if Project.snap_to_grid:
		difference = snapped(difference, Project.grid_size)
	match _resize_edge:
		SheetEdge.TOP:
			var old_size := new_size.y
			new_size.y -= difference.y
			var actual_change := old_size - new_size.y
			origin.y += actual_change
			change_rect = Rect2(_sheet.position, Vector2(_sheet.size.x, origin.y - _sheet.position.y))
		SheetEdge.LEFT:
			var old_size := new_size.x
			new_size.x -= difference.x
			var actual_change := old_size - new_size.x
			origin.x += actual_change
			change_rect = Rect2(_sheet.position, Vector2(origin.x - _sheet.position.x, _sheet.size.y))
		SheetEdge.RIGHT:
			new_size.x += difference.x
			change_rect = Rect2(Vector2(_sheet.position.x + new_size.x, _sheet.position.y), Vector2(_sheet.size.x - new_size.x, _sheet.size.y))
		SheetEdge.BOTTOM:
			new_size.y += difference.y
			change_rect = Rect2(Vector2(_sheet.position.x, _sheet.position.y + new_size.y), Vector2(_sheet.size.x, _sheet.size.y - new_size.y))
	draw_rect(Rect2(origin, new_size), Color.BLACK, false, 1)
	if new_size < _sheet.size:
		draw_rect(change_rect, Color(Color.BLACK, 0.5), true, 1)
	else:
		draw_rect(change_rect, Color(Color.WHITE, 0.3), true, 1)
