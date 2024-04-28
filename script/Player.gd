extends CharacterBody2D


signal stick_collected
signal apple_collected
signal slime_collected


var speed = 200
var player_state
var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scene/arrow.tscn")
var mouse_from_player_pos = null

@export var inventory: Inventory

@onready var camera = $Camera2D

func _physics_process(delta):
	mouse_from_player_pos = get_global_mouse_position() - self.position
	
	var direction = Input.get_vector("left", "right", "up", 'down')
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("e"):
		if bow_equiped:
			bow_equiped = false
		else:
			bow_equiped = true
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equiped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		await get_tree().create_timer(0.5).timeout
		bow_cooldown = true
	
	play_anim(direction)
	
func play_anim(dir):
	if !bow_equiped:
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		if player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			if dir.x == 1:
				$AnimatedSprite2D.play('e-walk')
			if dir.y == 1:
				$AnimatedSprite2D.play('s-walk')
			if dir.x == -1:
				$AnimatedSprite2D.play('w-walk')

			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play('ne-walk')
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play('se-walk')
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
	if bow_equiped:
		if mouse_from_player_pos.x >= -25 and mouse_from_player_pos.x <= 25 and mouse_from_player_pos.y < 0:
			$AnimatedSprite2D.play("n-attack")
		if mouse_from_player_pos.y >= -25 and mouse_from_player_pos.y <= 25 and mouse_from_player_pos.x > 0:
			$AnimatedSprite2D.play("e-attack")
		if mouse_from_player_pos.x >= -25 and mouse_from_player_pos.x <= 25 and mouse_from_player_pos.y > 0:
			$AnimatedSprite2D.play("s-attack")
		if mouse_from_player_pos.y >= -25 and mouse_from_player_pos.y <= 25 and mouse_from_player_pos.x < 0:
			$AnimatedSprite2D.play("w-attack")
		if mouse_from_player_pos.x >= 25 and mouse_from_player_pos.y <= -25:
			$AnimatedSprite2D.play("ne-attack")
		if mouse_from_player_pos.x >= 0.5 and mouse_from_player_pos.y >= 25:
			$AnimatedSprite2D.play("se-attack")
		if mouse_from_player_pos.x <= -0.5 and mouse_from_player_pos.y >= 25:
			$AnimatedSprite2D.play("sw-attack")
		if mouse_from_player_pos.x <= -25 and mouse_from_player_pos.y <= -25:
			$AnimatedSprite2D.play("nw-attack")

func player():
	pass


func collect(item):
	inventory.insert(item)
	if str(item) == "<Resource#-9223372001320630916>":
		emit_signal("stick_collected")
	elif str(item) == "<Resource#-9223372001857501837>":
		emit_signal("apple_collected")
	elif str(item) == "<Resource#-9223372004374084279>":
		emit_signal("slime_collected")
