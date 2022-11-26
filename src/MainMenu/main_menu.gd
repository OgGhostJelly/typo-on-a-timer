extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var next_audio: AudioStreamPlayer = $Next
@export_file("*.tscn","*.scn") var game_scene: String
var enabled: bool = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if enabled:
			enabled = false
			next_audio.play()
			animation_player.play("leave")
			await animation_player.animation_finished
			var _t = get_tree().change_scene_to_file(game_scene)
