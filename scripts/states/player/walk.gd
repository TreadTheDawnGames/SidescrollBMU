extends PlayerState


# se ejecuta cuando se entra al estado
func _enter() -> void:
	super._enter()
	player.animator.play("Walk")
# se asigna un nombre al estado
func _set_name() -> void:
	self._state_name = "Walk"

# condiciones de transicion entre estados
func _confirm_transition() -> void:
	if not self.player.is_on_floor():
		self.transition_to(self.player.state_air)
		return

	if Input.is_action_just_pressed("Jump") and \
			self.player.is_on_floor():
		self.transition_to(self.player.state_jump)
		return

func _physics_process(_delta : float) -> void:
	if Input.is_action_just_pressed("Attack"):
		transition_to(player.state_attack_ground)
	
	if Input.is_action_just_pressed("Dodge"):
		transition_to(player.state_dodge)

	if Input.is_action_pressed("Block"):
		transition_to(player.state_walk_block)

	self.player.handle_movement()
