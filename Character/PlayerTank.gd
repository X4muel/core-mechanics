extends CharacterBody2D

@onready var anim = $Sprite2D/AnimationPlayer

@export var speed: float = 100.0
@export var rotation_speed: float = 20.0 # Aumentei um pouco pra não ficar lerdo

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2

var input_vector = Vector2.ZERO
var can_fire: bool = true

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
		anim.play("move")
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
		anim.play("idle")
		velocity = Vector2.ZERO
		
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") and can_fire:
		can_fire = false
		get_tree().create_timer(fire_rate).timeout.connect(_on_fire_cooldown_timeout)
		shoot_bullet()

func _on_fire_cooldown_timeout() -> void:
	can_fire = true

func shoot_bullet() -> void:
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.position = position
	
	# ARREDONDAMENTO: Pega a rotação atual e trava ela nos 4 eixos (PI/2 = 90 graus)
	var snapped_rotation = snapped(rotation, PI/2)
	bullet_instance.rotation = snapped_rotation
	
	# A direção agora é baseada na rotação travada
	var bullet_direction = Vector2.RIGHT.rotated(snapped_rotation).normalized()
	bullet_instance.direction = bullet_direction
	
	get_parent().add_child(bullet_instance)
