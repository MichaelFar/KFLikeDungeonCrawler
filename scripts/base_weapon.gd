extends Node3D

class_name BaseWeapon

@export_range(0.0 ,1.0, 0.01) var yWeaponSway : float
@export_range(0.0 ,1.0, 0.01) var xWeaponSway : float
@export_range(0.0 ,1.0, 0.01) var yWeaponSwayPosition : float
@export_range(0.0 ,1.0, 0.01) var xWeaponSwayPosition : float
@export_range(0.0 ,100, 0.01) var yWeaponRotation : float
@export_range(0.0 ,100, 0.01) var xWeaponRotation : float
@export_range(0.0 ,1.0, 0.01) var yWeaponRotationPosition : float
@export_range(0.0 ,1.0, 0.01) var xWeaponRotationPosition : float
@export_range(0.0, 100.0) var zAngleSwingLimit : float

@export_range(0.0, 100.0) var yAngleSwingLimit : float

@export var swayMin := Vector2(-20,-20)
@export var swayMax := Vector2(20,20)

@export_range(0.0, 1.0, 0.01) var swingSpeed : float

@export var swingCooldown : float

@export var weaponMesh : MeshInstance3D
@export var weaponPivot : Node3D
@export var weaponPathFollow : PathFollow3D
@export var swingCoolDownTimer : Timer
@export var weaponPath3D : Path3D

@export var blockRotationNode : Node3D

@export var attackCurve : Resource
@export var blockCurve : Resource

var globalTween : Tween

var canBlock : bool = true

var canReleaseBlock : bool = false

enum WeaponStates {ATTACKING, BLOCKING, RESTING}#Not really a state machine, will be checked by weapon holder

var weaponState : WeaponStates = WeaponStates.RESTING

func _ready() -> void:
	swingCoolDownTimer.wait_time = swingCooldown

func swing_weapon():
	
	weaponState = WeaponStates.ATTACKING
	
	weaponPath3D.curve = attackCurve
	
	canBlock = false
	
	if(!swingCoolDownTimer.is_stopped()):
		print("Timer exists aborting swing")
		return
	
	if(globalTween != null):
		
		if(globalTween.is_running()):
			
			globalTween.kill()
			
			weaponPathFollow.progress_ratio = 0.0
	
	swingCoolDownTimer.start()
	var randObj = RandomNumberGenerator.new()
	
	var minRangeZ := zAngleSwingLimit * -1.0
	var maxRangeZ := zAngleSwingLimit
	var minRangeY := yAngleSwingLimit * -1.0
	var maxRangeY := yAngleSwingLimit
	
	
	var randomAngleZ = randObj.randf_range(minRangeZ, maxRangeZ)
	var randomAngleY = randObj.randf_range(minRangeY, maxRangeY)
	#print(str(randomAngle))
	weaponPathFollow.progress_ratio = 0.0
	blockRotationNode.rotation_degrees.y = 0.0
	blockRotationNode.rotation_degrees.x = 0.0
	weaponPivot.rotation_degrees.y = randomAngleY
	weaponPivot.rotation_degrees.z = randomAngleZ
	
	var tween = get_tree().create_tween()
	globalTween = tween
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(weaponPathFollow, "progress_ratio", 1.0, swingSpeed)
	tween.finished.connect(return_weapon)

func return_weapon():
	
	canBlock = true
	
	if(globalTween != null):
		
		if(globalTween.is_running()):
			
			globalTween.kill()
			
			if(weaponState != WeaponStates.BLOCKING):
				weaponPathFollow.progress_ratio = 0.0
		
	var tween = get_tree().create_tween()
	globalTween = tween
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:y",0, 1.4)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:z",0, 1.4)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:y", 0.0, 1.4)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:x", 0, 1.4)
	tween.parallel().tween_property(weaponPathFollow, "progress_ratio", 0.0, 1.4)
	#tween.finished.connect(set_can_block.bind(true))
	
func block_with_weapon():
	
	weaponState = WeaponStates.BLOCKING
	
	canReleaseBlock = false
	
	if(!swingCoolDownTimer.is_stopped() || !canBlock):
		
		print("Timer exists aborting swing")
		return 
		
	if(globalTween != null):
		
		if(globalTween.is_running()):
			
			globalTween.kill()
			
	var tween = get_tree().create_tween()
	globalTween = tween
	
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:y",0, swingSpeed)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:z",0, swingSpeed)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:x", -45, swingSpeed)
	tween.parallel().tween_property(blockRotationNode, "rotation_degrees:y", 90.0, swingSpeed)
	tween.parallel().tween_property(weaponPathFollow, "progress_ratio", 0.0, swingSpeed)
	tween.finished.connect(set_can_release.bind(true))
	
func set_can_release(new_value : bool):
	
	canReleaseBlock = new_value
