@tool

extends ActionLeaf

class_name ChoosePatrolPointActionLeaf

var hasChosenPoint : bool = false

var enemyActor : BaseEnemy

var isIdling : bool = false

@export var timeToIdle : float = 3.0

@export var patrolToPointAction : ActionLeaf
signal reached_end_of_patrol_route
signal movement_status_change

func _ready() -> void:
	#reached_end_of_patrol_route.connect(patrolToPointAction.set_should_not_move)
	movement_status_change.connect(patrolToPointAction.set_should_not_move)
func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var enemy_actor : BaseEnemy = actor
	enemyActor = enemy_actor
	if(!isIdling):
		if(!hasChosenPoint):
			
			print("Choosing new point")
			
			enemy_actor.choose_patrol_point()
			
			enemy_actor.animationPlayer.play(enemy_actor.animationDict["moving"])
			enemy_actor.increment_point_index()
			hasChosenPoint = true
			
		elif(enemy_actor.animationPlayer.current_animation != enemy_actor.animationDict["moving"]):
			
			hasChosenPoint = false
		
	return FAILURE

func _on_navigation_agent_3d_target_reached() -> void:
	print("Reached target")
	
	if(enemyActor.allBakedPoints[enemyActor.currentPathPointIndex] 
	== enemyActor.allBakedPoints[enemyActor.allBakedPoints.size() - 1]
	|| enemyActor.allBakedPoints[enemyActor.currentPathPointIndex]
	== enemyActor.allBakedPoints[0]):
		
		isIdling = true
		var timer = get_tree().create_timer(timeToIdle)
		timer.timeout.connect(timer_time_out)
		movement_status_change.emit()
		enemyActor.animationPlayer.play("RESET")
		enemyActor.animationPlayer.play(enemyActor.animationDict["idling"])
		reached_end_of_patrol_route.emit()
		print("Reached end of patrol route, index is " + str(enemyActor.currentPathPointIndex))
	
	hasChosenPoint = false

func timer_time_out():
	movement_status_change.emit()
	isIdling = false
