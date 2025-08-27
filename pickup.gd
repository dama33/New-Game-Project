extends Node3D
class_name Pickup

@export var pickup_resource: PickupResource

func _on_pickup_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		SignalBus.pickup_acquired.emit(pickup_resource)
		queue_free()
