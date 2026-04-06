extends RigidBody2D
@onready var label: Label = $Label
@onready var particle_label: Label = $SubViewport/ParticleLabel
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
var noma: Node2D
var main: Node2D
var audio_explosion: AudioStreamPlayer

signal player_hit

func _ready() -> void:
	main = get_node("/root/Main")
	noma = get_node("/root/Main/LevelRoot2/Noma")
	audio_explosion = get_node("/root/Main/Audio/Sounds/8bitExplosionAudio")
	self.player_hit.connect(main._on_noma_hit)
		
	var rand_numb = randi_range(1, 130)
	label.text = "%s" % rand_numb
	particle_label.text = "%s" % rand_numb
	
	collision_shape_2d.position = Vector2((str(rand_numb).length()*23.5), 46)
	
	var randx = [randi_range(50, 1200),noma.position.x,noma.position.x]
	
	position = Vector2(randx[randi_range(0, 2)],-30)

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	# particle explosion
	
	if body.name == "World":
		audio_explosion.play()
		gpu_particles_2d.emitting = true
		label.visible = false
		timer.start()
		call_deferred("disable_collision")
	elif body.name == "Noma":
		audio_explosion.pitch_scale = randf_range(0.6,1.0)
		audio_explosion.play()
		gpu_particles_2d.emitting = true
		label.visible = false
		timer.start()
		call_deferred("disable_collision")
		if body.invulnerability == false:
			body.invulnerability = true
			body.hit = true
			player_hit.emit(25)

func _on_timer_timeout() -> void:
	queue_free()

func disable_collision() -> void:
	collision_shape_2d.disabled = true
	
