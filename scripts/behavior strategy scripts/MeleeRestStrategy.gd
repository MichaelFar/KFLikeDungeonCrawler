extends Strategy

class_name MeleeRestStrategy

var blockRotationNode : Node3D
var weaponPivot : Node3D
var weaponPathFollow : PathFollow3D
var weaponOwner : BaseWeapon
var weaponPath3D : Path3D

var globalTween : Tween

func populate_values(new_weapon_data : InstanceWeaponData):
	
	if(new_weapon_data is InstanceMeleeWeaponData):
		blockRotationNode = new_weapon_data.blockRotationNode
		weaponPivot = new_weapon_data.weaponPivot
		weaponPathFollow = new_weapon_data.weaponPathFollow
		weaponOwner = new_weapon_data.weaponOwner
		weaponPath3D = new_weapon_data.weaponPath3D
		
		#attackCurve = new_weapon_data.attackCurve
		
		canBeInterrupted = true

func execute_strategy(release_input_string : String):
	#isResting = true
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
