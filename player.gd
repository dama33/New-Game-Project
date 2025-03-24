extends CharacterBody3D
@export var speed = 400
@export var first_person_camera:Camera3D
@export var level_camera:Camera3D
@export var mouse_sensitivity = .005
@export var pivot:Node3D
@export var bulletSpawner: Marker3D

var bulletScene = preload("res://bullet.tscn")

var is_first_person:bool
var inputDirection = Vector3.ZERO

func _ready() -> void:
	level_camera.current = true
	is_first_person = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if is_first_person:
		inputDirection.z = 0
	velocity.z = inputDirection.z * speed * delta
	move_and_slide()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_camera"):
		if is_first_person:
			level_camera.current = true
			is_first_person = false;
			rotation = Vector3.ZERO
			pivot.rotation = Vector3.ZERO
		else:
			first_person_camera.current = true
			is_first_person = true
	if Input.is_action_just_pressed("change_mouse_mode"):
			if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func _input(event: InputEvent) -> void:
	if is_first_person:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			pivot.rotate_x(-event.relative.y * mouse_sensitivity)
	else:
		inputDirection.z = Input.get_axis("right", "left")
	
	
			
func shoot():
	#This shit does NOT work
	var bullet = bulletScene.instantiate()
	bullet.position = bulletSpawner.global_position
	bullet.transform.basis = bulletSpawner.global_transform.basis
	get_tree().root.add_child(bullet)
		
