extends Strategy

class_name MeleeBlockStrategy

@export var blockSpeed : float

var blockRotationNode : Node3D
var weaponPivot : Node3D
var weaponPathFollow : PathFollow3D
var weaponOwner : BaseWeapon
var weaponPath3D : Path3D
var swingCoolDownTimer : Timer
var attackCurve : Resource
var hitbox : Area3D
var globalTween : Tween :
	set(value):
		globalTween = value
		tween_changed.emit(value)
	get():
		return globalTween

var isResting : bool = false
var isBlocking : bool = false

var releaseInputString : String = " "

signal tween_changed

func populate_values(new_weapon_data : InstanceWeaponData):
	
	if(new_weapon_data is InstanceMeleeWeaponData):
		blockRotationNode = new_weapon_data.blockRotationNode
		weaponPivot = new_weapon_data.weaponPivot
		weaponPathFollow = new_weapon_data.weaponPathFollow
		weaponOwner = new_weapon_data.weaponOwner
		weaponPath3D = new_weapon_data.weaponPath3D
		swingCoolDownTimer = new_weapon_data.swingCoolDownTimer
		#attackCurve = new_weapon_data.attackCurve
		hitbox = new_weapon_data.hitbox
		canBeInterrupted = true

func strategy_process(delta : float):
	
	if(Input.is_action_just_released(releaseInputString)):
		return_weapon()

func execute_strategy(release_string : String):
	releaseInputString = release_string
	if(!swingCoolDownTimer.is_stopped() || !canBeInitiated):
		
		print("Timer exists aborting swing")
		return 
		
	#kill_global_tween()
	
	isResting = false
	
	var tween = weaponOwner.get_tree().create_tween()
	globalTween = tween
	
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:y",0, blockSpeed)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:z",0, blockSpeed)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:x", -60, blockSpeed)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:y", 90.0, blockSpeed)
	tween.parallel().tween_property(weaponPathFollow, "progress_ratio", 0.0, blockSpeed)
	
	
func return_weapon():
	#weaponState = WeaponStates.RESTING
	isResting = true
	#kill_global_tween()
	
	var tween = weaponOwner.get_tree().create_tween()
	globalTween = tween
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:y",0, 1.4)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:z",0, 1.4)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:y", 0.0, 1.4)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:x", 0, 1.4)
	tween.parallel().tween_property(weaponPathFollow, "progress_ratio", 0.0, 1.4)
	
func kill_global_tween():
	
	pass
	#if(isResting):
		#
		#if(!isBlocking):
			#
			#weaponPathFollow.progress_ratio = 0.0
