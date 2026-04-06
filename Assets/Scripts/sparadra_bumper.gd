extends Area2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	pass

func sprite_jump() -> void:
	var t = create_tween()
	t.tween_property(sprite_2d, "offset", Vector2(0, 5), 0.2)
	t.tween_property(sprite_2d, "offset", Vector2(0, 0), 0.5)


func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.name == "FeetsArea2D":
		var noma = area.get_parent()
		audio_stream_player.play()
		sprite_jump()
		noma.JUMP_VELOCITY = -1050.0
		noma.trigger_jump = true
		noma.can_jump = true


func _on_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.name == "FeetsArea2D":
		var noma = area.get_parent()
		noma.JUMP_VELOCITY = -850.0
		noma.trigger_jump = false
		noma.can_jump = false
