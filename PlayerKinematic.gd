extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var GRAVITY = 5
var FRICTION = 0.9
var velocity = Vector3()
var delta_move = Vector3()
var prev_pos = Vector3()
var cur_pos = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	
	
	velocity.x *= FRICTION
	velocity.z *= FRICTION
	
	if is_on_floor() == false:
		velocity.y -= 5
	
	prev_pos = cur_pos
	velocity = move_and_slide(velocity)
	cur_pos = global_transform.origin
	
	delta_move = cur_pos-prev_pos
	
