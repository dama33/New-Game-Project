extends Area3D
class_name Bullet
var speed = 20
var attack = Attack.new(1)


func _physics_process(delta: float):
	position += transform.basis * Vector3(0,0, -speed) * delta


func _on_timer_timeout():
	queue_free()
