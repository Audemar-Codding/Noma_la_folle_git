extends Area2D

@export var one_way: bool = false
@export var down: bool = false

func remove_exit() -> void:
	queue_free()
