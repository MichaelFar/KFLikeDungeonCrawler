extends Node3D

class_name StealthManager

@export var player : Player
@export var light_detection : Node3D
@export var sub_viewport : SubViewport
@export var texture_rect : TextureRect
@export var color_rect : ColorRect
@export var light_level : TextureProgressBar

@export var stealthIcon : TextureRect

@export var eyeOpenTexture : Texture
@export var eyeClosedTexture : Texture

var isCrouching : bool = false

var isCreeping : bool = false

var stealthLevel : float = 0.0 :
	set(value):
		stealthLevel = clampf(value, 0.0, 1.0)
	get():
		return stealthLevel
#@export var texture
var updateLightRate : float = .1
var deltaCounter : float = 0
var lightTween : Tween

@onready var lightLevel : float = 0.0 :
	set(value):
		lightLevel = value
		var temp_light_level = lightLevel
		
		lightTween = get_tree().create_tween()
		
		lightTween.parallel().tween_property(stealthIcon, "modulate:a", lightLevel, .4)
		lightTween.finished.connect(light_tween_finished)
	get():
		return lightLevel

func _ready() -> void:
	sub_viewport.debug_draw = 2
	

func _physics_process(delta: float) -> void:
	deltaCounter += delta
	if(light_detection != null):
		
		light_detection.global_position = global_position # Make light detection follow the player
		
		if(deltaCounter > updateLightRate):
			
			deltaCounter = 0.0
			var texture = sub_viewport.get_texture() # Get the ViewportTexture from the SubViewport
			texture_rect.texture = texture # Display this texture on the TextureRect
			var color = get_average_color(texture) # Get the average color of the ViewportTexture
			#color_rect.color = color # Display the average color on the ColorRect
			light_level.value = color.get_luminance() # Use the average color's brighness as the light level value
			light_level.tint_progress.a = color.get_luminance() # Also tint the progress texture with the above
			lightLevel = color.get_luminance()
			
func get_average_color(texture: ViewportTexture) -> Color:
	
	var image = texture.get_image() # Get the Image of the input texture
	image.resize(1, 1, Image.INTERPOLATE_LANCZOS) # Resize the image to one pixel
	return image.get_pixel(0, 0) # Read the color of that pixel

func calculate_stealth_level(enemy_to_check : BaseEnemy, distance_limit : float) -> float:
	var detection_level : float = 0.0
	
	var distance_to_enemy = enemy_to_check.global_position.distance_to(global_position)
	
	var distance_coefficient : float = distance_limit / distance_to_enemy
	if(player.isMoving):
		
		if(isCreeping):
			detection_level += 0.40 * distance_coefficient
		else:
			detection_level += 0.80 * distance_coefficient
		if(!isCrouching):
			detection_level += .40 * distance_coefficient
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.head.global_position, enemy_to_check.global_position)
	var result = space_state.intersect_ray(query)
	
	#print(result.collider)
	if(result.collider is not BaseEnemy):
		#detected_level = 0.0
	
		detection_level += lightLevel
	
	return detection_level

func light_tween_finished():
	if(stealthIcon.modulate.a <= 0.1):
		stealthIcon.texture = eyeClosedTexture
	else:
		stealthIcon.texture = eyeOpenTexture
