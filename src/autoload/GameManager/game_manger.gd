extends Node

signal game_started
signal game_ended

signal difficulty_climax_changed
signal life_max_changed
signal life_increase_changed
signal score_increase_changed
signal score_decrease_changed

signal difficulty_changed
signal life_changed
signal score_changed
signal high_score_changed

var is_game_started: bool = false

@export var life_max: float = 3.0: set = _on_life_max_changed
@export var life_increase: float = 0.5: set = _on_life_increase_changed
@export var score_increase: float = 10.0: set = _on_score_increase_changed
@export var score_decrease: float = 50.0: set = _on_score_decrease_changed
@export var difficulty_climax: float = 1000.0: set = _on_difficulty_climax_changed
@export var difficulty_curve: Curve

@onready var score: int = 0: set = _on_score_changed
@onready var life: float = life_max: set = _on_life_changed
@onready var high_score: int = score: set = _on_high_score_changed


func start_game() -> void:
	is_game_started = true
	game_started.emit()


func end_game() -> void:
	is_game_started = false
	game_ended.emit()


func _process(delta: float) -> void:
	if is_game_started:
		self.life -= delta * difficulty_curve.sample(score / difficulty_climax)
		
		if life <= 0:
			self.score = 0


func increase_life() -> void:
	self.life = life_max


func increase_score() -> void:
	if life <= 0:
		life = life_max
	self.score += int(roundf(score_increase * ( life if life >= 0.0 else 0.0 )))
func decrease_score() -> void:
	if life <= 0:
		life = life_max
	self.score -= int(roundf(score_decrease * ( life if life >= 0.0 else 0.0 )))


func _on_life_changed(value: float) -> void:
	life = value
	life_changed.emit()


func _on_score_changed(value: int) -> void:
	score = value
	score_changed.emit()
	
	if score > high_score:
		self.high_score = score


func _on_high_score_changed(value: int) -> void:
	high_score = value
	high_score_changed.emit()


func _on_life_max_changed(value: float) -> void:
	life_max = value
	life_max_changed.emit()


func _on_life_increase_changed(value: float) -> void:
	life_increase = value
	life_increase_changed.emit()


func _on_score_increase_changed(value: float) -> void:
	score_increase = value
	score_increase_changed.emit()


func _on_score_decrease_changed(value: float) -> void:
	score_decrease = value
	score_decrease_changed.emit()


func _on_difficulty_climax_changed(value: float) -> void:
	difficulty_climax = value
	difficulty_climax_changed.emit()
