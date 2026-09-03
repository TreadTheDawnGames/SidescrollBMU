extends CharacterBody2D
class_name Player

@export var max_stamina : int = 15

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var DASH_SPEED = 500
#@onready var punch_box_shape: CollisionShape2D = $Punch/PunchBoxd
@onready var health: HealthComponent = %HealthComponent
@onready var animator: AnimationPlayer = %Animator
@onready var sprite: Sprite2D = %Sprite2D
@onready var stamina_reset: Timer = %StaminaReset
@onready var stamina_bar: ProgressBar = %ProgressBar
@onready var hurtbox_shape: CollisionShape2D = %PunchBoxShape
@onready var faint_time: Timer = %FaintTime
@onready var hitbox: HitBoxComponent2D = %HitBoxComponent2D
@onready var parry_frames_debug: Label = %ParryFramesDebug


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
@export var CLASS_STATE_WALK_BLOCK : Script
@export var CLASS_STATE_BLOCK : Script
@export var CLASS_STATE_PARRY : Script
@export var CLASS_STATE_DAMAGED : Script


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
var state_walk_block : StateAbstract
var state_block : StateAbstract
var state_parry : StateAbstract
var state_damaged : StateAbstract

var state_machine 

func _ready():
	state_machine = %StateMachine.get_stage_machine()

	# Create new state machine for movements
	state_machine.create("PlayerSM")

	state_air  = CLASS_STATE_AIR. new()
	state_attack_air=  CLASS_STATE_ATTACK_AIR.new()
	state_attack_ground = CLASS_STATE_ATTACK_GROUND.new()
	state_dodge = CLASS_STATE_ATTACK_DODGE.new()
	state_fall = CLASS_STATE_FALL.new()
	state_faint = CLASS_STATE_FAINT.new()
	state_grab_idle= CLASS_STATE_GRAB_IDLE.new()
	state_grab_walk = CLASS_STATE_GRAB_WALK.new()
	state_grab_drop = CLASS_STATE_GRAB_DROP.new()
	state_idle=  CLASS_STATE_IDLE.new()
	state_jump=  CLASS_STATE_JUMP.new()
	state_walk = CLASS_STATE_WALK.new()
	state_walk_block = CLASS_STATE_WALK_BLOCK.new()
	state_block = CLASS_STATE_BLOCK.new()
	state_parry = CLASS_STATE_PARRY.new()
	state_damaged = CLASS_STATE_DAMAGED.new()
	
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
	state_walk_block.create(self, state_machine)
	state_block.create(self, state_machine)
	state_parry.create(self, state_machine)
	state_damaged.create(self, state_machine)
	# Assign initial state
	state_machine.set_init_state(state_idle)
	
	stamina_reset.timeout.connect(_reset_stamina)
	
	hitbox.Hit.connect(handle_damage)

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
	state_walk_block.free()
	state_block.free()
	state_parry.free()
	state_damaged.free()

var stamina : int = 0 :
	set(value):
		stamina = value
		stamina_bar.value = stamina
		pass

func handle_gravity(delta : float):
	if not is_on_floor():
		velocity += get_gravity() * delta


func handle_movement(multiplier : float = 1.0, transition_to_idle : bool = true, flip_sprite : bool = true):
	var direction = handle_facing(flip_sprite)
	if direction:
		velocity.x = direction * SPEED * multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * multiplier)
		if transition_to_idle:
			state_machine._current_state.transition_to(state_idle)
	move_and_slide()

func handle_facing(flip_sprite : bool) -> float:
	var direction = Input.get_axis("Left", "Right")
	if abs(direction) > 0 and flip_sprite:
		sprite.scale.x = sign(direction)

	return direction

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

func handle_damage(area : Area2D):
	#velocity += (((global_position - area.global_position).normalized() * 200 + (Vector2.UP * 20)) )
	state_machine._current_state.handle_damaged(area)
	#transition_to(player.state_damaged)
	print("hit")
	pass
