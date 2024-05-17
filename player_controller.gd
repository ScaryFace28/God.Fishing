extends RigidBody3D

# Variables for controlling the boat movement
var acceleration = 10.0
var max_speed = 20.0
var deceleration = 5.0
var rotation_speed = 1.0
var gravity = -9.8

func _integrate_forces(_state):
	# Get input from the player
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.z = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	
	# Normalize input vector to prevent faster diagonal movement
	input_vector = input_vector.normalized()

	# Apply forces based on input
	if input_vector.length() > 0:
		var force = transform.basis.z * input_vector.z * acceleration
		apply_central_force(force)
	else:
		# Apply deceleration when no input is provided
		if linear_velocity.length() > 0:
			var decel_force = -linear_velocity.normalized() * deceleration
			apply_central_force(decel_force)
			if linear_velocity.length() < 0.1:
				linear_velocity = Vector3.ZERO

	# Apply torque for rotation
	if input_vector.x != 0:
		var torque = Vector3.UP * -input_vector.x * rotation_speed
		apply_torque_impulse(torque)
