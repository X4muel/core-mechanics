extends CharacterBody2D

@export var speed: float = 100.0
@export var rotation_speed: float = 20.0 # Aumentei um pouco pra não ficar lerdo

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2.ZERO
	
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
