class_name CurvedText2D
extends Node2D

@export var path: Path2D:
	set(value):
		path = value
		queue_redraw()
@export_multiline var text: String:
	set(value):
		text = value
		_text_length = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, text_size).x
		queue_redraw()
@export_range(0.0, 1.0) var path_offset_ratio: float = 0.5:
	set(value):
		path_offset_ratio = value
		queue_redraw()
@export var font: Font:
	set(value):
		font = value
		_text_length = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, text_size).x
		queue_redraw()
@export var text_size: int = 12:
	set(value):
		text_size = value
		_text_length = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, text_size).x
		queue_redraw()
@export var colour: Color:
	set(value):
		colour = value
		queue_redraw()
@export var vertical_offset: float = 6.0:
	set(value):
		vertical_offset = value
		queue_redraw()
# TODO: I guess for future use or to share, add outline colour and all that jazz from Label

var _text_length: float = 0.0


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var curve := path.curve
	var offset := lerpf(0.0, 1.0 - (_text_length / curve.get_baked_length()), path_offset_ratio)
	
	for char in text:
		var old_canvas_trans := get_transform()
		var trans := curve.sample_baked_with_rotation(curve.get_baked_length() * offset)
		draw_set_transform(trans.origin, trans.get_rotation() - PI / 2)
		draw_char(font, Vector2(0, -vertical_offset), char, text_size, colour)
		var char_size := font.get_string_size(char, HORIZONTAL_ALIGNMENT_LEFT, -1, text_size)
		offset += char_size.x / curve.get_baked_length()
		draw_set_transform_matrix(get_transform())
