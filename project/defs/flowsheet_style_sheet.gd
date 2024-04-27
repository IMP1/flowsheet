class_name FlowsheetStyle
extends Resource

enum StretchMode {
	SCALE, TILE, KEEP_BEGIN, KEEP_CENTRED, KEEP_END
}

@export var background_colour: Color = Color.ANTIQUE_WHITE
@export var background_image_path: String = ""
@export var background_image_rect: Rect2 = Rect2(0, 0, 0, 0)
@export var background_image_scaling: StretchMode = StretchMode.TILE
