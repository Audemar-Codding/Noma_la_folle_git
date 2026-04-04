extends Node2D
@onready var grillions_audio: AudioStreamPlayer = $GrillionsAudio
@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
@onready var toon_zzz_audio: AudioStreamPlayer = $ToonZZZAudio
@onready var dream_audio: AudioStreamPlayer = $DreamAudio
@onready var timer: Timer = $Timer
@onready var color_rect: ColorRect = $ColorRect
@onready var noma_sprite: Sprite2D = $NomaSprite

func _on_doum_audio_finished() -> void:
	noma_sprite.visible = true
	label.visible = false
	grillions_audio.play()
	toon_zzz_audio.play()
	texture_rect.texture = load("res://Assets/Sprites/Background/grass.png")
	timer.start()

func _on_timer_timeout() -> void:
	dream_audio.play()
	toon_zzz_audio.stop()
	grillions_audio.stop()
	fadeOut()

func fadeOut():
	var t = create_tween()
	t.tween_property(color_rect, "modulate:a", 1.0, 1.5)
	await t.finished
	get_tree().change_scene_to_file("res://Assets/Scenes/main.tscn")
