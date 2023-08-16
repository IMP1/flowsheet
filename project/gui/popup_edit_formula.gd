extends PopupPanel

signal cancelled
signal confirmed(new_formula)

@export var code: String

@onready var _input := $Contents/TextEdit as TextEdit
@onready var _timer := $Timer as Timer
@onready var _error_message := $Contents/ErrorMessage as Label
@onready var _common_formulae := $Contents/CommonFormulae as Control


func _ready() -> void:
	about_to_popup.connect(func(): 
		_input.text = code
		_input.grab_focus.call_deferred())
	# Reset timer on text change
	_input.text_changed.connect(func(): _timer.start())
	_input.caret_changed.connect(func(): _timer.start())
	# Common Formulae
	for b in _common_formulae.get_children():
		var button := b as Button
		button.pressed.connect(_default_to.bind(button.tooltip_text))


func cancel() -> void:
	cancelled.emit()


func confirm() -> void:
	code = _input.text
	confirmed.emit(code)


func _attempt_parse() -> void:
	var new_code := _input.text
	if new_code.is_empty():
		return
	var expr := FlowsheetFormula.new()
	var parse_result := expr.parse(new_code)
	if parse_result != OK:
		_error_message.text = expr.get_error_text()
	else:
		_error_message.text = ""


func show_help() -> void:
	# TODO: Not yet implemented
	pass


func _default_to(code: String) -> void:
	_input.text = code
