extends ARVROrigin


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move(vect):
	get_parent().get_node("PlayerKinematic").velocity.x += vect.x
	get_parent().get_node("PlayerKinematic").velocity.z += vect.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().get_node("PlayerKinematic").global_transform.basis = Basis(Vector3(0,get_node("ARVRCamera").get_global_transform().basis.get_euler().y,0))
	#global_transform.origin = get_parent().get_node("PlayerKinematic/OriginLoc").global_transform.origin
	#get_parent().get_node("PlayerKinematic").velocity.x+=(get_node("ARVRCamera").global_transform.origin.x-get_parent().get_node("PlayerKinematic").global_transform.origin.x)
	#get_parent().get_node("PlayerKinematic").velocity.z+=(get_node("ARVRCamera").global_transform.origin.z-get_parent().get_node("PlayerKinematic").global_transform.origin.z)
