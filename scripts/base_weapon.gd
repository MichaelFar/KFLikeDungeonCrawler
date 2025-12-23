extends Node3D

class_name BaseWeapon

@export var primaryStrategy : Strategy

@export var secondaryStrategy : Strategy

@export var weaponObjectData: BaseWeaponData
#These values are used for weapon sway
@export_range(0.0 ,1.0, 0.01) var yWeaponSway : float
@export_range(0.0 ,1.0, 0.01) var xWeaponSway : float
@export_range(0.0 ,1.0, 0.01) var yWeaponSwayPosition : float
@export_range(0.0 ,1.0, 0.01) var xWeaponSwayPosition : float
@export_range(0.0 ,100, 0.01) var yWeaponRotation : float
@export_range(0.0 ,100, 0.01) var xWeaponRotation : float
@export_range(0.0 ,1.0, 0.01) var yWeaponRotationPosition : float
@export_range(0.0 ,1.0, 0.01) var xWeaponRotationPosition : float
@export var swayMin := Vector2(-20,-20)
@export var swayMax := Vector2(20,20)

var weaponState : WeaponStates

enum WeaponStates {PRIMARY, SECONDARY, RESTING}

#Primary state: Primary action strategy state, changes to resting when done
#Secondary state: Same as primary, returns to resting when done
#Resting: Default state and one that is always returned to

func _ready() -> void:
	#we assume that all strategies want to be populated with object data
	#if they don't need to be, the strategy itself will handle that
	weaponObjectData.populate_values(primaryStrategy)
	
func activate_primary_strategy():
	
	weaponState = WeaponStates.PRIMARY
	primaryStrategy.execute_strategy()

func activate_secondary_strategy():
	
	weaponState = WeaponStates.SECONDARY
	secondaryStrategy.execute_strategy()

func return_weapon():
	pass
