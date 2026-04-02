extends Node2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var label_dialogs: Array[String]
@export var anim: String = "idle"

var noma_entered: bool = false

signal start_dialog

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Noma":
		noma_entered = true
		start_dialog.emit(label_dialogs, anim)
		body.is_on_dialog = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Noma":
		noma_entered = false
		call_deferred("desactive_collisions")

func desactive_collisions() -> void:
	collision_shape_2d.disabled = true
