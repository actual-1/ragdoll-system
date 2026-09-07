extends Node

@export var skeleton : Skeleton3D
@export var skeleton_physics_simulator : PhysicsSimulator 

func _ready() -> void:
	skeleton_physics_simulator.interaction_requested.connect(_begin_simulation)
	skeleton_physics_simulator.request_force_to_bone.connect(apply_force_to_bone)

func _begin_simulation():
	skeleton_physics_simulator.physical_bones_start_simulation()

func apply_force_to_bone(bone_idx: int, direction: Vector3, force : float):
	for bone : PhysicalBone3D in skeleton_physics_simulator.get_children():
		if bone.get_bone_id() == bone_idx:
			bone.apply_central_impulse(Vector3(direction.x * force, direction.y * force, direction.z * force))
