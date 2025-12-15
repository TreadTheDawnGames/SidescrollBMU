extends StateAbstract

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "Faint"

var player : Player

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _enter() -> void:
	self.player = self.get_owner()
	player.animator.play("Faint")
	player.stamina_reset.stop()
	player.faint_time.start()
	print("fainting")
	await player.faint_time.timeout
	
	print("ending faint")
	player.max_stamina -= 1
	player.stamina_bar.max_value = player.max_stamina
	
	player.stamina = 0
	if(player.max_stamina<=0):
		print(player.max_stamina)
		return
	print("changing to idle from faint")
	transition_to(player.state_idle)
	#fainted = false
	pass

func _physics_process(delta : float) -> void:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.move_and_slide()
	pass
