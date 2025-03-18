extends Node3D
var velocity
var speed = 30

func _physics_process(delta: float) -> void:
	
	position += transform.basis * Vector3(0,0, -speed) * delta


func _on_timer_timeout() -> void:
	queue_free()
