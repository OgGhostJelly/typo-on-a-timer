class_name Footer
extends Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	add_theme_font_size_override("font_size", int(get_theme_default_font_size() / 2.0))
