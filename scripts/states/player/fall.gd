extends PlayerState

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "Fall"

# se ejecuta cuando se entra al estado
func _enter() -> void:
	super._enter()
	player.animator.play("Fall")

# condiciones de transicion entre estados
func _confirm_transition() -> void:
	if self.player.is_on_floor():
		self.transition_to(self.player.state_idle)
		return

func _physics_process(delta : float) -> void:
	if(Input.is_action_just_pressed("Attack")):
		transition_to(player.state_attack_air)

	
	player.handle_gravity(delta)
	
	self.player.handle_movement(1.0, false)
