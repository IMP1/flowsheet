class_name FlowsheetLinkStyle
extends Resource

enum CurveStyle { STRAIGHT, ELBOW, BEZIER }

@export var visible: bool = true
@export var line_width: float = 2
@export var line_colour: Color = Color.BLACK
@export var text: String = ""
@export var text_offset: float = 0.5
@export var text_size: int = 12
@export var text_colour: Color = Color.BLACK
@export var text_font_name: String = "AtkinsonHyperlegible-Regular"
@export var icon_path: String = ""
@export var icon_offset: float = 0.5
@export var curve_style: CurveStyle = CurveStyle.ELBOW
@export var curve_param_1: float = 0.5
@export var curve_param_2: float = 0.2
