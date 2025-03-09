extends Node3D
@export var ammo_amount: int = 4 

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("body in area3d")
	if body.is_in_group("Player"):  
		print("Player founded. start reload")
		#var gun = body.get_node("../Player")  
		if body.has_method("add_ammo"):
			body.add_ammo(ammo_amount)
			print("geted ammo")
			queue_free() 
		else:
			print("faile Player has not method add_ammo")
