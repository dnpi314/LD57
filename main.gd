extends Node2D

class_name Main

@export var mine_scene : PackedScene
@export var victory_scene : PackedScene

var main_panel : Panel

var upgrade_button_s : Button
var upgrade_button_e : Button
var upgrade_button_l : Button

var mine : Mine

var money : float = 0
var player_damage : float = 1
var player_energy : float = 20
var player_mining_energy_drain : float = 1
var player_luck : float = 1
var player_endurance = 1

var player_strength_cost = 3
var player_endurance_cost = 5
var player_luck_cost = 10

var current_energy = 10
var current_level = 1

var max_mine_level = 1

var iron_availability = 2
var copper_availability = 3
var silver_availability = 5
var gold_availability = 8
var diamond_availability = 13
var victory_depth = 20

var welcome_text = "Find the treasures hidden below!"

func upgrade_strength () -> void:
	money -= player_strength_cost
	player_strength_cost += 3
	player_damage += 1
	if player_damage == 1200:
		player_strength_cost = "MAX"

func upgrade_endurance () -> void:
	money -= player_endurance_cost
	player_endurance_cost += 5
	player_endurance += 1
	player_energy = player_endurance * 20
	current_energy = player_energy
	
func upgrade_luck () -> void:
	money -= player_luck_cost
	player_luck_cost += 10
	player_luck += 1
	if player_luck == 100:
		player_luck_cost = "MAX"
	
func decrease_level () -> void:
	if current_level == 1:
		return
	current_level -= 1

func increase_level () -> void:
	if current_level == max_mine_level:
		return
	current_level += 1

func die () -> void:
	mine.queue_free()
	upgrade_button_e.disabled = false
	upgrade_button_s.disabled = false
	upgrade_button_l.disabled = false
	current_energy = player_energy
	welcome_text = "You have run out of energy."
	main_panel.show()
	
func clear () -> void:
	mine.queue_free()
	if current_level == victory_depth:
		win()
		return
	upgrade_button_e.disabled = false
	upgrade_button_s.disabled = false
	upgrade_button_l.disabled = false
	current_energy = player_energy
	welcome_text = "You have cleared this depth!"
	max_mine_level += 1
	current_level += 1
	main_panel.show()

func win () -> void:
	var instance = victory_scene.instantiate()
	add_child(instance)

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
	var value = level
	var ore_chance = 0.1 * sqrt(player_luck)
	
	mine = mine_scene.instantiate()
	add_child(mine)
	mine.create_mine(ore_chance, ore_level, durability, value)
	mine.set_player_stats(player_damage, player_energy, player_mining_energy_drain)
	
	main_panel = get_node("Camera2D/Panel")
	
	upgrade_button_e = get_node("Panel/UpgradeE")
	upgrade_button_s = get_node("Panel/UpgradeS")
	upgrade_button_l = get_node("Panel/UpgradeL")
	
	upgrade_button_e.disabled = true
	upgrade_button_s.disabled = true
	upgrade_button_l.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mine != null:
		current_energy = mine.player.energy
