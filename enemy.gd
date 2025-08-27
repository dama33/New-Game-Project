extends CharacterBody3D

var aggro_target: Node
var shot_count: int
var state: State
@export var health: int
@export var shooting_component: ShootingComponent
@export var hurtbox_component: HurtboxComponent
@export var ammo: int
@export var shot_time: float
@export var reload_time: float

enum State {
	IDLE,
	RELOADING,
	SHOOTING
}

func _ready() -> void:
	aggro_target = null
	shot_count = 0
	state = State.IDLE
	%ReloadTimer.wait_time = reload_time
	%ShotTimer.wait_time = shot_time
	

func _process(delta: float) -> void:
	if(state == State.RELOADING && %ReloadTimer.is_stopped()):
		%ReloadTimer.start()
	if aggro_target != null:
		$Pivot.look_at(aggro_target.global_position)
		$CollisionShape3D.global_rotation = $Pivot.global_rotation
		if(state != State.RELOADING && %ShotTimer.is_stopped()):
			print("shot count:" , shot_count)
			shooting_component.shoot(false)
			%ShotTimer.start()

func _on_aggro_range_area_entered(area: Area3D) -> void:
	if area != hurtbox_component && area.collision_layer==1:
		aggro_target = area
		state = State.SHOOTING

func _on_aggro_range_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	aggro_target = null
	shot_count = 0
	state = State.IDLE


func _on_reload_timer_timeout() -> void:
	shot_count = 0
	state = State.SHOOTING


func _on_shot_timer_timeout() -> void:
	if(shot_count >= ammo):
		state = State.RELOADING
	else: 
		shot_count+=1
