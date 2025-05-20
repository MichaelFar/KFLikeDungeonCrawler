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
@export_range(0.0, 30.0) var zAngleSwingLimit : float

@export var swayMin := Vector2(-20,-20)
@export var swayMax := Vector2(20,20)

@export var weaponMesh : MeshInstance3D
@export var weaponPivot : Node3D
@export var weaponPathFollow : PathFollow3D

var globalTween : Tween

func swing_weapon():
	
	if(globalTween != null):
		
		if(globalTween.is_running()):
			
			globalTween.kill()
			
			weaponPathFollow.progress_ratio = 0.0
			
	var randObj = RandomNumberGenerator.new()
	
	var minRange := zAngleSwingLimit * -1.0
	var maxRange := zAngleSwingLimit
	
	var randomAngle = randObj.randf_range(minRange, maxRange)
	print(str(randomAngle))
	weaponPathFollow.progress_ratio = 0.0
	weaponPivot.rotation_degrees.y = randomAngle
	weaponPivot.rotation_degrees.z = randomAngle
	var tween = get_tree().create_tween()
	globalTween = tween
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(weaponPathFollow, "progress_ratio", 1.0, .25)
	tween.finished.connect(return_weapon)

func return_weapon():
	
	if(globalTween != null):
		
		if(globalTween.is_running()):
			
			globalTween.kill()
			
			weaponPathFollow.progress_ratio = 0.0
		
	var tween = get_tree().create_tween()
	globalTween = tween
	#tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:y",0, 1.4)
	tween.parallel().tween_property(weaponPivot, "rotation_degrees:z",0, 1.4)
	
	tween.parallel().tween_property(weaponPathFollow, "progress_ratio", 0.0, 1.4)
