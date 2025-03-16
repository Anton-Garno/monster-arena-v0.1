extends CharacterBody3D
@onready var camera = $Camera3D
@onready var main_menu = $"../Menu/MainMenu"
@onready var pause_menu =$"../Menu/PauseMenu"
@onready var hud = $"../AmmoCount"
@onready var raycast = $Camera3D/RayCast3D

@onready var body = $CollisionShape3D
@onready var hit_box = $HitBox
@onready var shot_anim =$Camera3D/shotgun/AnimationPlayer
@onready var bullets_holes= preload("res://bullets_holes.tscn") 

@export var ammo_count : int=4
@export var ammo_max : int = 30 
@export var fire_rate : float = 1 #chastota postriliv

#@onready var muzzle = $Muzzle
@onready var audio_player = $ShootSound
@export var player_healh: int = 1
@export var speed = 10
@export var jump_velocity = 8
@export var player_armor= 4

var can_shoot:bool = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_reloading = false

signal hit

func _ready():
	hit_box.body_entered.connect(_on_hit_box_body_entered)
	
func _on_hit_box_body_entered(body: Node3D) -> void:
	#print("in Player collision")
	if body.is_in_group("Enemy"):
		die()
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
	#if Input.is_action_pressed("shoot"):
		#var b = bullets_holes.instantiate()
		#raycast.get_collider().add_child(b)
		#b.global_transform.origin = raycast.get_collision_point()
		#b.look_at(raycast.get_collision_point()+raycast.get_collision_normal(),Vector3.UP)
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.and is_on_floor()
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	
#shoot func==>

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
	if Input.is_action_pressed("reload"):
		reload()
func shoot():
	if ammo_count <=0:
		print("No Ammo")
		return
	ammo_count -=1
	print("Ammo:", ammo_count)
	update_hud()
	
			#shot_anim.queue("reload barAction", "reload_gun", "reloaderAction")
	if audio_player:#need to create an sound of shot
		audio_player.play()
	
	can_shoot = false
	shot_anim.play("shot")
	shot_anim.queue("reloaderAction")
	await get_tree().create_timer(fire_rate).timeout
	
	can_shoot= true
	
	if raycast.is_colliding():
		var target  = raycast.get_collider()
		print("hit enemy")
		if  target.has_method("take_dmg"):
			target.take_dmg(1)
			print("-1hp enemy")
		
func reload():
	if is_reloading or ammo_count == ammo_max:
		return
	is_reloading = true
	can_shoot = false
	
	shot_anim.play("reload_gun")
	#shot_anim.play("reloaderAction")
	
	var reload_time = shot_anim.current_animation_length
	await get_tree().create_timer(reload_time).timeout
	
	#ammo_count = ammo_max
	print("reloaded!")
	is_reloading = false
	can_shoot= true
	
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
		print("player dead")
		position = Vector3.ZERO
		
func die():
	print("Player Dead")
	get_tree().reload_current_scene()
		
