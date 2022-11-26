extends CanvasLayer


@export var default_theme: Theme
@export var fonts: Dictionary
@onready var sound_slider: HSlider = %SoundSlider
@onready var font_button: Button = %FontButton
@onready var font_button_text: String = font_button.text
var selected_font_index: int = 0: set = _on_selected_font_index_changed


func _ready() -> void:
	_on_font_button_pressed()
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = not visible
		get_tree().paused = visible


func _on_sound_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(0, sound_slider.value)
func _on_sound_default_button_pressed() -> void:
	sound_slider.value = 0
	AudioServer.set_bus_volume_db(0, 0)


func _on_font_button_pressed() -> void:
	selected_font_index += 1
	if selected_font_index >= fonts.size():
		selected_font_index = 0


func _on_selected_font_index_changed(value: int) -> void:
	selected_font_index = value
	if selected_font_index >= fonts.size() or fonts.is_empty():
		return
	default_theme.default_font = fonts.get(fonts.keys()[selected_font_index])[0]
	default_theme.default_font_size = fonts.get(fonts.keys()[selected_font_index])[1]
	font_button.text = font_button_text % fonts.keys()[selected_font_index]
