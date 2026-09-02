extends PlayerState

func _enter():
	super._enter()
	player.animator.play("Damaged")
	await player.animator.animation_finished
	transition_to(player.state_idle)

func _physics_process(delta : float) -> void:
	player.velocity = player.velocity.move_toward(Vector2.ZERO, 0.9)
	player.move_and_slide()

	
