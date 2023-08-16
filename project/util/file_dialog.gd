extends FileDialog

signal about_to_close(confirmed)


func _ready() -> void:
#	file_selected.connect(func(_path): about_to_close.emit())
	canceled.connect(func(): about_to_close.emit(false))
	confirmed.connect(func(): about_to_close.emit(true))
	file_selected.connect(func(_path): about_to_close.emit(true))
