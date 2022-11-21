extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text: RichTextLabel = $Text
@onready var type_audio: Array = $TypeAudio/Type.get_children()
@onready var error_audio: Array = $TypeAudio/Error.get_children()
@onready var correct_audio: AudioStreamPlayer = $TypeAudio/Correct

var words_array: Array = JSON.parse_string(FileAccess.open("res://words.json", FileAccess.READ).get_as_text())
var word: String 
var typed_word: Array

func _ready() -> void:
	animation_player.play("start")
	word = words_array.pick_random()


func start_game() -> void:
	GameManger.start_game()
	update_text()


func _unhandled_key_input(event: InputEvent) -> void:
	update_typed_word(event)
	update_text()
	
	if typed_word.size() >= word.length() and not typed_word.has(null):
		GameManger.increase_life()
		animation_player.play("correct")
		correct_audio.play()
		typed_word.clear()
		word = words_array.pick_random()
		update_text()


func update_typed_word(event: InputEvent) -> void:
	if ( event.is_pressed() or event.is_echo() ) and event.keycode == KEY_BACKSPACE and typed_word.has(null):
		error_audio.pick_random().play()
		typed_word.pop_back()
	
	if not event.is_pressed():
		return
	
	if typed_word.size() >= word.length():
		return
	
	if char(event.unicode).is_empty():
		return
	#add back particles
	#add back correct on complete
	#add back correct audio
	if char(event.unicode) == word[typed_word.size()]:
		type_audio.pick_random().play()
		typed_word.append(char(event.unicode))
		if not typed_word.has(null):
			GameManger.increase_score()
	else:
		error_audio.pick_random().play()
		typed_word.append(null)
		GameManger.decrease_score()


func update_text() -> void:
	text.clear()
	text.append_text("[center]")
	text.append_text("[correct]")
	for i in word.length():
		if typed_word.size() <= i:
			text.push_color(Color.WHITE)
		elif typed_word[i]:
			text.push_color(Color.GOLD)
		else:
			text.push_color(Color.RED)
		
		text.add_text(word[i])
