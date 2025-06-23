extends Marker3D
class_name ShootingComponent

func shoot():
	var bullet = Global.bulletScene.instantiate()
	bullet.position = global_position
	bullet.transform.basis = global_transform.basis
	get_tree().root.add_child(bullet)
