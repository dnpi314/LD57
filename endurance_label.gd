extends Label

var main : Main
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Endurance: " + str(main.player_endurance)
