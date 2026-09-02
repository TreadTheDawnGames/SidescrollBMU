extends PlayerState

func _enter():
	super._enter()
	player.animator.play("Block")

func _set_name() -> void:
	_state_name = "Block"

func _physics_process(delta : float) -> void:
	if Input.is_action_just_released("Block"):
		transition_to(player.state_idle)
	
	if Input.get_axis("Left", "Right"):
		transition_to(player.state_walk_block)
	
	if Input.is_action_just_pressed("Attack"):
		transition_to(player.state_attack_ground)

func handle_damaged(area : Area2D):
	pass
