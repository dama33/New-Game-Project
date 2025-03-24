extends Node3D
class_name HurtboxComponent

@export var health_component:HealthComponent

func get_hit(attack: Attack):
	if health_component:
		health_component.damage(attack)

func _on_area_entered(area: Area3D) -> void:
	print("ok")
	if area is Bullet:
		print("ok2")
		var bullet: Bullet = area
		get_hit(bullet.attack)
