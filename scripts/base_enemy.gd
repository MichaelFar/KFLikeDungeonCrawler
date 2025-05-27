extends Node3D

class_name BaseEnemy

@export var animationPlayer : AnimationPlayer

@export var navAgent : NavigationAgent3D

@export var animationDict = {
	"moving": "",
	"idling": "",
	"attacking" : ""
}


enum EnemyStates {WANDERING, IDLING, PURSUING, ATTACKING}

func _ready() -> void:
	
	animationPlayer.play(animationDict["idling"])
