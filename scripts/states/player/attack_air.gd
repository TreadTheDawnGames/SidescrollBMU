extends StateAbstract

var player : Player

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "AttackAir"

# private virtual, expected to be overridden by the inherited state
# logic to accept a transition is written here
func _confirm_transition() -> void:
	pass

var exited : bool = true

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _enter() -> void:
	exited = false
	player = get_owner()
	player.animator.play("AirAttack" + str(player.stamina%4))
	player._handle_stamina(1)
	player.stamina_reset.start()
	
	await player.stamina_reset.timeout

	print("changing to idle from attack")
	if not exited:
		transition_to(player.state_fall)
	
	pass

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _exit() -> void:
	player.stamina_reset.stop()
	pass

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _physics_process(delta : float)
func _physics_process(delta : float) -> void:
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity()*delta
	
	if(Input.is_action_just_pressed("Attack")):
		print("attacking")
		exited = true
		transition_to(player.state_attack_air)
	
	var direction = Input.get_axis("Left", "Right")
	if direction:
		self.player.velocity.x = direction * self.player.SPEED
		player.sprite.scale.x = sign(direction)
	else:
		self.player.velocity.x = move_toward(self.player.velocity.x, 0, self.player.SPEED)

	if player.is_on_floor():
		transition_to(player.state_idle)
		return

	self.player.move_and_slide()

	
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
