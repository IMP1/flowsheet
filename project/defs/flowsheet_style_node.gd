class_name FlowsheetNodeStyle
extends Resource

enum StretchMode {
	STRETCH, TILE, TILE_FIT
}

@export var visible: bool = true
@export var size: Vector2 = Vector2(160, 40)
@export var background_colour: Color = Color.WHITE
@export var border_thickness: float = 1
@export var border_colour: Color = Color.BLACK
@export var corner_radius: int = 4
@export var text_colour: Color = Color.BLACK
@export var text_size: int = 12
@export var text_font_name: String
@export var background_image_path: String = ""
@export var background_image_rect: Rect2i = Rect2i(0, 0, 0, 0)
@export var background_image_scaling: StretchMode = StretchMode.STRETCH
