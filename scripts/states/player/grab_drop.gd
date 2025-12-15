extends StateAbstract

# private virtual, expected to be overridden by the inherited state
func _set_name() -> void:
	self._state_name = "GrabDrop"

# private virtual, expected to be overridden by the inherited state
# logic to accept a transition is written here
func _confirm_transition() -> void:
	pass

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _enter() -> void:
	pass

# private virtual, expected to be overridden by the inherited state
# called from the state machine logic
func _exit() -> void:
	pass

# private virtual, intended to be implemented in one of these methods
# called from the state machine logic
# _unhandled_input(ev : InputEvent)
# _input(ev : InputEvent)
# _input_event(ev : InputEvent)
func _input(event: InputEvent) -> void:
	pass

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _process(delta : float)
func _process(delta : float) -> void:
	pass

# private virtual, intended to implement the logic of the method
# called from the state machine logic
# _physics_process(delta : float)
func _physics_process(delta : float) -> void:
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
