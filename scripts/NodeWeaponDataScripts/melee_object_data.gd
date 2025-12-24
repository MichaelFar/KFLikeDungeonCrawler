extends BaseWeaponData

class_name MeleeObjectData

#This class handles the more hard code aspects of the strategy, it is not strictly necessary to have this if we are willing to inherit many different base melee weapons
#This class assumes all strategies utilize tweens and curves to operate animations
#This class is unnecessary if another animation method is used, but a similar system will be required to populate data
@export var blockRotationNode : Node3D
@export var weaponPivot : Node3D
@export var weaponPathFollow : PathFollow3D
@export var weaponOwner : BaseWeapon
@export var weaponPath3D : Path3D
@export var swingCoolDownTimer : Timer
@export var attackCurve : Resource
@export var hitbox : Area3D

var universalTween : Tween

func populate_values(melee_strategy : Strategy):
	
	var instance_melee_weapon_data := InstanceMeleeWeaponData.new(blockRotationNode, 
	weaponPivot, 
	weaponPathFollow, 
	weaponOwner, 
	weaponPath3D, 
	swingCoolDownTimer, 
	attackCurve, 
	hitbox)
	
	melee_strategy.populate_values(instance_melee_weapon_data)
	if(melee_strategy.has_signal("tween_changed")):
		melee_strategy.tween_changed.connect(strategy_tween_manager)

func strategy_tween_manager(new_tween : Tween):
	#print("Tween Changed")
	if(universalTween == null):
		universalTween = new_tween
	else:
		universalTween.kill()
		universalTween = new_tween

		
