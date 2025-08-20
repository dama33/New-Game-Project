extends Marker3D
class_name ShootingComponent

var bullet: Bullet

func shoot(is_player:bool):
	bullet = Global.bullet_scene.instantiate()
	if(is_player):
		bullet.set_collision_layer_value(3, true)
	else:
		bullet.set_collision_layer_value(2, true)
	bullet.position = global_position
	bullet.transform.basis = global_transform.basis
	get_tree().root.add_child(bullet)
