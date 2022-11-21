@tool
class_name RichTextCorrect
extends RichTextEffect

var bbcode: String = "correct"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	
	var speed: float = char_fx.env.get("speed", 2.0)
	var offset: = Vector2(0,sin(char_fx.elapsed_time * speed) * 10)
	
	char_fx.offset = offset
	
	return true
