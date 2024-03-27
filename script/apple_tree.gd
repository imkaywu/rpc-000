extends Node2D

var zoom = 2.5
var state = "no apples" # no apples, apples
var player = null
var player_in_area = false
var apple = preload('res://scene/apple_collectable.tscn')

@export var item: InventoryItem

# Called when the node enters the scene tree for the first time.
func _ready():
	if state == 'no apples':
		$GrowthTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == 'no apples':
		$AnimatedSprite2D.play('no apples')
	if state == 'apples':
		$AnimatedSprite2D.play('apples')
		if player_in_area:
			if Input.is_action_just_pressed('e'):
				state = "no apples"
				drop_apple()


func _on_pickable_area_body_entered(body):
	if body.has_method('player'):
		player_in_area = true
		player = body


func _on_pickable_area_body_exited(body):
	if body.has_method('player'):
		player_in_area = false
		player = null


func _on_growth_timer_timeout():
	if state == 'no apples':
		state = 'apples'


func drop_apple():
	var apple_instance = apple.instantiate()
	apple_instance.global_position = $Marker2D.global_position / zoom
	get_parent().add_child(apple_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	$GrowthTimer.start()
