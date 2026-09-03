extends PlayerState
class_name Block_PlayerState

var total_parry_frames : float = 12
var current_parry_frames : float = 12

func _enter():
	super._enter()
	player.animator.play("Block")
	current_parry_frames = total_parry_frames

#func _exit():
	#current_parry_frames = total_parry_frames
	#player.parry_frames_debug.text = "Parry: " + str(current_parry_frames)


func _set_name() -> void:
	_state_name = "Block"

func _physics_process(delta : float) -> void:
	player.parry_frames_debug.text = "Parry: " + str(current_parry_frames)
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
	print("before: ", player.velocity)
	player.handle_gravity(delta)
	print("after: ", player.velocity)
	player.move_and_slide()
	vel_buffer = player.velocity
	
	if current_parry_frames > 0:
		current_parry_frames -= 1

func handle_damaged(area : Area2D):
	if current_parry_frames > 0:
		vel_buffer = Vector2.ZERO
		transition_to(player.state_parry)
	else:
		vel_buffer = (player.global_position - area.global_position).normalized() * 200
	pass
