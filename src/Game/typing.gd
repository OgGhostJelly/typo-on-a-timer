extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text: RichTextLabel = $Text
@onready var particles: CPUParticles2D = $Particles2D
@onready var type_audio: Array = $TypeAudio/Type.get_children()
@onready var error_audio: Array = $TypeAudio/Error.get_children()
@onready var correct_audio: AudioStreamPlayer = $TypeAudio/Correct

var words: Array = JSON.parse_string(FileAccess.open("res://words.json", FileAccess.READ).get_as_text())
var word: String 
var typed_word: Array

func _ready() -> void:
	animation_player.play("start")
	word = words.pick_random()


func start_game() -> void:
	GameManger.start_game()
	update_text()


func _unhandled_key_input(event: InputEvent) -> void:
	if not GameManger.is_game_started:
		return
	
	if not event.is_pressed():
		return
	
	update_typed_word(event)
	update_text()
	is_word_correct()


func update_typed_word(event: InputEvent) -> void:
	if event.keycode == KEY_BACKSPACE or event.keycode == KEY_DELETE:
		if typed_word.count(null):
			if typed_word.size() > 0:
				error_audio.pick_random().play()
			typed_word.pop_back()
		return
	
	if typed_word.size() >= word.length():
		return
	
	if OS.get_keycode_string(event.keycode).to_lower() == word[typed_word.size()].to_lower():
		typed_word.append(OS.get_keycode_string(event.keycode).to_lower())
		
		type_audio.pick_random().play()
		if not typed_word.count(null):
			GameManger.increase_score()
		
		var obj: CPUParticles2D = particles.duplicate()
		add_child(obj)
		obj.global_position = text.get_label_from_index(typed_word.size() - 1).global_position
		obj.emitting = true
		return
	
	error_audio.pick_random().play()
	GameManger.decrease_score()
	typed_word.append(null)


func update_text() -> void:
	text.clear()
	text.append_text(word.to_lower(), Color.WHITE)
	
	for i in typed_word.size():
		if typed_word[i]:
			text.change_letter_color(i, Color.YELLOW)
		else:
			text.change_letter_color(i, Color.RED)


func is_word_correct() -> void:
	if animation_player.is_playing():
		return
	
	if not typed_word.size() >= word.length():
		return
	
	for i in word.length():
		if not word[i].to_lower() == typed_word[i]:
			return
	
	GameManger.increase_life()
	correct_audio.play()
	animation_player.play("correct")
	word = words.pick_random()
	typed_word.clear()
	update_text()
