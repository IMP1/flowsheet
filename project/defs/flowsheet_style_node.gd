class_name FlowsheetNodeStyle
extends Resource

#enum StretchMode {
	#STRETCH_SCALE, STRETCH_TILE, STRETCH_KEEP_BEGIN, STRETCH_KEEP_CENTRED, STRETCH_KEEP_END
#}

@export var visible: bool = true
@export var size: Vector2 = Vector2(160, 40)
@export var background_colour: Color = Color.WHITE
@export var border_thickness: float = 1
@export var border_colour: Color = Color.BLACK
@export var corner_radius: float = 4
@export var text_colour: Color = Color.BLACK
@export var text_size: int = 12
@export var text_font_name: String
#@export var background_image_texture: Texture2D
#@export var background_image_scaling: StretchMode
#@export var background_image_rect: Rect2
