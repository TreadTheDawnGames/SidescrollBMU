extends CharacterBody2D
class_name Player

@export var max_stamina : int = 15

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 500
#@onready var punch_box_shape: CollisionShape2D = $Punch/PunchBoxd
@onready var health: HealthComponent = %HealthComponent

@export var CLASS_STATE_AIR  : Script
@export var CLASS_STATE_ATTACK_AIR  : Script
@export var CLASS_STATE_ATTACK_GROUND  : Script
@export var CLASS_STATE_ATTACK_DODGE  : Script
@export var CLASS_STATE_FALL : Script
@export var CLASS_STATE_FAINT : Script
@export var CLASS_STATE_GRAB_IDLE : Script
@export var CLASS_STATE_GRAB_WALK : Script
@export var CLASS_STATE_GRAB_DROP : Script
@export var CLASS_STATE_IDLE : Script
@export var CLASS_STATE_JUMP : Script
@export var CLASS_STATE_WALK : Script



var state_air : StateAbstract
var state_attack_air : StateAbstract
var state_attack_ground : StateAbstract
var state_dodge : StateAbstract
var state_fall : StateAbstract
var state_faint : StateAbstract
var state_grab_idle : StateAbstract
var state_grab_walk : StateAbstract
var state_grab_drop : StateAbstract
var state_idle : StateAbstract
var state_jump : StateAbstract
var state_walk : StateAbstract

var state_machine

func _ready():
	state_machine = %StateMachine.get_stage_machine()

	# Create new state machine for movements
	state_machine.create("PlayerSM")

	state_air  = CLASS_STATE_AIR. new()
	state_attack_air=  CLASS_STATE_ATTACK_AIR.new()
	state_attack_ground = CLASS_STATE_ATTACK_GROUND.new()
	state_dodge = 	CLASS_STATE_ATTACK_DODGE.new()
	state_fall =	CLASS_STATE_FALL.new()
	state_faint =	CLASS_STATE_FAINT.new()
	state_grab_idle= 	CLASS_STATE_GRAB_IDLE.new()
	state_grab_walk =	CLASS_STATE_GRAB_WALK.new()
	state_grab_drop =	CLASS_STATE_GRAB_DROP.new()
	state_idle= 	CLASS_STATE_IDLE.new()
	state_jump= 	CLASS_STATE_JUMP.new()
	state_walk =	CLASS_STATE_WALK.new()
	
	
	# Assign owner and state machine to the state
	state_air.create(self, state_machine)
	state_attack_air.create(self, state_machine)
	state_attack_ground.create(self, state_machine)
	state_dodge.create(self, state_machine)
	state_fall.create(self, state_machine)
	state_faint.create(self, state_machine)
	state_grab_idle.create(self, state_machine)
	state_grab_walk.create(self, state_machine)
	state_grab_drop.create(self, state_machine)
	state_idle.create(self, state_machine)
	state_jump.create(self, state_machine)
	state_walk.create(self, state_machine)
	
	# Assign initial state
	state_machine.set_init_state(state_idle)
	
	stamina_reset.timeout.connect(_reset_stamina)

func _physics_process(delta : float) -> void:
	state_machine.physics_process(delta)
	var cur_state : StateAbstract = state_machine._current_state
	print("state: " + cur_state.get_name())

func free() -> void:
	state_air.free()
	state_attack_air.free()
	state_attack_ground.free()
	state_dodge.free()
	state_fall.free()
	state_grab_idle.free()
	state_grab_walk.free()
	state_grab_drop.free()
	state_idle.free()
	state_jump.free()
	state_walk.free()

#extends CharacterBody2D
#
#@export var max_stamina : int = 15
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
##@onready var punch_box_shape: CollisionShape2D = $Punch/PunchBox
#@onready var health: HealthComponent = %HealthComponent
@onready var animator: AnimationPlayer = %Animator
@onready var sprite: Sprite2D = %Sprite2D
@onready var stamina_reset: Timer = %StaminaReset
@onready var stamina_bar: ProgressBar = %ProgressBar
@onready var faint_time: Timer = %FaintTime

#var state_machine
#@onready var state_machine_node: NodeStateMachine = %StateMachine
#
##var fainted : bool = false
#
var stamina : int = 0 :
	set(value):
		stamina = value
		stamina_bar.value = stamina
		pass
#
#func _ready() -> void:
	#state_machine = state_machine_node.get_stage_machine()
	#state_machine.create("PlayerSM")
	#health.Died.connect(state_machine)
	#pass
	#punch_box_shape.disabled = true
	#faint_time.timeout.connect(_end_faint)
	#stamina_bar.max_value = max_stamina
	

#func _physics_process(delta: float) -> void:

	#if(fainted or animator.current_animation == "Dodge"):
		#velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		#move_and_slide()
		#return



	 #Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("Jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("Left", "Right")
	#if direction:
		#velocity.x = direction * SPEED
		#if(stamina>0 and is_on_floor()):
			#velocity.x*= (2.0/(stamina*5))
		#sprite.scale.x = sign(direction)
		
		#if(is_on_floor() and (stamina == 0 or animator.current_animation.begins_with("Air"))):
			#if(animator.current_animation.begins_with("Air")):
				#stamina_reset.stop()
				##stamina_reset.timeout.emit()
			#animator.play("Walk")
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED*0.1)
		#if(is_zero_approx(velocity.length()) and stamina == 0 and is_on_floor()):
			#animator.play("Idle")

	#if Input.is_action_just_pressed("Attack"):
		#_handle_attack()
#
	#if(Input.is_action_just_pressed("Dodge")):
		#_handle_dodge()
		#
	#if(not is_on_floor() and stamina == 0):
		#animator.play("Jump" if velocity.y < 0 else "Fall")
	
	#move_and_slide()
	
#func _handle_dodge():
	#velocity.x = 500 * sprite.scale.x
	#animator.play("Dodge")
	#_handle_stamina(1)
	#
	#pass

#func _handle_attack():
	#animator.play(("Air" if not is_on_floor() else "")+"Attack" + str(stamina%4))
	#_handle_stamina(1)

func _handle_stamina(amount : int):
	stamina += amount
	stamina_reset.start()
	
	if(stamina <= max_stamina):
		return
	stamina_reset.stop()
	state_machine.transition_to(state_faint)
	#animator.play("Faint")
	#fainted = true
	faint_time.start()

func _reset_stamina():
	stamina = 0
	#state_machine.transition_to(state_idle)
	#animator.play("Idle")
	
#func _end_faint():
	#print("ending faint")
	#max_stamina -= 1
	#stamina_bar.max_value = max_stamina
	#
	#stamina = 0
	#if(max_stamina<=0):
		#return
	#animator.play("Idle")
	#stamina_reset.timeout.emit()
	##fainted = false
	#pass

#func _end_dodge():
	#print("ending dodge")
	#animator.play("Idle")
	#pass
