extends CharacterBody2D

@export var max_stamina : int = 15

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
#@onready var punch_box_shape: CollisionShape2D = $Punch/PunchBox
@onready var health: HealthComponent = %HealthComponent
@onready var animator: AnimationPlayer = %Animator
@onready var sprite: Sprite2D = %Sprite2D
@onready var stamina_reset: Timer = %StaminaReset
@onready var stamina_bar: ProgressBar = %ProgressBar
@onready var faint_time: Timer = %FaintTime

var fainted : bool = false

var stamina : int = 0 :
	set(value):
		stamina = value
		stamina_bar.value = stamina
		pass

func _ready() -> void:
	#punch_box_shape.disabled = true
	stamina_reset.timeout.connect(_exit_attack)
	faint_time.timeout.connect(_end_faint)
	stamina_bar.max_value = max_stamina
	

func _physics_process(delta: float) -> void:
	 #Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if(fainted or animator.current_animation == "Dodge"):
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		move_and_slide()
		return

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		#if(stamina>0 and is_on_floor()):
			#velocity.x*= (2.0/(stamina*5))
		sprite.scale.x = sign(direction)
		
		if(is_on_floor() and (stamina == 0 or animator.current_animation.begins_with("Air"))):
			if(animator.current_animation.begins_with("Air")):
				stamina_reset.stop()
				#stamina_reset.timeout.emit()
			animator.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*0.1)
		if(is_zero_approx(velocity.length()) and stamina == 0 and is_on_floor()):
			animator.play("Idle")

	if Input.is_action_just_pressed("Attack"):
		_handle_attack()

	if(Input.is_action_just_pressed("Dodge")):
		_handle_dodge()
		
	if(not is_on_floor() and stamina == 0):
		animator.play("Jump" if velocity.y < 0 else "Fall")
	
	move_and_slide()
	



func _handle_dodge():
	velocity.x = 500 * sprite.scale.x
	animator.play("Dodge")
	_handle_stamina(1)
	
	pass

func _handle_attack():
	animator.play(("Air" if not is_on_floor() else "")+"Attack" + str(stamina%4))
	_handle_stamina(1)

func _handle_stamina(amount : int):
	stamina += amount
	stamina_reset.start()
	
	if(stamina <= max_stamina):
		return
	stamina_reset.stop()
	animator.play("Faint")
	fainted = true
	faint_time.start()

func _exit_attack():
	stamina = 0
	animator.play("Idle")
	
func _end_faint():
	print("ending faint")
	max_stamina -= 1
	stamina_bar.max_value = max_stamina
	
	stamina = 0
	if(max_stamina<=0):
		return
	animator.play("Idle")
	stamina_reset.timeout.emit()
	fainted = false
	pass

func _end_dodge():
	print("ending dodge")
	animator.play("Idle")
	pass
