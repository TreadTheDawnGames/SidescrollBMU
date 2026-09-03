extends PlayerState


# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "AttackGround"

# private virtual, expected to be overridden by the inherited state
# logic to accept a transition is written here
func _confirm_transition() -> void:
	pass

var exited : bool = true

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _enter() -> void:
	exited = false
	super._enter()
	player.animator.play("Attack" + str(player.stamina%4))
	player._handle_stamina(1)
	player.stamina_reset.start()
	
	player.velocity.x = 1000 * sign(player.sprite.scale.x)
	
	await player.stamina_reset.timeout

	if not exited:
		transition_to(player.state_idle)
	
	pass

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _exit() -> void:
	player.stamina_reset.stop()
	exited = true
	player.hurtbox_shape.set_deferred("disabled", true)
	
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
	
	player.handle_gravity(delta)
	
	if Input.is_action_just_pressed("Dodge"):
		transition_to(player.state_dodge)
	
	if(Input.is_action_just_pressed("Attack")):
		print("attacking")
		exited = true
		transition_to(player.state_attack_ground)

	player.handle_facing(true)
	
	if Input.is_action_just_pressed("Jump"):
		transition_to(player.state_jump)
		
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.5)
	#player.handle_movement(0.125, false)
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
