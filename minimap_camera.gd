extends Camera3D
@export var player:CharacterBody3D


func _ready():
	global_position.z = player.global_position.z


func _process(_delta:float):
	global_position.x = player.global_position.x
	global_position.z = player.global_position.z
