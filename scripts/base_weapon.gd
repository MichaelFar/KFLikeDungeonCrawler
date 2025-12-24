extends Node3D

class_name BaseWeapon

@export var primaryStrategy : Strategy #Happens on left click

@export var secondaryStrategy : Strategy #Happens on right click

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

enum WeaponStates {PRIMARY, SECONDARY}

#Primary state: Primary action strategy state, changes to resting when done
#Secondary state: Same as primary, returns to resting when done

var weaponState : WeaponStates :
	
		get:
			
			return weaponState
			
		set(value):
			
			
			weaponState = value
			
			#for i in hitBox.get_children():
				#
				#i.disabled = true
			#
			#match value :
				#
				#WeaponStates.ATTACKING:
					#trailMesh.trailEnabled = true
					#for i in hitBox.get_children():
						#i.disabled = false
				#WeaponStates.RESTING:
					#if(trailMesh.trailEnabled):
						#trailMesh.tweenFromWidthToZero()

func _ready() -> void:
	#we assume that all strategies want to be populated with object data
	#if they don't need to be, the strategy itself will handle that
	weaponObjectData.populate_values(primaryStrategy)
	weaponObjectData.populate_values(secondaryStrategy)
	
func _physics_process(delta: float) -> void:
	
	primaryStrategy.strategy_process(delta)
	secondaryStrategy.strategy_process(delta)
	
func activate_primary_strategy(release_string : String):
	
	weaponState = WeaponStates.PRIMARY
	primaryStrategy.execute_strategy(release_string)

func activate_secondary_strategy(release_string : String):
	
	weaponState = WeaponStates.SECONDARY
	secondaryStrategy.execute_strategy(release_string)
