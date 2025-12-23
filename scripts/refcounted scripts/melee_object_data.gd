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

func populate_values(melee_strategy : Strategy):
	if(melee_strategy is MeleeSwingStrategy):
		
		var verified_melee_strategy : MeleeSwingStrategy = melee_strategy
		
		verified_melee_strategy.blockRotationNode = blockRotationNode
		verified_melee_strategy.weaponPivot = weaponPivot
		verified_melee_strategy.weaponPathFollow = weaponPathFollow
		verified_melee_strategy.weaponOwner = weaponOwner
		verified_melee_strategy.weaponPath3D = weaponPath3D
		verified_melee_strategy.swingCoolDownTimer = swingCoolDownTimer
		
		verified_melee_strategy.attackCurve = attackCurve
