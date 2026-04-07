extends Node2D

var main: Node2D
var audio

func _ready() -> void:
	main = get_node("/root/Main")
	audio = main.get_node("LevelRoot/Noma/Audios/DivineVoices")
	print(audio.name)
	var dialog_box = main.get_node("Textbox")
	dialog_box.dialog_finished.connect(_on_dialog_finished)

func _on_dialog_finished() -> void:
	get_node("Noma/Audios/DivineVoices").stop()
