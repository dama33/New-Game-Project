extends TextureProgressBar

@onready var label = $Label
var steps: float
var continuous:bool

func _process(delta: float) -> void:
	if !continuous:
		label.text = str(int(steps))
	else:
		label.text = "Firing"
