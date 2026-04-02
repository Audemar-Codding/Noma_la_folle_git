extends Node2D

@onready var enemie: Node2D = $Enemies/Enemie
@onready var move_box_area: StaticBody2D = $MoveBoxArea
@onready var collision_shape_2d: CollisionShape2D = $MoveBoxArea/CollisionShape2D
@onready var timer: Timer = $Timer

var main: Node2D

func _ready() -> void:
	enemie.can_move = false
	main = get_node("/root/Main")
	var dialog_box = main.get_node("Textbox")
	dialog_box.dialog_finished.connect(_on_dialog_finished)

func _on_dialog_finished() -> void:
	timer.start()
	enemie.direction = -1.0
	enemie.flip_enemie()
	enemie.can_move = true

func active_collision_move_box() -> void:
	collision_shape_2d.disabled = false

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	move_box_area.visible = true
	call_deferred("active_collision_move_box")


func _on_timer_timeout() -> void:
	enemie.queue_free()
