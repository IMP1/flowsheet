extends Control

signal deleted()
signal formula_changed()

export(Resource) var link

const SOURCE_NODE_LINE_INDEX = 0
const TARGET_NODE_LINE_INDEX = 1

var source_node: Control
var target_node: Control

onready var line := $Edit/LineContainer/Line2D as Line2D
onready var border_line := $Edit/LineContainer/Border as Line2D
onready var path := $Edit/LineContainer/Path2D as Path2D
onready var edit_button := $Edit/Edit as Button
onready var edit_menu := $Edit/EditMenu as Control

# TODO: Draw a different colour line if there is no formula (or if an invalid formula)

func _ready() -> void:
	edit_menu.visible = false

func _set_menu_visible(val: bool) -> void:
	edit_menu.visible = val

func set_connection(source: Control, target: Control) -> void:
	source_node = source
	target_node = target
	source_node.connect("deleted", self, "_node_deleted")
	target_node.connect("deleted", self, "_node_deleted")
	source_node.connect("moved", self, "_source_node_moved")
	target_node.connect("moved", self, "_target_node_moved")
	_refresh()

func _refresh() -> void:
#	var middle_point: Vector2 = source_node.connection_point_out()
#	middle_point += target_node.connection_point_in()
#	middle_point /= 2
#	rect_position = middle_point
#	$Edit/LineContainer.rect_position = -middle_point
	line.clear_points()
	border_line.clear_points()
	path.curve.clear_points()
	line.add_point(source_node.connection_point_out())
	border_line.add_point(source_node.connection_point_out())
	path.curve.add_point(source_node.connection_point_out())
	# TODO: Add elbow bends to make it look nicer
	#       Change TARGET_NODE_LINE_INDEX when this happens
	line.add_point(target_node.connection_point_in())
	border_line.add_point(target_node.connection_point_in())
	path.curve.add_point(target_node.connection_point_in())

func _source_node_moved(position: Vector2) -> void:
	_refresh()

func _target_node_moved(position: Vector2) -> void:
	_refresh()

func _formula_changed(new_formula: String) -> void:
	link.formula = new_formula
	emit_signal("formula_changed")

func _node_deleted() -> void:
	emit_signal("deleted")

func _delete() -> void:
	emit_signal("deleted")

func _process(_delta: float) -> void:
	# TODO: Get rid of this, and check for mouse clicks on the line
	#       https://godotengine.org/qa/80550/signal-for-onmouseenter-for-line2d
	var mouse_pos := path.get_local_mouse_position()
	var line_pos := path.curve.get_closest_point(mouse_pos)
	var distance = (line_pos - mouse_pos).length()
	if distance < 64 and distance > 24: 
		edit_button.rect_position = line_pos
