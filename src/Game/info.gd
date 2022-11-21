extends Control


@onready var life_bar: ProgressBar = $Detail/LifeMeter
@onready var score_label: Label = $Detail/Score
@onready var high_score_label: Label = $Detail/HighScore
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var _t = GameManger.game_started.connect(_on_game_started)
	_t = GameManger.life_changed.connect(_on_life_changed)
	_t = GameManger.score_changed.connect(_on_score_changed)
	_t = GameManger.life_max_changed.connect(_on_life_max_changed)
	_t = GameManger.high_score_changed.connect(_on_high_score_changed)
	_on_life_max_changed()


func _on_game_started() -> void:
	animation_player.play("start")


func _on_life_changed() -> void:
	life_bar.value = GameManger.life


func _on_score_changed() -> void:
	score_label.text = str(GameManger.score)


func _on_high_score_changed() -> void:
	high_score_label.text = "HI " + str(GameManger.high_score)


func _on_life_max_changed() -> void:
	life_bar.max_value = GameManger.life_max
