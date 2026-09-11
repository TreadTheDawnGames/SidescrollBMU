extends PlayerState
class_name Block_PlayerState

func _enter():
	super._enter()
	if not player.state_machine.get_prev_state().get_name() == "Walk-Block":
		set_parry_frames(player.PARRY_FRAMES)

	player.animator.play("Block")

func _set_name() -> void:
	_state_name = "Block"

func _physics_process(delta : float) -> void:
	player.parry_frames_debug.text = "Parry: " + str(player.curr_parry_frames)
	if Input.is_action_just_released("Block"):
		transition_to(player.state_idle)
	
	if Input.get_axis("Left", "Right"):
		transition_to(player.state_walk_block)
	
	if Input.is_action_just_pressed("Attack"):
		transition_to(player.state_attack_ground)
	
	if Input.is_action_just_pressed("Dodge"):
		transition_to(player.state_dodge)
	
	vel_buffer.x = vel_buffer.x * 0.75
	player.velocity = vel_buffer
	#print("before: ", player.velocity)
	player.handle_gravity(delta)
	#print("after: ", player.velocity)
	player.move_and_slide()
	vel_buffer = player.velocity
	
	if player.curr_parry_frames > 0:
		player.curr_parry_frames -= 1

func handle_damaged(area : Area2D):
	if player.curr_parry_frames > 0:
		vel_buffer = Vector2.ZERO
		transition_to(player.state_parry)
	else:
		vel_buffer = (player.global_position - area.global_position).normalized() * 200
	pass

func set_parry_frames(frames : int):
	player.curr_parry_frames = frames
