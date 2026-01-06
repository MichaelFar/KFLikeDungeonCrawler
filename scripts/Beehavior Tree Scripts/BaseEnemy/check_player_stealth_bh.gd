@tool

extends ConditionLeaf

@export var detectionThreshold : float = .45


@export var closeDetectionBeginDistance : float = 5.0

@export var lingeringSuspicionTime : float = 2.0

var timerIsRunning : bool = false


func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var enemy_actor : BaseEnemy = actor
	
	if(enemy_actor.player != null):
		var detected_level = enemy_actor.player.check_stealth(enemy_actor, closeDetectionBeginDistance)
		
		if(detected_level >= detectionThreshold):
			print("Player is suspicious")
			return SUCCESS
			
	return FAILURE
	
func _on_evil_mushroom_player_left_detection_zone() -> void:
	timerIsRunning = true
	var timer = get_tree().create_timer(lingeringSuspicionTime)
	timer.timeout.connect(set_timer_false)

func set_timer_false():
	timerIsRunning = false
