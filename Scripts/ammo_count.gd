extends Control 
var ammo_count: int = 4

@onready var ammo_label = $AmmoLabel

func  _ready() -> void:
	update_ammo(ammo_count)
	
func update_ammo(ammo_count:int):
	ammo_label.text = "Ammo: "+str(ammo_count)
