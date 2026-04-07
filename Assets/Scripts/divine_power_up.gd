extends Area2D

@onready var label_b: Label = $LabelB
@onready var label_e: Label = $LabelE
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var main: Node2D

@export var label_dialogs: Array[String]
@export var anim: String = "idle"
@export var cost: int = 1

enum Effects {
	SPEED,
	SOUND_JUMP,
	FLASH
}

@export var funcs_effect: Effects

var noma_entered: bool = false
var noma: Node2D

signal start_dialog

func _ready() -> void:
	main = get_node("/root/Main")
	label_b.text = "B:%s" % cost

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and noma_entered:
		start_dialog.emit(label_dialogs, anim)
		noma.is_on_dialog = true
	elif Input.is_action_just_pressed("buy") and noma_entered:
		if main.current_score >= cost:
			main.edit_score(cost * -1)
			call_deferred("disable_colision")
			apply_effect()
			animated_sprite_2d.modulate.a = 0.2
			label_e.visible = false
			label_b.visible = false
			audio_stream_player.play()
		else:
			start_dialog.emit(["Il me faut plus d'artéfacts ! 🤩"], anim)
			noma_entered = false
			noma.is_on_dialog = true


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Noma":
		noma = body
		label_e.visible = true
		label_b.visible = true
		noma_entered = true

func _on_body_exited(_body: Node2D) -> void:
	label_e.visible = false
	label_b.visible = false
	noma_entered = false

func disable_colision() -> void:
	collision_shape_2d.disabled = true

func apply_effect():
	match funcs_effect:
		Effects.SPEED:
			noma.SPEED = 550.0
			start_dialog.emit(["Vitesse boosté !"], "jumping")
		Effects.SOUND_JUMP:
			noma.kawai_sound = true
			main.save_variables.kawai = true
			start_dialog.emit(["ENJOY THE CUTENESS"], "jumping")
		Effects.FLASH:
			noma.ability["flash"] = true
			main.save_variables.flash = true
			start_dialog.emit(["Divine Flash obtenu !","Utilise le flash avec L !"], "jumping")
