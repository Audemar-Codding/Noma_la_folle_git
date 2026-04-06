extends Node2D

var main: Node2D
var dialogEnd: int = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $DialogInteract/Maximilien/AnimatedSprite2D
@onready var maximilien: Area2D = $DialogInteract/Maximilien
@onready var maximilien_sprite: AnimatedSprite2D = $DialogInteract/Maximilien/AnimatedSprite2D
@onready var boss_plateforme: Sprite2D = $BossPlateforme
@onready var max_collision_shape_2d: CollisionShape2D = $DialogInteract/Maximilien/CollisionShape2D
@onready var trade_numbers: Node2D = $TradeNumbers
@onready var trade_number_timer: Timer = $TradeNumberTimer
@onready var jump_audio: AudioStreamPlayer = $Audio/JumpAudio
@onready var boss_music: AudioStreamPlayer = $Audio/BossMusic
@onready var max_talk_audio: AudioStreamPlayer = $Audio/MaxTalkAudio
@onready var start_dialog_area_after_fight: Node2D = $DialogAreas/StartDialogAreaAfterFight
@onready var max_loose_audio: AudioStreamPlayer = $Audio/MaxLooseAudio
@onready var after_level: Node2D = $DialogAreas/AfterLevel
@onready var exit_next: Area2D = $ExitNext


# Son boss
var trade_Number = preload("res://Assets/Scenes/trade_number.tscn")
var number_count: int = 0
var base_music: AudioStreamPlayer

func _ready() -> void:
	main = get_node("/root/Main")
	base_music = get_node("/root/Main/Audio/Music/BaseAudio")
	var dialog_box = main.get_node("Textbox")
	dialog_box.dialog_finished.connect(_maximilian_boss_fight)
	maximilien.start_dialog.connect(_flip_maximilian)

func _process(delta: float) -> void:
	pass

func _flip_maximilian(_label_dialogs, _anim) -> void:
	animated_sprite_2d.flip_h = true

func _maximilian_boss_fight() -> void:
	dialogEnd += 1
	if dialogEnd == 2:
		base_music.stop()
		jump_audio.play()
		boss_plateforme.visible = true
		maximilien_sprite.play("jump")
		call_deferred("_disable_collision")
		var t = create_tween()
		t.tween_property(maximilien, "position", Vector2(1207.0, 50), 1.0)
		await t.finished
		maximilien_sprite.speed_scale = 2.0
		maximilien_sprite.play("talk")
		trade_number_timer.start()
		boss_music.play()
		max_talk_audio.play()
	if dialogEnd == 3:
		max_loose_audio.play()
		boss_plateforme.visible = false
		var t = create_tween()
		t.tween_property(maximilien, "position", Vector2(1207.0, 825), 1.5)
		var tb = create_tween()
		tb.tween_property(maximilien, "rotation", 80.0, 1.0)
		
		await t.finished
		
		after_level.position = Vector2(351.0, 480.0)
	
	if dialogEnd == 4:
		exit_next.position = Vector2(1289.0, 433.0)

func _disable_collision():
	max_collision_shape_2d.disabled = true

func _on_trade_number_timer_timeout() -> void:
	number_count += 1
	trade_number_timer.start()
	if number_count < 80:
		var number = trade_Number.instantiate()
		trade_numbers.add_child(number)
		var mod = number_count * 0.005
		trade_number_timer.wait_time = max( (randf_range(0.5,0.9)-mod), 0.2)
	elif number_count == 85:
		trade_number_timer.stop()
		_end_boss_fight()

func _end_boss_fight() -> void:
	max_talk_audio.stop()
	boss_music.stop()
	base_music.play()
	maximilien_sprite.speed_scale = 1.0
	start_dialog_area_after_fight.position = Vector2(351.0, 480.0)
	
