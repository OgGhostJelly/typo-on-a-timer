extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_button: Button = %StartButton
@onready var next_audio: AudioStreamPlayer = $Next
@export_file("*.tscn","*.scn") var game_scene: String


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_game()


func _on_start_button_pressed() -> void:
	start_game()


func start_game() -> void:
	if not start_button.disabled:
		next_audio.play()
		start_button.disabled = true
		animation_player.play("leave")
		await animation_player.animation_finished
		var _t = get_tree().change_scene_to_file(game_scene)
