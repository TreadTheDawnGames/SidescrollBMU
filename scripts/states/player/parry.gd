extends PlayerState

func _enter():
	super._enter()
	player.animator.play("Parry")
	await player.animator.animation_finished
	transition_to(player.state_idle)
	
func _set_name() -> void:
	_state_name = "Parry"
