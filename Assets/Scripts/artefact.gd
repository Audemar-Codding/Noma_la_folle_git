extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collected_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

signal artefact_collected

func _ready() -> void:
	animated_sprite_2d.frame = randi_range(0, 1423)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Noma":
		animated_sprite_2d.animation = "collected"
		animated_sprite_2d.play()
		artefact_collected.emit()
		collected_sound.pitch_scale = randf_range(1.3,1.5)
		collected_sound.play()
		call_deferred("_disable_collision")
		
		await animated_sprite_2d.animation_looped
		queue_free()


func _disable_collision() -> void:
	collision_shape_2d.disabled = true
