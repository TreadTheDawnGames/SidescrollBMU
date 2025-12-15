extends StateAbstract

var player : Player

# se ejecuta cuando se entra al estado
func _enter() -> void:
	self.player = self.get_owner()
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

	#if self.player.velocity.x == 0:
		#self.transition_to(self.player.state_idle)
		#return
	#print("here 4")
	
#func _process(delta):
	#print("thing")

# logica
func _physics_process(_delta : float) -> void:
	if Input.is_action_just_pressed("Attack"):
		transition_to(player.state_attack_ground)
	
	if Input.is_action_just_pressed("Dodge"):
		transition_to(player.state_dodge)

	var direction = Input.get_axis("Left", "Right")
	if direction:
		self.player.velocity.x = direction * self.player.SPEED
		player.sprite.scale.x = sign(direction)
	else:
		print("changing to idle from walk")
		transition_to(player.state_idle)
		#self.player.velocity.x = move_toward(self.player.velocity.x, 0, self.player.SPEED)

	self.player.move_and_slide()
