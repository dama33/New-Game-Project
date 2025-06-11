extends Area3D
class_name HurtboxComponent

@export var health_component:HealthComponent
signal got_hit

func get_hit(attack: Attack):
	print("got hit")
	if health_component:
		health_component.damage(attack)
	got_hit.emit()

func _on_area_entered(area: Area3D) -> void:
	print("ok")
	if area is Bullet:
		print("ok2")
		var bullet: Bullet = area
		get_hit(bullet.attack)
