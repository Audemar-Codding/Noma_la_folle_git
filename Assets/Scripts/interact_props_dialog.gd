extends Area2D
@onready var label_e: Label = get_node("Label")
@export var label_dialogs: Array[String]
@export var anim: String = "idle"

var noma_entered: bool = false
var noma: Node2D

signal start_dialog

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and noma_entered:
		start_dialog.emit(label_dialogs, anim)
		noma_entered = false
		label_e.visible = false
		noma.is_on_dialog = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Noma":
		noma = body
		label_e.visible = true
		noma_entered = true

func _on_body_exited(_body: Node2D) -> void:
	label_e.visible = false
	noma_entered = false
