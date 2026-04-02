extends Node2D
@onready var noma: CharacterBody2D = $Noma

func _ready() -> void:
	noma.get_node("AnimatedSprite2D").flip_h = true
