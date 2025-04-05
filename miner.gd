extends Sprite2D

class_name Miner

var damage : float
var energy : float
var mining_energy : float
var walking_energy : float = 0.2

func set_stats (d : float, e : float, me : float) -> void:
	damage = d
	energy = e
	mining_energy = me

func action (type : int) -> bool:
	if type == 0:
		energy -= walking_energy
	elif type == 1:
		energy -= mining_energy
	
	if energy <= 0:
		return true
	else:
		return false
