extends CodeEdit

signal text_submitted(text: String)

# TODO: There is a code highlighting resource in the /resources folder. 
#       Set the colours and use it!

# TODO: Handle up key and keep a history of commands


func _gui_input(event: InputEvent) -> void:
	# Consume scrolling events
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_WHEEL_DOWN or \
				(event as InputEventMouseButton).button_index == MOUSE_BUTTON_WHEEL_UP:
			accept_event()
	if not event is InputEventKey:
		return
	if not event.is_pressed():
		return
	if (event as InputEventKey).keycode == KEY_ENTER:
		if Input.is_key_label_pressed(KEY_SHIFT):
			insert_text_at_caret("\n")
		else:
			text_submitted.emit(text)
