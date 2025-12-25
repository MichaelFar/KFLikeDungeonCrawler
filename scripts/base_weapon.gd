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

@export var idealLocalStartingPosition : Vector3

#In order to maintain strategy pattern, there are important aspects that must remain true
#1. Strategies do not care when they were invoked, it is the duty of the calling class to utilize this
#2. Strategies do not know about anything else except for critical references, such as objects that the strategies will animate
#3. This base weapon class does not care about how these strategies behave

func _ready() -> void:
	#we assume that all strategies want to be populated with object data
	#if they don't need to be, the strategy itself will handle that
	position = idealLocalStartingPosition
	weaponObjectData.populate_values(primaryStrategy)
	
	weaponObjectData.populate_values(secondaryStrategy)
	
func _physics_process(delta: float) -> void:
	
	primaryStrategy.strategy_process(delta)
	secondaryStrategy.strategy_process(delta)
	
func activate_primary_strategy(release_string : String):
	
	if(secondaryStrategy.canBeInterrupted):
		
		primaryStrategy.execute_strategy(release_string)

func activate_secondary_strategy(release_string : String):
	
	if(primaryStrategy.canBeInterrupted):
		
		secondaryStrategy.execute_strategy(release_string)
