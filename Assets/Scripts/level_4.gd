extends Node2D

@onready var enemie: Node2D = $Enemies/Enemie
@onready var timer: Timer = $Timer

var main: Node2D

func _ready() -> void:
	timer.start()


func _on_timer_timeout() -> void:
	enemie.queue_free()
