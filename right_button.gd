extends Button

var main : Main
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent().get_parent().get_parent()
	pressed.connect(_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _button_pressed () -> void:
	main.increase_level()
