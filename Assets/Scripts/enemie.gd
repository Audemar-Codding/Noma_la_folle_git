extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var ledge_ray: RayCast2D = $LedgeRay
@onready var wall_ray: RayCast2D = $WallRay
@onready var love_audio: AudioStreamPlayer = $LoveAudio

@export var dmg: float = 20.0
@export var direction: float = -1.0
@export var speed: float = 225.0
var can_move := true

var was_on_ledge := true
var was_on_wall := true

var idle_anim: String = "idle-bad"

signal player_hit

func _ready() -> void:
	animated_sprite_2d.sprite_frames.set_animation_speed("moving", (speed/225.0 * 10.0))
	if direction == -1.0:
		animated_sprite_2d.flip_h = true
		flip_enemie()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Noma":
		if body.invulnerability == false:
			body.invulnerability = true
			body.hit = true
			player_hit.emit(dmg)
		elif body.is_flashing == true:
			can_move = false
			idle_anim = "idle"
			love_audio.play()
			call_deferred("disable_colision")

func _process(delta: float) -> void:

	var on_ledge = ledge_ray.is_colliding()
	if was_on_ledge and !on_ledge:
		flip_enemie()
	was_on_ledge = on_ledge
	
	var wall_hit = wall_ray.is_colliding()
	if wall_hit and !was_on_wall:
		flip_enemie()
	was_on_wall = wall_hit
	
	if can_move:
		position.x += direction * speed * delta
		animated_sprite_2d.play("moving")
	else:
		animated_sprite_2d.play(idle_anim)

func flip_enemie() -> void:
	direction *= -1.0
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	ledge_ray.position.x *= -1 
	wall_ray.position.x *= -1
	wall_ray.rotation = (20.0+(180.0*direction))

func disable_colision() -> void:
	collision_shape_2d.disabled = true
