class_name CurvedLine2D
extends Line2D

@export var path: Path2D


func _ready() -> void:
	calculate_line()


func calculate_line() -> void:
	points = path.curve.get_baked_points()
