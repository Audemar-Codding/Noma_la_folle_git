extends Node2D

var main: Node2D
var base_music: AudioStreamPlayer
@onready var aniverssaire_audio: AudioStreamPlayer = $Audio/AniverssaireAudio
@onready var music_audio: AudioStreamPlayer = $Audio/MusicAudio
@onready var animated_sprite_2d: AnimatedSprite2D = $DialogInteract/DialogProps/AnimatedSprite2D
@onready var party: Node2D = $Party

func _ready() -> void:
	main = get_node("/root/Main")
	base_music = get_node("/root/Main/Audio/Music/BaseAudio")
	var dialog_box = main.get_node("Textbox")
	dialog_box.dialog_finished.connect(_start_party)

func _start_party() -> void:
	base_music.stop()
	aniverssaire_audio.play()
	animated_sprite_2d.play("gift")


func _on_aniverssaire_audio_finished() -> void:
	music_audio.play()
	party.visible = true
