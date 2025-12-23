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



func execute_strategy():
	
	weaponPath3D.curve = attackCurve
	
	#canBlock = false
	
	if(!swingCoolDownTimer.is_stopped()):
		print("Timer exists aborting swing")
		return
	
	#weaponOwner.kill_global_tween()
	
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
