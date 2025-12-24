extends InstanceWeaponData

class_name InstanceMeleeWeaponData

var blockRotationNode : Node3D
var weaponPivot : Node3D
var weaponPathFollow : PathFollow3D
var weaponOwner : BaseWeapon
var weaponPath3D : Path3D
var swingCoolDownTimer : Timer
var attackCurve : Resource
var hitbox : Area3D

func _init(block_rotation_node, weapon_pivot, weapon_path_follow, weapon_owner, weapon_path_3D, swing_cooldown_timer, attack_curve, hit_box) -> void:
	
	blockRotationNode = block_rotation_node
	weaponPivot = weapon_pivot
	weaponPathFollow = weapon_path_follow
	weaponOwner = weapon_owner
	weaponPath3D = weapon_path_3D
	swingCoolDownTimer = swing_cooldown_timer
	attackCurve = attack_curve
	hitbox = hit_box
