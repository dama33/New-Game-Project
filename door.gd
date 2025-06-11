extends Node3D

var activated:bool
var starting_rotation:float
var ending_rotation:float

func _ready() -> void:
	starting_rotation = rotation.y
	ending_rotation = rotation.y - deg_to_rad(90)

func _on_button_button_activated() -> void:
	activated = !activated

func _process(delta: float) -> void:
	if(activated):
		rotation.y = lerp(rotation.y, ending_rotation,.05)
	else:
		rotation.y = lerp(rotation.y, starting_rotation, .05)
