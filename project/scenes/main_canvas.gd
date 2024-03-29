extends Panel

@export var pan_speed: float = 30
@export var zoom_speed: float = 0.5

@onready var _sheet := $Sheet as FlowsheetGui
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
@onready var _formula_editor := $EditFormula as Popup


func _ready() -> void:
	_refresh_selection_info.call_deferred(null)
	_sheet.changes_made.connect(func(): _refresh_selection_info(_sheet._selected_item))


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("mouse_pan_sheet") and event is InputEventMouseMotion:
		pan_sheet((event as InputEventMouseMotion).relative)
	if event.is_action_pressed("zoom_in"):
		zoom_sheet(zoom_speed)
	elif event.is_action_pressed("zoom_out"):
		zoom_sheet(-zoom_speed)
	elif event.is_action_pressed("pan_left"):
		pan_sheet(Vector2.LEFT * pan_speed)
	elif event.is_action_pressed("pan_right"):
		pan_sheet(Vector2.RIGHT * pan_speed)
	elif event.is_action_pressed("pan_up"):
		pan_sheet(Vector2.DOWN * pan_speed)
	elif event.is_action_pressed("pan_down"):
		pan_sheet(Vector2.UP * pan_speed)


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
		_selection_link_id.text = "%d -> %d" % [link.data.source_id, link.data.target_id]
		_selection_link_order.text = "(%d)" % link.data.target_ordering
		_selection_link_formula.text = link.data.formula


func _duplicate() -> void:
	_sheet.duplicate_selected_item()
	# TODO: _refresh_selection_info ?


func _delete() -> void:
	_sheet.delete_selected_item()


func _show_formula_editor() -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetLinkGui:
		return
	var selected_link := selected_item as FlowsheetLinkGui
	print("[Canvas] Showing Formula Editor")
	var code := selected_link.data.formula
	print("[Canvas] Code = '%s'" % code)
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
	_sheet.change_link_formula(selected_link, new_formula)
	_refresh_selection_info(_sheet._selected_item)


func _change_selected_node_type(option: int) -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	var new_type := option as FlowsheetNode.Type
	_sheet.change_node_type(selected_node, new_type)
	_refresh_selection_info(_sheet._selected_item)


func _change_selected_node_value(new_value) -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	_sheet.change_node_value(selected_node, new_value)
	# _refresh_selection_info(_sheet._selected_item)


func _change_selected_node_editable(editable: bool) -> void:
	var selected_item = _sheet._selected_item
	if not selected_item is FlowsheetNodeGui:
		return
	var selected_node := selected_item as FlowsheetNodeGui
	_sheet.change_node_editable(selected_node, editable)
	_refresh_selection_info(_sheet._selected_item)

