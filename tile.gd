extends Sprite2D

class_name Tile

@export var stone_texture : Array[Texture2D]

var health : float
var max_health : float
var crack_level : int = 2
var cracks : AnimatedSprite2D

enum Ore {floor, none, coal, iron, copper, silver, gold, diamond}

var ore : Ore
	
func initialize (h : float, o : Ore) -> void:
	cracks = get_child(0)
	health = h
	max_health = h
	ore = o
	texture = stone_texture[ore]

		
func damage (d : float) -> bool:
	health -= d
	if health <= 0:
		texture = stone_texture[0]
		cracks.frame = 0
		return true
	elif health / max_health < 0.334:
		crack_level = 3
	elif health / max_health < 0.667:
		crack_level = 2
	else:
		crack_level = 1
		
	cracks.frame = crack_level
	return false
