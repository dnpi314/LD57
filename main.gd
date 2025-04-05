extends Node2D

class_name Main

@export var mine_scene : PackedScene

var mine : Mine

var money : float = 0
var player_damage : float = 1
var player_energy : float = 10
var player_mining_energy_drain : float = 1
var player_luck : float = 1

var current_energy
var current_level = 1

var max_mine_level = 1

var iron_availability = 2
var copper_availability = 3
var silver_availability = 5
var gold_availability = 8
var diamond_availability = 13
var victory_depth = 20

func die () -> void:
	mine.queue_free()
	current_energy = player_energy
	
	
func start (level : int) -> void:
	
	var ore_level = 1
	
	if level >= diamond_availability:
		ore_level = 6
	elif level >= gold_availability:
		ore_level = 5
	elif level >= silver_availability:
		ore_level = 4
	elif level >= copper_availability:
		ore_level = 3
	elif level >= iron_availability:
		ore_level = 2
		
	var durability = 3 * pow(level, 2)
	var value = pow(level, 1.5)
	var ore_chance = 0.1 * sqrt(player_luck)
	
	mine = mine_scene.instantiate()
	add_child(mine)
	mine.create_mine(ore_chance, ore_level, durability, value)
	mine.set_player_stats(player_damage, player_energy, player_mining_energy_drain)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mine != null:
		current_energy = mine.player.energy
