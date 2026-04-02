extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Audio
@onready var jump_audio: AudioStreamPlayer = $Audios/JumpAudio
@onready var divine_voices: AudioStreamPlayer = $Audios/DivineVoices

# Timer
@onready var coyote_timer: Timer = $Timer/CoyoteTimer
@onready var heal_timer: Timer = $Timer/HealTimer
@onready var invulnerability_timer: Timer = $Timer/InvulnerabilityTimer


const SPEED: float = 450.0
const JUMP_VELOCITY: float = -850.0
const PLATFORM_MASK = 2

var idle_anim: String = "idle"
var invul_count: int = 0

var can_jump: bool = false
@export var can_move: bool = true
var was_on_floor: bool = false
var feet_on_platform: bool = false
var is_praying: bool = false
var is_on_dialog: bool = false
var invulnerability: bool = false
var hit: bool = false
var is_dropping: bool = false

var ability = {
	"pray": false,
	"attack": false
}

signal landed
signal heal

func _ready() -> void:
	name = "Noma"
	animated_sprite_2d.animation_finished.connect(_on_anim_finished)

func _physics_process(delta: float) -> void:
	var anim
	# Handle Pray
	if ability["pray"] and !is_on_dialog and !is_dropping:
		if Input.is_action_just_pressed("pray") and is_praying == false and is_on_floor():
			is_praying = true
			can_move = false
			idle_anim = "praying"

		elif (Input.is_action_just_released("pray") and was_on_floor) or hit:
			is_praying = false
			idle_anim = "idle"
			heal_timer.stop()
			divine_voices.stop()
			
			if !hit:
				can_move = true

	# Add animation
	if (velocity.x > 1 or velocity.x < -1) and can_move:
		anim = "running"
	else:
		anim = idle_anim

	# Add the gravity.
	var ignore_platform = Input.is_action_pressed("drop")
	if not is_on_floor() or ignore_platform or is_dropping:
		velocity += get_gravity() * delta
	if not is_on_floor():
		anim = "jumping"

	# Plateform layer gestion
	if ignore_platform:
		collision_mask &= ~PLATFORM_MASK
	else:
		collision_mask |= PLATFORM_MASK  

	# Coyote Jump
	if is_on_floor():
		can_jump = true
		is_dropping = false
		coyote_timer.stop()
	elif can_jump and coyote_timer.is_stopped():
		coyote_timer.start()

	# Handle landed signal
	if is_on_floor() and not was_on_floor:
		landed.emit()
	was_on_floor = is_on_floor()

	if can_move:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and can_jump:
			velocity.y = JUMP_VELOCITY
			jump_audio.play()
			can_jump = false
			feet_on_platform = false

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
		if direction and !is_dropping:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if direction == 1.0:
			animated_sprite_2d.flip_h = false
		elif direction == -1.0:
			animated_sprite_2d.flip_h = true
	
	if !hit:
		animated_sprite_2d.play(anim)
	elif hit:
		animated_sprite_2d.play("hit")

# coyote jump timeout
func _on_timer_timeout() -> void:
	can_jump = false

func _on_feets_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Platformes" and not Input.is_action_pressed("drop"):
		feet_on_platform = true

func _on_feets_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Platformes":
		feet_on_platform = false

func _on_anim_finished():
	if idle_anim == "praying":
		idle_anim = "hold_praying"
		divine_voices.play()
		if !is_on_dialog:
			heal_timer.start()
	if hit:
		hit = false
		can_move = true
		invul_count = 0
		Engine.time_scale = 1.0
		invulnerability_timer.start()

func _on_heal_timer_timeout() -> void:
	heal.emit(2)

func _on_invulnerability_timer_timeout() -> void:
	invul_count += 1
	if invul_count == 7:
		invulnerability_timer.stop()
		invulnerability = false
		call_deferred("reset_collision")
	else:
		# Visual Effect of invulnerability
		if invul_count % 2:
			animated_sprite_2d.modulate.a = 0.25
		else:
			animated_sprite_2d.modulate.a = 1.0
	
		invulnerability_timer.start()

func reset_collision():
	collision_shape_2d.disabled = true
	collision_shape_2d.disabled = false
