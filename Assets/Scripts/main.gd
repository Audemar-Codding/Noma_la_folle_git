extends Node2D
# Canvas
@onready var textbox: CanvasLayer = $Textbox
@onready var score: Label = $CanvasLayer/ScorePanel/Score
@onready var actual_vie_panel: Panel = $CanvasLayer/ViePanel/ActualViePanel


# Audios
@onready var fill_audio: AudioStreamPlayer = $Audio/Sounds/FillAudio
@onready var hit_audio: AudioStreamPlayer = $Audio/Sounds/HitAudio
@onready var voice_hit_audio: AudioStreamPlayer = $Audio/Sounds/VoiceHitAudio

@onready var base_music: AudioStreamPlayer = $Audio/Music/BaseAudio

# Timers

# Variables
var current_score: int = 0
var level: int = 11
var level_modif: int = 1
var levelOneWay: bool = false
var current_level_root: Node = null
var noma: CharacterBody2D
var nomalife: float = 80


func _ready() -> void:
	current_level_root = get_node("LevelRoot")
	textbox.dialog_finished.connect(_on_finished_dialog)
	_load_level(level, true)
	base_music.play()

# ------------------
# LEVEL MANAGEMENT
# ------------------

func _load_level(level_number:int, first_level = false) -> void:
	if current_level_root:
		current_level_root.queue_free()
	
	# Change Level
	var level_path = "res://Assets/Scenes/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	
	# Place Player
	if !first_level:
		var way = null
		if level_modif > 0:
			way = current_level_root.get_node_or_null("ExitNext")
		else:
			way = current_level_root.get_node_or_null("ExitLast")
		if way:
			levelOneWay = way.one_way
			
			var shape = way.get_node("CollisionShape2D").shape
			
			var y_bottom = way.position.y 
			var x_pos = way.position.x
			
			if way.down != true:
				x_pos = x_pos + -50 * level_modif
				y_bottom = y_bottom + shape.extents.y
			else:
				y_bottom = y_bottom + 50
				noma.is_dropping = true
				
			noma.position = Vector2(x_pos, y_bottom)
			
			if levelOneWay:
				way.call_deferred("remove_exit")
	
func _setup_level(level_root: Node) -> void:
	noma = current_level_root.get_node("Noma")
	
	# Connect Heal
	noma.heal.connect(_on_noma_heal)
	
	# Connect Exits => Ce Code est stupide man (connecte github)
	var exitNext = level_root.get_node_or_null("ExitNext")
	if exitNext:
		level_modif = 1
		exitNext.body_entered.connect(_on_exit_body_entered.bind(level_modif))

	var exitLast = level_root.get_node_or_null("ExitLast")
	if exitLast:
		level_modif = -1
		exitLast.body_entered.connect(_on_exit_body_entered.bind(level_modif))
	
	# Connect Dialog Interact
	var dialog_interacts = level_root.get_node_or_null("DialogInteract")
	if dialog_interacts:
		for dialog_props in dialog_interacts.get_children():
			dialog_props.start_dialog.connect(_on_start_dialog)
	 
	# Connect Dialog Area
	var dialog_areas = level_root.get_node_or_null("DialogAreas")
	if dialog_areas:
		for dialog_area in dialog_areas.get_children():
			dialog_area.start_dialog.connect(_on_start_dialog)
	
	# Connect Divine powers ups
	var divine_powers_ups = level_root.get_node_or_null("DivinePowersUps")
	if divine_powers_ups:
		for divine_power_up in divine_powers_ups.get_children():
			divine_power_up.start_dialog.connect(_on_start_dialog)
	
	# Connect Collectable Artefacts
	var artefacts = level_root.get_node_or_null("Artefacts")
	if artefacts:
		for artefact in artefacts.get_children():
			artefact.artefact_collected.connect(edit_score.bind(1))
	
	# Connect Enemies
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemie in enemies.get_children():
			enemie.player_hit.connect(_on_noma_hit)

func _on_start_dialog(label_dialogs, anim) -> void:
	if !noma.is_on_floor():
		await noma.landed
	
	for label_dialog in label_dialogs:
		textbox.queue_text(label_dialog)
	
	noma.idle_anim = anim
	noma.can_move = false


# ====== SIGNALS HANDLER

func _on_finished_dialog() -> void:
	noma.is_on_dialog = false
	noma.can_move = true
	noma.idle_anim = "idle"
	noma.get_node("AnimatedSprite2D").play()

func _on_exit_body_entered(body: Node2D, dir: int) -> void:
	if body.name == "Noma":
		body.can_jump = false
		level += dir
		call_deferred("_load_level",level)

# ====== SCORE HANDLER
func edit_score(value) -> void:
	current_score += value
	score.text = "%s" % current_score

# ====== Damage gestion
func _on_noma_hit(dmg) -> void:
	nomalife = max(nomalife - dmg, 0)
	actual_vie_panel.size.x = (float(nomalife)/100 * 146.00)
	
	Engine.time_scale = 0.5
	noma.can_move = false
	hit_audio.play()
	voice_hit_audio.pitch_scale = 1.0 + 1.0-float(nomalife/100)
	voice_hit_audio.play()
	
	if nomalife <= 0:
		print("dead")
		Engine.time_scale = 1.0
		get_tree().reload_current_scene()

func _on_noma_heal(heal) -> void:
	if nomalife <= 100:
		nomalife = min(nomalife + heal, 100)
		fill_audio.play()
		actual_vie_panel.size.x = (float(nomalife)/100 * 146.00)
