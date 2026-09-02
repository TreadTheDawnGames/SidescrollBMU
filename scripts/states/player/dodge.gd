extends PlayerState

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "Dodge"

var vel_buffer : float

func _enter():
	super._enter()
	player.set_collision_mask_value(2, false)
	player.animator.play("Dodge")
	player._handle_stamina(1)
	
	print("before", player.velocity.x)
	vel_buffer = player.velocity.x + player.DASH_SPEED * player.sprite.scale.x
	print("after", player.velocity.x)
	
	await player.animator.animation_finished
	#if(Input.get_axis("Left", "Right")):
		#transition_to(player.state_walk)
	#else:
	player.velocity.x = 0
	transition_to(player.state_idle)
	
	pass

func _exit():
	player.set_collision_mask_value(2, true)

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _physics_process(delta : float)
func _physics_process(delta : float) -> void:
	#print("thing 2")
	
	if(Input.is_action_just_pressed("Attack")):
		transition_to(player.state_attack_ground)
	print(player.velocity.x)
	vel_buffer = vel_buffer * 0.75
	player.velocity.x = vel_buffer
	
	player.move_and_slide()
	pass

func handle_damaged(area : Area2D):
	pass
