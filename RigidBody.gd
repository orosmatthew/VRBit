extends RigidBody



func _ready():
	pass


func _physics_process(delta):
	get_parent().get_node("StaticBody").global_transform.origin = self.global_transform.origin
	get_parent().get_node("StaticBody").global_transform.basis = self.global_transform.basis
