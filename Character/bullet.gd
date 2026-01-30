extends CharacterBody2D

@export var speed: float = 300.0

var direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	var collision = move_and_collide(direction * speed * _delta)
	if collision:
		var collider = collision.get_collider()
		
		if collider is TileMapLayer: # Ou TileMap dependendo da versão
			var tile_pos = collider.local_to_map(collision.get_position() - collision.get_normal())
			var data = collider.get_cell_tile_data(tile_pos)
			
			if data and data.get_custom_data("can_break"):
				collider.erase_cell(tile_pos) # O bloco some!
				# Opcional: Instancie partículas na posição global do tile
		
		queue_free()
