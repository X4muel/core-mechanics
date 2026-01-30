extends CharacterBody2D

@export var speed: float = 300.0

var direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
