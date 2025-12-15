extends StateAbstract
var player : Player

# se ejecuta cuando se entra al estado
func _enter() -> void:
	self.player = self.get_owner()

# se asigna un nombre al estado
func _set_name() -> void:
	self._state_name = "Air"

# condiciones de transicion entre estados
func _confirm_transition() -> void:
	if self.player.velocity.y > 0:
		self.transition_to(self.player.state_fall)
		return

# logica
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
