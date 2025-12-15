extends StateAbstract

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "Dodge"

var player : Player

func _enter():
	player = get_owner()
	player.set_collision_mask_value(2, false)
	player.animator.play("Dodge")
	player._handle_stamina(1)
	await player.animator.animation_finished
	if(Input.get_axis("Left", "Right")):
		transition_to(player.state_walk)
	else:
		transition_to(player.state_idle)
	pass

func _exit():
	player.set_collision_mask_value(2, true)

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _physics_process(delta : float)
func _physics_process(delta : float) -> void:
	
	if(Input.is_action_just_pressed("Attack")):
		transition_to(player.state_attack_ground)
	
	player.velocity.x = player.DASH_SPEED * player.sprite.scale.x
	player.move_and_slide()
	pass

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _integrate_forces(state)

# in Godot v3, state is of type Physics2DDirectBodyState
# in Godot v4, state is of type PhysicsDirectBodyState2D
# to avoid problems between versions, it is changed to Object
func _integrate_forces(state: Object) -> void:
	pass

# public
# special methods, to detect whether it is a state or a state machine
func is_class_state_machine() -> bool:
	return false

# public
# special methods, to detect whether it is a state or a state machine
func is_class_state() -> bool:
	return true
