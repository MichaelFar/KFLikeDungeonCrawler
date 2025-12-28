extends Strategy #extends resource

class_name MeleeSwingStrategy


@export_range(0.0, 100.0) var zAngleSwingLimit : float
@export_range(0.0, 100.0) var yAngleSwingLimit : float

@export var swingCooldown : float
@export var swingSpeed : float

var blockRotationNode : Node3D
var weaponPivot : Node3D
var weaponPathFollow : PathFollow3D
var weaponOwner : BaseWeapon
var weaponPath3D : Path3D
var swingCoolDownTimer : Timer
var attackCurve : Resource
var hitbox : Area3D
var globalTween : Tween:
	set(value):
		globalTween = value
		tween_changed.emit(value)
	get():
		return globalTween

var isResting : bool = false
var releaseInputString : String

signal tween_changed

func populate_values(new_weapon_data : InstanceWeaponData):
	if(new_weapon_data is InstanceMeleeWeaponData):
		blockRotationNode = new_weapon_data.blockRotationNode
		weaponPivot = new_weapon_data.weaponPivot
		weaponPathFollow = new_weapon_data.weaponPathFollow
		weaponOwner = new_weapon_data.weaponOwner
		weaponPath3D = new_weapon_data.weaponPath3D
		swingCoolDownTimer = new_weapon_data.swingCoolDownTimer
		attackCurve = new_weapon_data.attackCurve
		hitbox = new_weapon_data.hitbox
		swingCoolDownTimer.wait_time = swingCooldown
		

func strategy_process(delta : float):
	
	canBeInterrupted = swingCoolDownTimer.is_stopped()

func execute_strategy(release_string : String):
	
	if(!swingCoolDownTimer.is_stopped()):
		print("Timer exists aborting swing")
		return
	
	isResting = false
	
	swingCoolDownTimer.start()
	var randObj = RandomNumberGenerator.new()
	
	var minRangeZ := zAngleSwingLimit * -1.0
	var maxRangeZ := zAngleSwingLimit
	var minRangeY := yAngleSwingLimit * -1.0
	var maxRangeY := yAngleSwingLimit
	
	var randomAngleZ = randObj.randf_range(minRangeZ, maxRangeZ)
	var randomAngleY = randObj.randf_range(minRangeY, maxRangeY)
	
	weaponPathFollow.progress_ratio = 0.0
	blockRotationNode.rotation_degrees.y = 0.0
	blockRotationNode.rotation_degrees.x = 0.0
	weaponPivot.rotation_degrees.y = randomAngleY
	weaponPivot.rotation_degrees.z = randomAngleZ
	
	var tween = weaponOwner.get_tree().create_tween()
	globalTween = tween
	
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(weaponPathFollow, "progress_ratio", 1.0, swingSpeed)
	tween.finished.connect(return_weapon)

func return_weapon():
	#weaponState = WeaponStates.RESTING
	isResting = true
	
	var tween = weaponOwner.get_tree().create_tween()
	globalTween = tween
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:y",0, 1.4)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:z",0, 1.4)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:y", 0.0, 1.4)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:x", 0, 1.4)
	tween.parallel().tween_property(weaponPathFollow, "progress_ratio", 0.0, 1.4)
