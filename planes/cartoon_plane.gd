extends CharacterBody3D

# Can't fly below this speed
var min_flight_speed = 12
# Maximum airspeed
var max_flight_speed = 40
# Turn rate
var turn_speed = 0.75
# Climb/dive rate
var pitch_speed = 0.5
# Wings "autolevel" speed
var level_speed = 3.0
# Throttle change speed
var throttle_delta = 50
# Acceleration/deceleration
var acceleration = 6.0

# Current speed
var forward_speed = 0
# Throttle input speed
var target_speed = 0
# Lets us change behavior when grounded
var grounded = false

var turn_input = 0
var pitch_input = 0

var tracer_scene = preload("res://tracer.tscn")
var can_shoot = true

@onready var mesh = $cartoon_plane

func _ready():
	$cartoon_plane/AnimationPlayer.play("prop_spin")
	
func get_input(delta):
	# Throttle input
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
	if Input.is_action_pressed("throttle_down"):
		var limit = 0 if grounded else min_flight_speed
		target_speed = max(forward_speed - throttle_delta * delta, limit)

	# Turn (roll/yaw) input
	turn_input = Input.get_axis("roll_right", "roll_left")
	if forward_speed <= 0.5:
		turn_input = 0
	
	# Pitch (climb/dive) input
	pitch_input = 0
	if not grounded:
		pitch_input -= Input.get_action_strength("pitch_down")
	if forward_speed >= min_flight_speed:
		pitch_input += Input.get_action_strength("pitch_up")
#	pitch_input =  Input.get_axis("pitch_down", "pitch_up")
	
	# shooting
	if Input.is_action_pressed("click") and can_shoot:
		can_shoot = false
		$GunCooldown.start()
		shoot()
		
func _physics_process(delta):
	get_input(delta)
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)
	
	# Bank when turning
	if grounded:
		mesh.rotation.z = 0
	else:
		mesh.rotation.z = lerpf(mesh.rotation.z, -turn_input, level_speed * delta)
	
	# Accelerate/decelerate
	forward_speed = lerpf(forward_speed, target_speed, acceleration * delta)
	
	# Movement is always forward
	velocity = -transform.basis.z * forward_speed
	
	# Landing
	if is_on_floor():
		if not grounded:
			rotation.x = 0
#		velocity.y -= 1
		grounded = true
	else:
		grounded = false
	move_and_slide()
	
func shoot():
	for n in [$LeftGun, $RightGun]:
		var t = tracer_scene.instantiate()
		get_tree().current_scene.add_child(t)
		t.start(n.global_transform, forward_speed)
		if n.is_colliding():
			print("hit, ", n.get_collider().name)

func _on_gun_cooldown_timeout():
	can_shoot = true
