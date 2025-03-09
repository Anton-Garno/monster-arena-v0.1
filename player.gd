extends CharacterBody3D
@onready var camera = $Camera3D
@onready var main_menu = $"../Menu/MainMenu"
@onready var pause_menu =$"../Menu/PauseMenu"
@onready var hud = $"../AmmoCount"
@onready var raycast = $Camera3D/RayCast3D
@onready var body = $CollisionShape3D

@export var ammo_count : int=4
@export var ammo_max : int = 30 
@export var fire_rate : float = 0.5 #chastota postriliv

#@onready var muzzle = $Muzzle
@onready var audio_player = $ShootSound
@export var player_healh: int = 1
#@export var player_armor= $

var can_shoot:bool = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const SPEED = 8.0
const JUMP_VELOCITY = 7
signal hit

func _ready():
	pass

func _unhandled_input(event):
	#if Input.is_action_just_pressed("run") :
	#	speed = run_speed
	#else:
	#	speed= walk_speed
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*.005)
		camera.rotate_x(-event.relative.y*.005)
		camera.rotation.x= clamp(camera.rotation.x, -PI/2, PI/2)
		
func _physics_process(delta) :
	check_collision()
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.and is_on_floor()
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
#shoot func==>

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		
func shoot():
	if ammo_count <=0:
		print("No Ammo")
		return
	ammo_count -=1
	print("Ammo:", ammo_count)
	update_hud()
	if audio_player:
		audio_player.play()
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot= true
	
	if raycast.is_colliding():
		var target  = raycast.get_collider()
		print("hit enemy")
		if  target.has_method("take_dmg"):
			target.take_dmg(1)
			print("-1hp enemy")
		
	
func add_ammo(amount:int):
	ammo_count =min(ammo_count + amount, ammo_max)
	print("Add Ammo")
	update_hud()
	
func update_hud():
	if hud:
		hud.update_ammo(ammo_count)
#change heals -> to armor while heals int= 1
func recive_dmg():
	player_healh-=1
	print("-1hp player")
	if player_healh<=0:
		player_healh
		print("palayer dead")
		position = Vector3.ZERO
		
func check_collision():
	var collision = move_and_collide(Vector3.ZERO)
	print("get collider")
	if collision:
		var body = collision.get_collider()
		if body.is_in_group("Enemy"):
			die()
			return
func die():
	get_tree().reload_current_scene()
		
