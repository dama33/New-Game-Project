extends CharacterBody3D
@export var speed = 400
@export var first_person_camera:Camera3D
@export var level_camera:Camera3D
@export var mouse_sensitivity = .005
@export var pivot:Node3D
@export var bulletSpawner: Marker3D

var bulletScene = preload("res://bullet.tscn")

var is_first_person:bool
var is_foreground_view:bool
var inputDirection = Vector3.ZERO
var mouse_pos

func _ready() -> void:
	level_camera.current = true
	is_first_person = false
	is_foreground_view = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	if is_first_person:
		inputDirection.z = 0
	velocity.z = inputDirection.z * speed * delta
	move_and_slide()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_camera"):
		if is_first_person:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			level_camera.current = true
			is_first_person = false;
			rotation = Vector3.ZERO
			pivot.rotation = Vector3.ZERO
			#needs work, needs to update to previous looked direction
			Input.warp_mouse(mouse_pos)
		else:
			first_person_camera.current = true
			is_first_person = true
			rotation = pivot.rotation
			pivot.rotation = Vector3.ZERO
			mouse_pos = get_viewport().get_mouse_position()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("change_side_view"):
		if !is_first_person:
			is_foreground_view = !is_foreground_view
			%LevelCamera.position.x *= -1
			%LevelCamera.rotation.y *= -1
			
				
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func _input(event: InputEvent) -> void:
	if is_first_person:
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
			var result = space_state.intersect_ray(query)
			pivot.look_at(Vector3(0,result.position.y,result.position.z), Vector3.UP)
			
		if !is_foreground_view:	
			inputDirection.z = Input.get_axis("right", "left")
		else:
			inputDirection.z = Input.get_axis("left", "right")
			
func shoot():
	#This shit does NOT work
	var bullet = bulletScene.instantiate()
	bullet.position = bulletSpawner.global_position
	bullet.transform.basis = bulletSpawner.global_transform.basis
	get_tree().root.add_child(bullet)
		
