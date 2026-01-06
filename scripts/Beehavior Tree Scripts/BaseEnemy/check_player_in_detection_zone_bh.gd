@tool

extends ConditionLeaf

@export var lingeringSuspicionTime : float = 2.0

var timerIsRunning : bool = false

func tick(actor: Node, blackboard: Blackboard) -> int:
	
	
	if(timerIsRunning):
		return SUCCESS
	
	if(actor is not BaseEnemy):
		
		return FAILURE
	
	elif(actor is BaseEnemy):
		
		if(actor.playerInDetectionZone):

			return SUCCESS
	
	return FAILURE


func _on_evil_mushroom_player_left_detection_zone() -> void:
	timerIsRunning = true
	var timer = get_tree().create_timer(lingeringSuspicionTime)
	timer.timeout.connect(set_timer_false)

func set_timer_false():
	timerIsRunning = false
