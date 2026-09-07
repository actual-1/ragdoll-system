extends CharacterBody3D

@export var YAW : Node3D
@export var PITCH : Node3D
@export var camera : Camera3D
@export var interaction_ray : RayCast3D

@export_range(0.0, 10000.0, 0.5) var punch_force : float = 10000.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("reload_scene"):
		get_tree().reload_current_scene()
	
	if event is InputEventMouseMotion:
		YAW.rotation.y -= event.relative.x * 0.005
		PITCH.rotation.x -= event.relative.y * 0.005
	
	if Input.is_action_just_pressed("MWU"):
		punch_force += 0.5
	elif Input.is_action_just_pressed("MWD"):
		punch_force -= 0.5
	
	if Input.is_action_just_pressed("LMB"):
		if interaction_ray.is_colliding():
			var Node_parent = interaction_ray.get_collider().get_parent()
			if Node_parent is PhysicsSimulator:
				Node_parent.interaction_requested.emit()
				var direction = interaction_ray.get_collision_normal() * -1
				Node_parent.request_force_to_bone.emit(interaction_ray.get_collider().get_bone_id(),direction, punch_force*5)
		else:
			pass

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("Space"):
		position.y += 0.1
	elif Input.is_action_pressed("crouch"):
		position.y -= 0.1
	
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x*5
		velocity.z = direction.z*5
	else:
		velocity.x = 0
		velocity.z = 0
		velocity.y = 0
	move_and_slide()
