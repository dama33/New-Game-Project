extends CharacterBody3D

var aggro_target: Node
var ammo: int
var state: State
@export var health: int
@export var shooting_component: ShootingComponent
@export var hurtbox_component: HurtboxComponent
@export var enemy_attack_resource: EnemyAttackResource

enum State {
	IDLE,
	RELOADING,
	SHOOTING
}

func _ready() -> void:
	aggro_target = null
	ammo = enemy_attack_resource.ammo
	state = State.IDLE
	if ammo == 1:
		%ProgressBar.continuous = true
	%ProgressBar.steps = enemy_attack_resource.ammo
	%ProgressBar.value = 100
	%ReloadTimer.wait_time = enemy_attack_resource.reload_time
	%ShotTimer.wait_time = enemy_attack_resource.shot_time
	

func _process(delta: float) -> void:
	if(state == State.RELOADING && %ReloadTimer.is_stopped()):
		%ReloadTimer.start()
	if(state == State.RELOADING && !%ReloadTimer.is_stopped()):
		var calculated_value = (($ReloadTimer.wait_time-$ReloadTimer.time_left)/%ReloadTimer.wait_time)
		%ProgressBar.value = (calculated_value*100)
		%ProgressBar.steps = calculated_value*enemy_attack_resource.ammo
	if aggro_target != null:
		$Pivot.look_at(aggro_target.global_position)
		$CollisionShape3D.global_rotation = $Pivot.global_rotation
		if(state != State.RELOADING && %ShotTimer.is_stopped()):
			print("ammo left:" , ammo)
			shooting_component.shoot(false)
			%ProgressBar.value = ((100/enemy_attack_resource.ammo) * ammo)
			%ProgressBar.steps = ammo
			ammo-=1
			if ammo != 0:
				%ShotTimer.start()
			else:
				state = State.RELOADING
				

func _on_aggro_range_area_entered(area: Area3D) -> void:
	if area != hurtbox_component && area.collision_layer==1:
		aggro_target = area
		state = State.SHOOTING

func _on_aggro_range_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if has_node("%ProgressBar"):
		aggro_target = null
		ammo = enemy_attack_resource.ammo
		state = State.IDLE
		%ProgressBar.value = 100
		%ProgressBar.steps = ammo

func _on_reload_timer_timeout() -> void:
	ammo = enemy_attack_resource.ammo
	state = State.SHOOTING
