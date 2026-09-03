extends PlayerState

func _set_name() -> void:
	_state_name = "Damaged"

func _enter():
	super._enter()
	player.animator.play("Damaged")
	await player.animator.animation_finished
	transition_to(player.state_idle)

func _physics_process(delta : float) -> void:
	player.velocity.x = player.velocity.x * 0.75#.move_toward(Vector2.ZERO, 0.9)
	player.handle_gravity(delta)
	player.move_and_slide()
