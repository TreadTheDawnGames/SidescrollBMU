extends StateAbstract

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "Fall"


var player : Player

# se ejecuta cuando se entra al estado
func _enter() -> void:
	self.player = self.get_owner()
	player.animator.play("Fall")

# condiciones de transicion entre estados
func _confirm_transition() -> void:
	if self.player.is_on_floor():
		self.transition_to(self.player.state_idle)
		return

func _physics_process(delta : float) -> void:
	if(Input.is_action_just_pressed("Attack")):
		transition_to(player.state_attack_air)

	
	self.player.velocity += player.get_gravity() * delta

	var direction = Input.get_axis("Left", "Right")
	if direction:
		self.player.velocity.x = direction * self.player.SPEED
		player.sprite.scale.x = sign(direction)
	else:
		self.player.velocity.x = move_toward(
						self.player.velocity.x, 0, self.player.SPEED)

	self.player.move_and_slide()
