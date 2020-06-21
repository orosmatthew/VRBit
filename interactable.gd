extends RigidBody


var grabbed = false
var grab_goal_node = null

var lin_vel = Vector3()
var ang_vel = Vector3()
var set_rigid_phys = false


func _integrate_forces(state):
	if set_rigid_phys == true:
		state.linear_velocity = lin_vel
		state.angular_velocity = ang_vel*50
		set_rigid_phys = false
	if grabbed == true:
		state.transform = grab_goal_node.global_transform
	

func _physics_process(delta):

	if grabbed == true:
		self.global_transform.origin = grab_goal_node.global_transform.origin
		self.global_transform.basis = grab_goal_node.global_transform.basis
		
