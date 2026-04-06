extends Node2D
@onready var label: Label = $Label

@export var label_text: String
@export var audio: AudioStreamPlayer

func _ready() -> void:
	label.text = label_text

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Noma":
		label.visible = true
		if audio != null:
			audio.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Noma":
		label.visible = false
		if audio != null:
			audio.stop()
