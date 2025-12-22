extends Node3D

class_name BaseWeapon

@export var primaryStrategy : Strategy

@export var alternateStrategy : Strategy

@export var weaponObjectData: BaseWeaponData

func _ready() -> void:
	pass
	#var melee_data : MeleeSwingData = MeleeSwingData.new()
	#melee_data.attackCurve = attackCurve
	#melee_data.blockRotationNode = blockRotationNode
	#melee_data.swingCoolDownTimer = swingCoolDownTimer
	#melee_data.weaponOwner = self
	#melee_data.weaponPath3D
	#melee_data.weaponPathFollow
	#melee_data.weaponPivot
