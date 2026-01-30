extends CharacterBody2D

@export var speed: float = 100.0
@export var rotation_speed: float = 20.0 # Aumentei um pouco pra não ficar lerdo

@export var bullet_scene: PackedScene

var input_vector = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1
	elif Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	elif Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	elif Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	
	if input_vector != Vector2.ZERO:
		var target_angle = input_vector.angle()
		
		# Gira suavemente
		rotation = lerp_angle(rotation, target_angle, rotation_speed * _delta)
		
		# CHEQUE DE PRECISÃO: Se a diferença for menor que 0.1 radianos, ele anda
		# Isso evita que o tanque fique "congelado" por causa de floats quebrados
		if abs(angle_difference(rotation, target_angle)) < 0.1:
			velocity = input_vector * speed
		else:
			# Opcional: faz ele andar bem devagarzinho enquanto gira
			velocity = Vector2.ZERO 
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		shoot_bullet()

func shoot_bullet() -> void:
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.position = position
	bullet_instance.rotation = rotation
	bullet_instance.direction = Vector2.RIGHT.rotated(rotation)
	get_parent().add_child(bullet_instance)
