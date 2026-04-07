extends Node2D
@onready var hint_pray: Label = $HintPray

var first_read: bool = true
var main: Node2D

func _ready() -> void:
	main = get_node("/root/Main")
	var dialog_box = main.get_node("Textbox")
	dialog_box.dialog_finished.connect(_on_dialog_finished)


func _on_dialog_finished() -> void:
	if first_read == true:
		main.get_node("CanvasLayer/ScorePanel").visible = true
		main.get_node("CanvasLayer/ViePanel").visible = true
		hint_pray.visible = true
		first_read = false
		main.get_node("LevelRoot/Noma").ability.pray = true
		main.save_variables.pray = true
	main.get_node("LevelRoot/Noma/Audios/DivineVoices").stop()
