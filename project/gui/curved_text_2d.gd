class_name CurvedText2D
extends Node2D

@export_multiline var text: String
@export var path: Path2D
@export_range(0.0, 1.0) var path_offset_ratio: float = 0.5
@export var font: Font
@export var text_size: int = 12
@export var colour: Color
@export var vertical_offset: float = 6.0
# TODO: I guess for future use or to share, add outline colour and all that jazz from Label

var _text_length: float = 0.0


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	_text_length = font.get_string_size(text, 0, -1, text_size).x # TODO: Move this to a setter
	
	var curve := path.curve
	var offset := lerpf(0.0, 1.0 - (_text_length / curve.get_baked_length()), path_offset_ratio)
	
	for char in text:
		var old_canvas_trans := get_transform()
		var trans := curve.sample_baked_with_rotation(curve.get_baked_length() * offset)
		draw_set_transform(trans.origin, trans.get_rotation() - PI / 2)
		draw_char(font, Vector2(0, -vertical_offset), char, text_size, colour)
		var char_size := font.get_string_size(char, 0, -1, text_size)
		offset += char_size.x / curve.get_baked_length()
		draw_set_transform_matrix(get_transform())
