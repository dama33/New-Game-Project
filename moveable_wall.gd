extends StaticBody3D
var final_position: float
var activated: bool
var starting_position: float
@export var ending_marker: Marker3D

func _ready():
	activated = false
	starting_position = 0
	final_position = ending_marker.position.x
	
func _process(delta: float) -> void:
	if activated:
		position.x = lerp(position.x, final_position,.1)
		#if abs(position.x-final_position) < .0001:
			#activated = false
	else:
		position.x = lerp(position.x, starting_position,.1)
	
func _on_button_button_activated() -> void:
	activated = !activated
