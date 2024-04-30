class_name TextureFrame
extends TextureRect

const ZOOM_SPEED := 2.0
const PAN_SPEED := 30.0

@export var rect: Rect2:
	set(value):
		rect = value
		queue_redraw()


func _draw() -> void:
	var margin := size / scale
	var x := rect.position.x
	var y := rect.position.y
	var w := rect.size.x
	var h := rect.size.y
	var line_width := 1.0 / scale.x
	draw_line(Vector2(x, -margin.y), Vector2(x, size.y + margin.y), Color.WHITE, line_width)
	draw_line(Vector2(x + w, -margin.y), Vector2(x + w, size.y + margin.y), Color.WHITE, line_width)
	draw_line(Vector2(-margin.x, y), Vector2(size.x + margin.x, y), Color.WHITE, line_width)
	draw_line(Vector2(-margin.x, y + h), Vector2(size.x + margin.x, y + h), Color.WHITE, line_width)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"zoom_in"):
		_zoom_texture(ZOOM_SPEED)
	elif event.is_action_pressed(&"zoom_out"):
		_zoom_texture(-ZOOM_SPEED)
	elif event.is_action_pressed(&"zoom_reset"):
		_reset_zoom()
	elif event.is_action_pressed(&"pan_left"):
		_pan_texture(Vector2.LEFT * PAN_SPEED)
	elif event.is_action_pressed(&"pan_right"):
		_pan_texture(Vector2.RIGHT * PAN_SPEED)
	elif event.is_action_pressed(&"pan_up"):
		_pan_texture(Vector2.DOWN * PAN_SPEED)
	elif event.is_action_pressed(&"pan_down"):
		_pan_texture(Vector2.UP * PAN_SPEED)


func _zoom_texture(factor: float) -> void:
	var scale_factor := pow(1.1, factor)
	var size_change := (size * scale_factor) - size
	scale *= scale_factor
	position -= (size_change) / 2


func _reset_zoom() -> void:
	scale = Vector2.ONE
	position = (get_parent_control().size - size) / 2
	position.y = 0


func _pan_texture(motion: Vector2) -> void:
	position += motion
	var margin := Vector2.ONE * 64
	var max_pos := Vector2.ZERO + margin
	var min_pos := (get_parent_control().size - size * scale) - margin
	position.x = clampf(position.x, min_pos.x, max_pos.x)
	position.y = clampf(position.y, min_pos.y, max_pos.y)

