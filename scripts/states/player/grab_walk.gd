extends PlayerState

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "GrabWalk"

# private virtual, expected to be overridden by the inherited state
# logic to accept a transition is written here
func _confirm_transition() -> void:
	pass

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _enter() -> void:
	super._enter()
	pass

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _exit() -> void:
	pass

# private virtual, intended to be implemented in one of these methods
# called from the state machine logic
# _unhandled_input(ev : InputEvent)
# _input(ev : InputEvent)
# _input_event(ev : InputEvent)
func _input(event: InputEvent) -> void:
	pass

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _process(delta : float)
func _process(delta : float) -> void:
	pass

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _physics_process(delta : float)
func _physics_process(delta : float) -> void:
	var velocity : Vector2 = player.velocity

		 #Handle jump.
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		velocity.y = player.JUMP_VELOCITY

	 #Get the input direction and handle the movement/deceleration.
	 #As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * player.SPEED
		#if(stamina>0 and is_on_floor()):
			#velocity.x*= (2.0/(player.stamina*5))
		player.sprite.scale.x = sign(direction)
		
		#if(player.is_on_floor() and (player.stamina == 0 or player.animator.current_animation.begins_with("Air"))):
			#if(player.animator.current_animation.begins_with("Air")):
				#player.stamina_reset.stop()
				#stamina_reset.timeout.emit()
		player.animator.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, player.SPEED*0.1)
		if(is_zero_approx(velocity.length()) and player.stamina == 0 and player.is_on_floor()):
			print("changing to idle from grabwalk")

			transition_to(player.state_idle)
	player.velocity = velocity
	player.move_and_slide()
	pass

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _integrate_forces(state)

# in Godot v3, state is of type Physics2DDirectBodyState
# in Godot v4, state is of type PhysicsDirectBodyState2D
# to avoid problems between versions, it is changed to Object
func _integrate_forces(state: Object) -> void:
	pass

# public
# special methods, to detect whether it is a state or a state machine
func is_class_state_machine() -> bool:
	return false

# public
# special methods, to detect whether it is a state or a state machine
func is_class_state() -> bool:
	return true
