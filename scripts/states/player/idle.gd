extends PlayerState

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "Idle"


# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _enter() -> void:
	super._enter()
	player.animator.play("Idle")
	pass

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _exit() -> void:
	pass

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _physics_process(delta : float)
func _physics_process(_delta : float) -> void:
	if not self.player.is_on_floor():
		self.transition_to(self.player.state_air)
		return

	if Input.get_axis("Left", "Right"):
		if Input.is_action_pressed("Block"):
			transition_to(player.state_walk_block)
		else:
			self.transition_to(self.player.state_walk)
		return

	if Input.is_action_just_pressed("Jump") and \
			self.player.is_on_floor():
		self.transition_to(self.player.state_jump)
	
	if Input.is_action_just_pressed("Attack"):
		transition_to(player.state_attack_ground)
	
	if Input.is_action_just_pressed("Dodge"):
		transition_to(player.state_dodge)
		return
	
	if Input.is_action_pressed("Block"):
		transition_to(player.state_block)
		
	#player.move_and_slide()
	#vel_buffer = player.velocity
