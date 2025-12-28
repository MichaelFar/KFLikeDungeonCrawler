extends AIStrategy

class_name PlayerDetectedAIStrategy

var animationPlayer : AnimationPlayer

var navAgent : NavigationAgent3D

var IdleTimer : Timer

var WanderTimer : Timer

var wanderRegion : WanderRegion

@export var speed : float

@export var animationDict = {
	"moving": "",
	"idling": "",
	"attacking" : ""
}

func populate_values(new_AI_data : InstanceAIData):
	pass
#Potentially, the strategy would be released by this string
#Allows for, say, charge attacks, or blocking as with original functionality
func execute_strategy(): 
	animationPlayer.play(animationDict["moving"])
	#set_process(true)
	WanderTimer.start()
	
	for i in navAgent.navigation_finished.get_connections():
		
		navAgent.navigation_finished.disconnect(i["callable"])
	
	navAgent.navigation_finished.connect(has_finished_executing.emit)
	
	print("In wander state")
	
func strategy_process(delta : float):
	pass
