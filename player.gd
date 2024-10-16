extends CharacterBody2D

const SPEED = 190.0
const JUMP_FORCE = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false

@onready var animation := $Animated as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Se o personagem estiver no chão, não está mais pulando.
		is_jumping = false
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
		animation.play("jump")

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction  # Espelha o sprite baseado na direção
		if not is_jumping:
			animation.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not is_jumping:
			animation.play("idle")

	move_and_slide()
