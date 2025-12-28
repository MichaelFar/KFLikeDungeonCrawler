@tool
class_name Trail3D extends MeshInstance3D

enum InterpolationMode {
	LINEAR,
	SQUARE,
	CUBE,
	QUAD
}
enum InterpolationDirection {
	FORWARD,
	BACKWARD
}

var points: Array[Vector3]  = []
var widths: Array  = []
var lifePoints: Array[float] = []

@export var trailEnabled: bool = true :
	
	get:
		
		return trailEnabled
	
	set(value):
		
		if(value):
			
			fromWidth = initialFromWidth
			
			if(shrinkTween != null):
				
				shrinkTween.kill()

@export var fromWidth: float = 0.5
@export var toWidth: float = 0.0
@export_range(0.5, 3.0) var scaleAcceleration: float  = 1.0

@export var motionDelta: float = 0.1
@export var lifespan: float = 1.0

@export var scaleTexture: bool = true
@export var startColor: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var endColor: Color = Color(1.0, 1.0, 1.0, 0.0)


@export var colorInterpolationMode: InterpolationMode = InterpolationMode.LINEAR
@export var interpolationDirection: InterpolationDirection = InterpolationDirection.FORWARD

@export var trailMaterial : ShaderMaterial

var oldPos: Vector3

var initialFromWidth : float

var shrinkTween : Tween

func _ready() -> void:
	oldPos = global_position
	mesh = ImmediateMesh.new()
	initialFromWidth = fromWidth

func _physics_process(delta: float) -> void:
	motionDelta = delta
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP, trailMaterial)
	
	if (oldPos - global_position).length() > motionDelta and trailEnabled:
		appendPoint()
		oldPos = global_position
	
	var p: int = 0
	var max_points: int = points.size()
	while p < max_points:
		lifePoints[p] += delta
		if lifePoints[p] > lifespan:
			removePoint(p)
			p -= 1
			if (p < 0): 
				p = 0
				
		max_points = points.size()
		p += 1

	if points.size() < 2:
		return

	for i in range(points.size()):
		
		var t: float = float(i) / (points.size() - 1.0)

		var currWidth: Vector3 = widths[i][0] - pow(1-t, scaleAcceleration) * widths[i][1]

		if scaleTexture:
			var t0: float = motionDelta * i
			var t1: float = motionDelta * (i + 1)
			mesh.surface_set_uv(Vector2(t0, 0))
			mesh.surface_add_vertex(to_local(points[i] + currWidth))
			mesh.surface_set_uv(Vector2(t1, 1))
			mesh.surface_add_vertex(to_local(points[i] - currWidth))
		else:
			var t0: float = i / float(points.size())
			var t1: float = t

			mesh.surface_set_uv(Vector2(t0, 0))
			mesh.surface_add_vertex(to_local(points[i] + currWidth))
			mesh.surface_set_uv(Vector2(t1, 1))
			mesh.surface_add_vertex(to_local(points[i] - currWidth))
	mesh.surface_end()

func appendPoint() -> void:
	#var direction: Vector3 = global_position - oldPos
	#direction = direction.normalized()
	#
	basis = basis.orthonormalized()
	points.append(global_position)
	widths.append([
		global_basis.x * fromWidth,
		global_basis.x * fromWidth - global_basis.x * toWidth
	])
	lifePoints.append(0.0)

func removePoint(i: int) -> void:
	points.remove_at(i)
	widths.remove_at(i)
	lifePoints.remove_at(i)

func tweenFromWidthToZero():
	
	var tween = get_tree().create_tween()
	
	tween.parallel().tween_property(self, "fromWidth", 0.0, 0.1)
	
	tween.finished.connect(setTrailEnabled.bind(false))
	
	shrinkTween = tween

func setTrailEnabled(new_value : bool):
	trailEnabled = new_value
