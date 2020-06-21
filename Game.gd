extends Spatial




func _ready():
	var VR = ARVRServer.find_interface("OpenVR")
	
	ARVRServer.world_scale = 10
	
	
	if VR and VR.initialize():
		get_viewport().arvr = true

		OS.vsync_enabled = false
		Engine.iterations_per_second = 90
		


