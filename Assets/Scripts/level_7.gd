extends Node2D

var main: Node2D
var Audio

func _ready() -> void:
	main = get_node("/root/Main")
	Audio = get_node("/root/Main/LevelRoot/Noma/Audios/DivineVoices")
	var dialog_box = main.get_node("Textbox")
	dialog_box.dialog_finished.connect(_on_dialog_finished)

func _on_dialog_finished() -> void:
	if Audio:
		Audio.stop()
