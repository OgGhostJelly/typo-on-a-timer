class_name MulticoloredLabel
extends HBoxContainer

signal appended_text
signal changed_letter_color
signal changed_letter_text
signal cleared
signal removed_letter


var letters: Array


func append_text(text: String, color: Color) -> void:
	for letter in text:
		var obj: Label = Label.new()
		obj.text = letter
		obj.add_theme_color_override("font_color", color)
		letters.append(obj)
		add_child(obj)
	appended_text.emit(text, color)


func clear() -> void:
	letters.clear()
	for child in get_children():
		child.queue_free()
	cleared.emit()


func change_letter_color(index: int, color: Color) -> void:
	if index >= letters.size():
		return
	(letters[index] as Label).add_theme_color_override("font_color", color)
	changed_letter_color.emit(index, color)


func change_letter_text(index: int, text: String) -> void:
	if index >= letters.size():
		return
	(letters[index] as Label).text = text
	changed_letter_text.emit(index, text)


func remove_letter(index: int) -> void:
	if index >= letters.size():
		return
	(letters[index] as Label).queue_free()
	removed_letter.emit(index)


func get_label_from_index(index: int) -> Label:
	return (letters[index] as Label)
