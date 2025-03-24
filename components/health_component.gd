extends Node3D
class_name HealthComponent

@export var MAX_HEALTH: int = 5
var health: int

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	print("took damage")
	health-= attack.damage
	if health<=0:
		print("dead")
		get_parent().queue_free()
