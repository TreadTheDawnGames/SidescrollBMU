extends Block_PlayerState

func _enter():
	if not self.player:
		self.player = self.get_owner()
	vel_buffer = player.velocity
	if not player.state_machine.get_prev_state().get_name() == "Block":
		set_parry_frames(player.PARRY_FRAMES)

	player.animator.play("Walk-Block")

func _set_name() -> void:
	_state_name = "Walk-Block"

func _physics_process(delta : float) -> void:
	player.parry_frames_debug.text = "Parry: " + str(player.curr_parry_frames)
	
	if Input.is_action_just_released("Block"):
		transition_to(player.state_idle)
	
	if not Input.get_axis("Left", "Right"):
		transition_to(player.state_block)
		
	if Input.is_action_just_pressed("Attack"):
		transition_to(player.state_attack_ground)

	if Input.is_action_just_pressed("Dodge"):
		transition_to(player.state_dodge)

	player.handle_gravity(delta)

	player.handle_movement(0.125, false, false)
	if player.curr_parry_frames > 0:
		player.curr_parry_frames -= 1
		print("frames: ", player.curr_parry_frames)
