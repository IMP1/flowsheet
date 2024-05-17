class_name NodeScriptEditor
extends PopupPanel

signal cancelled
signal confirmed(new_code: String)

@export var code: String
@export var node: FlowsheetNodeGui

const LUA_KEYWORDS := [
	"and", "break", "do", "else", "elseif", "end", "false", "for", "function", 
	"if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", 
	"until", "while"
]
const DEFAULT_TEXT_COLOUR := Color8(224, 224, 224)
const STRING_COLOUR := Color.YELLOW
const COMMENT_COLOUR := Color.DIM_GRAY
const LITERAL_COLOUR := Color.REBECCA_PURPLE
const KEYWORD_COLOUR := Color.CRIMSON

@onready var _text_edit := $Contents/CodeEdit as CodeEdit
@onready var _confirm := $Contents/Actions/Confirm as Button
@onready var _cancel := $Contents/Actions/Cancel as Button


func _ready() -> void:
	visible = false
	about_to_popup.connect(_setup)
	_confirm.pressed.connect(func(): 
		code = _text_edit.text
		confirmed.emit(code))
	_cancel.pressed.connect(func(): 
		cancelled.emit())
	_init_syntax_highlighting()


func _setup() -> void:
	_text_edit.text = code


func _init_syntax_highlighting() -> void:
	var highlight := _text_edit.syntax_highlighter as CodeHighlighter
	highlight.symbol_color = DEFAULT_TEXT_COLOUR
	highlight.member_variable_color = DEFAULT_TEXT_COLOUR
	highlight.number_color = LITERAL_COLOUR
	highlight.add_color_region("--", "", COMMENT_COLOUR)
	highlight.add_color_region("\"", "\"", STRING_COLOUR)
	for keyword in LUA_KEYWORDS:
		highlight.add_keyword_color(keyword, KEYWORD_COLOUR)
