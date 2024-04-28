extends Control


signal diag_finished


@export_file("*.json") var diag_file

var dialogue = []
var curr_diag_id = 0
var diag_active = false


func _ready():
	$NinePatchRect.visible = false
	


func start():
	if diag_active:
		return
	diag_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	curr_diag_id = -1
	next_script()


func _input(event):
	if !diag_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()


func load_dialogue():
	var file = FileAccess.open("res://dialogue/worker_dialogue_0.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
	

func next_script():
	curr_diag_id += 1
	if curr_diag_id >= len(dialogue):
		diag_active = false
		$NinePatchRect.visible = false
		emit_signal("diag_finished")
		return
	
	$NinePatchRect/Name.text = dialogue[curr_diag_id]['name']
	$NinePatchRect/Text.text = dialogue[curr_diag_id]['text']
	
