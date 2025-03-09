extends CharacterBody3D

@onready var path_timer= $PathUpdateTimer
@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../Player"
@export var mob_speed: float = 6
@export var healh_mob: int = 2 

#later need create an random healh

func _ready() -> void:
	nav_agent.path_desired_distance = 0.5#vidstan do tochki shlyahu
	nav_agent.target_desired_distance = 1.0# min vidstan do gravca
	set_target(player.global_transform.origin)#set player as Ziel
	
	path_timer.timeout.connect(set_target)#use timer like frame to update position
	path_timer.start(0.1)
func _physics_process(delta: float) -> void:
	if player:#use frames like timer
		nav_agent.set_target_position(player.global_transform.origin)
		follow_path(delta)
	
func set_target(target_position:Vector3):
	nav_agent.set_target_position(target_position)
	#nav_agent.force_update()
	print("next target pos ", nav_agent.get_next_path_position())
func follow_path(delta):
	#print("next target pos ", nav_agent.get_next_path_position())
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_transform.origin).normalized()
	velocity = direction* mob_speed
	move_and_slide()
	if nav_agent.is_navigation_finished():
		return
	
func make_dmg():
	pass
func take_dmg(dmg:int):
	healh_mob-= dmg
	print("-1hp mob")
	if healh_mob<=0:
		die()
		print("mob dead")
func die():
	print("enemy dead")
	queue_free()
