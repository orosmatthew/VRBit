extends ARVRController

var Hand
var grab_obj = null
var grabbing = false
var velocity = Vector3()
var ang_velocity = Vector3()
var prev_angle = Quat()
var cur_angle = Quat()
var grab_p = "light"
var cs
var prev_cs_pos = Vector3()
var grab_profiles = {"light":[3000,2000,0.125,0.1],
					 "medium":[2500,1000,0.1,0.05],
					 "heavy":[1500,500,0.07,0.02]}

func _ready():
	if self.get_name() == "ARVRControllerLeft":
		Hand = get_tree().get_root().get_node("Game/ARVROrigin/LHand")
	else:
		Hand = get_tree().get_root().get_node("Game/ARVROrigin/RHand")

func _process(delta):
	Hand.get_node("AnimationPlayer").play("default")
	Hand.get_node("AnimationPlayer").seek(get_joystick_axis(2)*10.6,true)



func _physics_process(delta):
	
	var push = 0.05
	var speed = 3000
	
	
	var vel = (get_node("HandPos").global_transform.origin-Hand.global_transform.origin).normalized()*(get_node("HandPos").global_transform.origin.distance_to(Hand.global_transform.origin))
	if grabbing == true:
		if vel.y<0:
			vel.y*=grab_profiles[grab_p][0]
		else:
			vel.y*=grab_profiles[grab_p][1]
		vel.x*=grab_profiles[grab_p][0]
		vel.z*=grab_profiles[grab_p][0]
	else:
		vel.y*=speed
		vel.x*=speed
		vel.z*=speed
	vel*=delta
	

	velocity = Hand.move_and_slide(vel,Vector3(),false,4,PI/4)

	cur_angle = Hand.global_transform.basis.get_rotation_quat()
	ang_velocity = (cur_angle*prev_angle.inverse()).get_euler()
	prev_angle = cur_angle
	
	var rspeed = 0.4
	
	if grabbing == true:
		if grab_obj.global_transform.origin.y-Hand.get_node("GrabGoal").global_transform.origin.y<0:
			rspeed = grab_profiles[grab_p][3]
		else:
			rspeed = grab_profiles[grab_p][2]
	
	var quat_half = cur_angle.slerp(get_node("HandPos").global_transform.basis.get_rotation_quat(),rspeed)
	
	Hand.global_transform.basis = Basis(quat_half)
	
	"""
	for index in Hand.get_slide_count():
		var collision = Hand.get_slide_collision(index)
		if collision.collider.get_parent().is_in_group("interactable"):
			var force = -collision.normal * push * pow(((get_node("HandPos").global_transform.origin - Hand.global_transform.origin).length()+1),0.2) * pow((velocity.length()+1),0.65)
			collision.collider.get_parent().get_node("RigidBody").apply_impulse(collision.position - collision.collider.global_transform.origin, force)
	"""
	

func button_pressed(button):
	if button == 15 and grabbing == false:
		if len(Hand.bodies) != 0:
			for b in Hand.bodies:
				if b.is_in_group("interactable"):
					b.grab_goal_node = Hand.get_node("GrabGoal")
					b.grabbed = true
					grab_obj = b
					grabbing = true
					grab_p = b.grab_profile[0]
					cs = b.get_node("CollisionShape")
					prev_cs_pos = cs.transform
					var cur_cs_pos = cs.global_transform
					b.remove_child(cs)
					Hand.add_child(cs)
					cs.set_owner(Hand)
					cs.global_transform = cur_cs_pos
					b.gravity_scale = 0
					Hand.get_node("GrabGoal").global_transform.origin = b.global_transform.origin
					Hand.get_node("GrabGoal").global_transform.basis = b.global_transform.basis
					break



func button_release(button):
	if button == 15 and grabbing == true:
		grab_obj.grabbed = false
		grab_obj.grab_goal_node = null
		grab_obj.lin_vel = velocity
		grab_obj.ang_vel = ang_velocity
		grab_obj.set_rigid_phys = true
		grab_obj.gravity_scale = 1

		Hand.remove_child(cs)
		grab_obj.add_child(cs)
		cs.set_owner(grab_obj)
		cs.set_name("CollisionShape")
		cs.transform = prev_cs_pos
		
		grabbing = false

