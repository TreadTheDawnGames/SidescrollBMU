extends PlayerState

func _enter():
	super._enter()
	player.animator.play("Walk-Block")

func _set_name() -> void:
	_state_name = "Walk-Block"

func _physics_process(delta : float) -> void:
	if Input.is_action_just_released("Block"):
		transition_to(player.state_idle)
	
	if not Input.get_axis("Left", "Right"):
		transition_to(player.state_block)

	if Input.is_action_just_pressed("Attack"):
		transition_to(player.state_attack_ground)
	
	if not player.is_on_floor():
		player.handle_gravity(delta)


	player.handle_movement(0.125, false, false)

func handle_damaged(area : Area2D):
	pass
