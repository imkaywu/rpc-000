extends Control


signal quest_menu_closed


var quest1_active = false
var quest1_completed = false
var stick = 0


func _process(delta):
	if quest1_active:
		if stick == 2:
			quest1_active = false
			quest1_completed = true
			play_finish_quest1_anim()


func quest1_chat():
	$Quest1UI.visible = true


func next_quest():
	if !quest1_completed:
		quest1_chat()
	else:
		$NoQuest.visible = true
		await get_tree().create_timer(3).timeout
		$NoQuest.visible = false

func _on_yes_button_pressed():
	$Quest1UI.visible = false
	quest1_active = true
	stick = 0
	emit_signal("quest_menu_closed")


func _on_no_button_pressed():
	$Quest1UI.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")


func stick_collected():
	stick += 1


func play_finish_quest1_anim():
	$QuestFinished.visible = true
	await get_tree().create_timer(3).timeout
	$QuestFinished.visible = false
