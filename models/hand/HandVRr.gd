extends KinematicBody

var bodies = []



"""
extends RigidBody

var bodies = []
var lin_vel = Vector3()
var ang_vel = Vector3()


func _integrate_forces(state):

	state.linear_velocity = lin_vel
	state.angular_velocity = ang_vel
	
"""

func _on_GrabArea_body_entered(body):
	if not body in bodies:
		bodies.append(body)


func _on_GrabArea_body_exited(body):
	if body in bodies:
		bodies.erase(body)

