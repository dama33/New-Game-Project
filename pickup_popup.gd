extends Control

var pickup_resource:PickupResource
@onready var label:Label = %Label

func _ready():
	pickup_resource = PickupResource.new()
	pickup_resource.changed.connect(_pickup_resource_changed)
	
func _pickup_resource_changed():
	label.text = pickup_resource.description
	label.visible = true
	$Timer.start()


func _on_timer_timeout() -> void:
	label.visible = false
	label.text = ""
