extends PlayerState

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "Faint"


# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _enter() -> void:
	super._enter()
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
	transition_to(player.state_idle)
	#fainted = false
	pass

func _physics_process(delta : float) -> void:
	player.handle_gravity(delta)
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.move_and_slide()
	pass
