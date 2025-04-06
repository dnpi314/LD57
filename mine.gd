extends Node2D

class_name Mine

@export var size_x : int = 9
@export var size_y : int = 9
@export var tile_scene : PackedScene

var main : Main

var tile_size = 32
var player_position : Vector2 = Vector2(4, 4)
var player : Miner
var tiles : Array[Tile]
var tiles_mined = 0
var target_tiles_mined = 80

var ore_chance : float
var ore_level : int
var base_health : float
var money_multiplier : float

var ore_values = [0, 1, 5, 15, 25, 50, 80, 200]

func set_player_stats (d : float, e : float, me : float) -> void:
	player.set_stats(d, e, me)
	
func create_mine (chance : float, ores : int, durability : float, value : float) -> void:
	ore_chance = chance
	ore_level = ores
	base_health = durability
	money_multiplier = value
	
	tiles.resize(size_x * size_y)
	
	for x in range(size_x):
		for y in range(size_y):
			var index = y * size_x + x
			var ore_roll = randf_range(0, 1)
			var ore_type = 1
			if ore_roll < ore_chance:
				ore_type = randi_range(1, ore_level) + 1
			var tile : Tile = tile_scene.instantiate()
			add_child(tile)
			tile.transform.origin = Vector2(x * tile_size, y * tile_size)
			tile.initialize(base_health, ore_type)
			tiles[index] = tile
	
	tiles[player_position.y * size_x + player_position.x].initialize(0, 0)
	
func check_tile (t : int) -> bool:
	if tiles[t].health <= 0:
		return true
	else:
		return false
		
func get_tile_in_direction (dir: int) -> int:
	var position = get_position_in_direction(dir)
	var x = position.x
	var y = position.y
	if x < 0 || x >= size_x || y < 0 || y >= size_y:
		return -1
	else:
		return y * size_x + x
		
func get_position_in_direction (dir : int) -> Vector2:
	var x
	var y
	match dir:
		0:
			x = player_position.x
			y = player_position.y - 1
		1:
			x = player_position.x + 1
			y = player_position.y
		2:
			x = player_position.x
			y = player_position.y + 1
		3:
			x = player_position.x - 1
			y = player_position.y
	return Vector2(x,y)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_child(0)
	main = get_parent()

func _unhandled_key_input(event: InputEvent) -> void:
	
	var direction = -1
	
	if event.is_action("up") && !event.is_action_released("up"):
		direction = 0
	if event.is_action("right") && !event.is_action_released("right"):
		direction = 1
	if event.is_action("down") && !event.is_action_released("down"):
		direction = 2
	if event.is_action("left") && !event.is_action_released("left"):
		direction = 3
		
	if direction == -1:
		return
	
	var tile_index = get_tile_in_direction(direction)
	if tile_index == -1:
		return
	if check_tile(tile_index):
		player_position = get_position_in_direction(direction)
		player.transform.origin = player_position * tile_size
		if player.action(0, main.current_level):
			main.die()
	else:
		if tiles[tile_index].damage(player.damage):
			var money = ore_values[tiles[tile_index].ore] * money_multiplier
			main.money += money
			tiles_mined += 1
			if tiles_mined == target_tiles_mined:
				main.clear()
				return
		if player.action(1, main.current_level):
			main.die()
