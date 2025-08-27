extends CharacterBody3D
var speed = 400
@export var first_person_camera:Camera3D
@export var level_camera:Camera3D
@export var mouse_sensitivity = .005
@export var pivot:Node3D
@export var shooting_component: ShootingComponent

var is_foreground_view:bool
var inputDirection = Vector3.ZERO
var mouse_pos
var final_position_x:float
var final_rotation_y:float
var camera_position
var camera_rotation
var gravity = -20
var jump_velocity = 10
var result
var state: State

enum State {
	FIRST_PERSON,
	THIRD_PERSON
}

func _ready() -> void:
	SignalBus.pickup_acquired.connect(_pickup_acquired)
	level_camera.current = true
	is_foreground_view = false
	state = State.THIRD_PERSON
	final_position_x = %LevelCamera.position.x
	final_rotation_y = %LevelCamera.rotation.y
	camera_position = %LevelCamera.position
	camera_rotation = %LevelCamera.rotation
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	if state == State.FIRST_PERSON:
		inputDirection.z = 0
	velocity.z = inputDirection.z * speed * delta
	#this has to be fixed
	if position.x < 0 || position.x > 0:
		position.x = 0
		
	if !is_on_floor():
		velocity.y += gravity*delta
	elif state == State.THIRD_PERSON && Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	move_and_slide()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shooting_component.shoot(true)
	
	if Input.is_action_just_pressed("change_camera"):
		if state == State.FIRST_PERSON:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			level_camera.current = true
			state = State.THIRD_PERSON
			rotation = Vector3.ZERO
			pivot.rotation = Vector3.ZERO
			#needs work, needs to update to previous looked direction
			Input.warp_mouse(mouse_pos)
		else:
			state = State.FIRST_PERSON
			#This is causing the issue with the jarring camera start
			pivot.rotation = Vector3.ZERO
			mouse_pos = get_viewport().get_mouse_position()
			look_at(Vector3(0,position.y,result.position.z))
			pivot.look_at(Vector3(0,result.position.y,result.position.z),Vector3.UP)
			
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			first_person_camera.current = true
	if Input.is_action_just_pressed("change_side_view"):
		if state == State.THIRD_PERSON:
			is_foreground_view = !is_foreground_view
			%CameraPosition.position.x *= -1
			%CameraPosition.rotation.y *= -1
	#Swooshing camera remnants
	#if is_first_person:
		#if abs(%LevelCamera.position.x-%FirstPersonCamera.position.x) > 0.001 && abs(%LevelCamera.rotation.y-%FirstPersonCamera.rotation.y) > 0.001:
			#%LevelCamera.global_position = %LevelCamera.global_position.lerp(%FirstPersonCamera.global_position,.1)
			#%LevelCamera.rotation = %LevelCamera.rotation.lerp(%FirstPersonCamera.rotation,.1)
		#else:
			#first_person_camera.current = true
	#else:
		#if abs(float(final_position_x-%LevelCamera.position.x)) > 0.001 && abs(float(final_rotation_y-%LevelCamera.rotation.y)) > 0.001:
			#%LevelCamera.position.x = lerp(%LevelCamera.position.x,final_position_x,.1)
			##TODO remove this, try to work with vector lerping
			#%LevelCamera.position.y = lerp(%LevelCamera.position.y,camera_position.y,.1)
			#%LevelCamera.rotation.y = lerp(%LevelCamera.rotation.y,final_rotation_y,.1)
					
func _input(event: InputEvent) -> void:
	#Remnant from when we had swooshing camera
	#if !((is_first_person && !first_person_camera.current) || (!is_first_person && first_person_camera.current)):
	if state == State.FIRST_PERSON && first_person_camera.current:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			pivot.rotate_x(-event.relative.y * mouse_sensitivity)
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	else:
		if event is InputEventMouseMotion:
			var space_state = get_world_3d().direct_space_state
			var mousepos = get_viewport().get_mouse_position()
			var origin = %LevelCamera.project_ray_origin(mousepos)
			var end = origin + %LevelCamera.project_ray_normal(mousepos) * 1000
			var query = PhysicsRayQueryParameters3D.create(origin, end)
			query.collide_with_areas = true
			result = space_state.intersect_ray(query)
			if(result.size()!=0):
				pivot.look_at(Vector3(0,result.position.y,result.position.z), Vector3.UP)
			
		if !is_foreground_view:	
			inputDirection.z = Input.get_axis("right", "left")
		else:
			inputDirection.z = Input.get_axis("left", "right")

func _pickup_acquired(pickup_resource: PickupResource):
	print(pickup_resource.id)
	print(PickupResource.Pickup.keys()[pickup_resource.name])
