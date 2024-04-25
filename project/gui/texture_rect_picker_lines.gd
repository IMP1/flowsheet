class_name TextureFrame
extends TextureRect

@export var rect: Rect2:
	set(value):
		rect = value
		queue_redraw()


func _draw() -> void:
	var margin := 256
	var x := rect.position.x
	var y := rect.position.y
	var w := rect.size.x
	var h := rect.size.y
	draw_line(Vector2(x, -margin), Vector2(x, size.y + margin), Color.WHITE, 1)
	draw_line(Vector2(x + w, -margin), Vector2(x + w, size.y + margin), Color.WHITE, 1)
	draw_line(Vector2(-margin, y), Vector2(size.x + margin, y), Color.WHITE, 1)
	draw_line(Vector2(-margin, y + h), Vector2(size.x + margin, y + h), Color.WHITE, 1)
