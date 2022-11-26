extends Control


@onready var life_bar: ProgressBar = $Detail/LifeMeter
@onready var score_label: Label = $Detail/Score
@onready var reset_score_audio: AudioStreamPlayer = $ResetScoreAudio
@onready var high_score_label: Label = $Detail/HighScore
@onready var high_score_center: CenterContainer = $Detail/HighScore/Center
@onready var high_score_particle: CPUParticles2D = $Detail/HighScore/Center/HighScoreParticles
@onready var particles: CPUParticles2D = $Center/Particles2D
@onready var high_score_audio: AudioStreamPlayer = $Detail/HighScore/HighScoreAudio
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var _t = GameManger.game_started.connect(_on_game_started)
	_t = GameManger.life_changed.connect(_on_life_changed)
	_t = GameManger.score_changed.connect(_on_score_changed)
	_t = GameManger.life_max_changed.connect(_on_life_max_changed)
	_t = GameManger.high_score_changed.connect(_on_high_score_changed)
	_t = GameManger.reset_score.connect(_on_reset_score)
	_on_life_max_changed()


func _on_game_started() -> void:
	animation_player.play("start")


func _on_life_changed() -> void:
	life_bar.value = GameManger.life


func _on_score_changed() -> void:
	score_label.text = str(GameManger.score)


func _on_high_score_changed() -> void:
	high_score_label.text = "HI " + str(GameManger.high_score)
	
	var obj: CPUParticles2D = high_score_particle.duplicate()
	obj.global_position = high_score_center.global_position
	add_child(obj)
	obj.emitting = true
	
	obj = particles.duplicate()
	obj.global_position = particles.global_position
	add_child(obj)
	obj.emitting = true
	
	high_score_audio.play()


func _on_life_max_changed() -> void:
	life_bar.max_value = GameManger.life_max


func _on_reset_score() -> void:
	if not reset_score_audio.playing:
		reset_score_audio.play()
