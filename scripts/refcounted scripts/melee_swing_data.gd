extends BaseWeaponData
#This is not intended to be set in editor, programatically create this
class_name MeleeObjectData
	
@export var blockRotationNode : Node3D
@export var weaponPivot : Node3D
@export var weaponPathFollow : PathFollow3D
@export var weaponOwner : BaseWeapon
@export var weaponPath3D : Path3D
@export var swingCoolDownTimer : Timer
@export var attackCurve : Resource
