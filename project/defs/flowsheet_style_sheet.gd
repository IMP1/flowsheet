class_name FlowsheetStyle
extends Resource

enum StretchMode {
	STRETCH, TILE, TILE_FIT
}

@export var background_colour: Color = Color.ANTIQUE_WHITE
@export var background_image_path: String = ""
@export var background_image_rect: Rect2i = Rect2i(0, 0, 0, 0)
@export var background_image_scaling: StretchMode = StretchMode.TILE
