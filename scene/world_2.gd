extends Node2D

@onready var anim_player = $CutSceneOpening/AnimationPlayer
@onready var camera = $CutSceneOpening/Path2D/PathFollow2D/Camera2D

var is_cutscene_opening = false
var player_entered_area = false
var player = null
var is_path_following = false
var smoke_has_happened = false
var smoke_is_happening = false

func _physics_process(delta):
	if is_cutscene_opening:
		var path_follower = $CutSceneOpening/Path2D/PathFollow2D
		
		if is_path_following:
			if !smoke_is_happening:
				path_follower.progress_ratio += 0.001
			
			if path_follower.progress_ratio >= 0.98:
				cutscene_closing()
				
			if !smoke_has_happened and !smoke_is_happening and path_follower.progress_ratio >= 0.78:
				smoke_is_happening = true
				toggle_smoke()
				await get_tree().create_timer(1).timeout
				$CutSceneOpening/TileMapFinished.visible = true
				$CutSceneOpening/TileMapUnfinished.visible = false
				toggle_smoke()
				await get_tree().create_timer(0.5).timeout
				smoke_has_happened = true
				smoke_is_happening = false
				

func _on_player_detection_body_entered(body):
	if body.has_method('player'):
		player = body
		if !player_entered_area:
			player_entered_area = true
			cutscene_opening()
			

func cutscene_opening():
	is_cutscene_opening = true
	anim_player.play("cover_fade")
	player.camera.enabled = false
	camera.enabled = true
	is_path_following = true
	
	
func cutscene_closing():
	is_path_following = false
	is_cutscene_opening = false
	camera.enabled = false
	player.camera.enabled = true
	$CutSceneOpening.visible = false
	$Main.visible = true


func toggle_smoke():
	var smoke = $CutSceneOpening/SmokeParticles
	smoke.emitting = !smoke.emitting
