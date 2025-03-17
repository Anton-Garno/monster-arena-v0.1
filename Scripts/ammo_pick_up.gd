extends Node3D
@export var ammo_amount: int = 4 

func _on_area_3d_body_entered(body: Node3D) -> void:#create a signal of func for ammo pickup
	print("body in area3d")
	if body.is_in_group("Player"):  #we have group with Player (Node->Group:Enemy or Player)
		print("Player founded. start reload")
		#var gun = body.get_node("../Player")  
		if body.has_method("add_ammo"):#in our code of Player we have an func add_ammo this is for he
			body.add_ammo(ammo_amount)
			print("geted ammo")#checker for ammo
			queue_free() 
		else:
			print("faile Player has not method add_ammo")#too checker
