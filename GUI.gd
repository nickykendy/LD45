extends Control

onready var HPsprite = $HP
onready var EquipSprite = $Equip
onready var HP = $HP/Label
onready var Dia = $Dialogue
onready var content = $Dialogue/RichTextLabel
onready var sword = $Equip/sword

var is_opened = false

var dialogue = [
				"Stranger: Hi there!",
				"Stranger: Come closer.",
				"Stranger: Are you trying to challege?",
				"You: Where am I? And who are you?",
				"Stranger: None of this is important.",
				"Stranger: You must enter the portal, defeat all the slimes",
				"You: Alright. But I have no weapon.",
				"Stranger: That's where the trick is. Go there and find yourself one.",
				"Stranger: Just remember, press J if you find one.",
				"You: OK! Here I come."
				]
var dialogue1 = [
				"Stranger: Congrats! Now you can enter the second portal.",
				"You: What? There is more?",
				"Stranger: Why quit! Sure there is more."
				]
var dialogue2 = [
				"Stranger: No no! You can enter the last portal! Oh no!",
				"You: Boss fight?",
				"Stranger: I'm sorry to inform you, no boss fight.",
				"You: Oh."
				]
var dialogue3 = [
				"Stranger: Well, I have no more portals for you.",
				"Stranger: As you see, this game is too small.",
				"Stranger: Because the designer, Nicky, first time in LD.",
				"Stranger: Took all he could, still couldn't finish what he design.",
				"You: What a shame.",
				"Stranger: Nevertheless, congrats on beating the game."
				]
var page = -1

signal EventBegin

func _ready():
	if get_parent().name != "World":
		HPsprite.visible = true
		EquipSprite.visible = true
	else:
		HPsprite.visible = false
		EquipSprite.visible =false
	var player = get_parent().get_node("Player")
	var max_hp = player.MAX_HEALTH
	var cur_hp = player.cur_health
	HP.text = String(cur_hp) + "/" + String(max_hp)

func _on_Player_UpdateHp(max_health, cur_health):
	HP.text = String(cur_health) + "/" + String(max_health)

func _on_Player_StartDialogue():
	if Data.scene == 0 or Data.scene == 2 or Data.scene == 4 or Data.scene == 6:
		Dia.visible = true
		page = -1

func _on_Player_UpdateDialogue():
	match Data.scene:
		0:
			if page < dialogue.size() - 1:
				page += 1
				content.text = dialogue[page]
			else:
				# close the dialogue
				Dia.visible = false
				var player = get_parent().get_node("Player")
				player.is_talking = false
				player.can_talk =false
				var portal = get_parent().get_node("Portal")
				if portal.has_method("open_portal"):
					portal.open_portal()
				Data.scene += 1
		2:
			if page < dialogue1.size() - 1:
				page += 1
				content.text = dialogue1[page]
			else:
				# close the dialogue
				Dia.visible = false
				var player = get_parent().get_node("Player")
				player.is_talking = false
				player.can_talk =false
				var portal = get_parent().get_node("Portal2")
				if portal.has_method("open_portal"):
					portal.open_portal()
				Data.scene += 1
		4:
			print("11111")
			if page < dialogue2.size() - 1:
				page += 1
				content.text = dialogue2[page]
			else:
				# close the dialogue
				Dia.visible = false
				var player = get_parent().get_node("Player")
				player.is_talking = false
				player.can_talk =false
				var portal = get_parent().get_node("Portal3")
				if portal.has_method("open_portal"):
					portal.open_portal()
				Data.scene += 1
		6:
			if page < dialogue3.size() - 1:
				page += 1
				content.text = dialogue3[page]
			else:
				# close the dialogue
				Dia.visible = false
				var player = get_parent().get_node("Player")
				player.is_talking = false
				player.can_talk =false
				Data.scene += 1
		

func _physics_process(delta):
	print(Data.scene)
	if get_parent().name != "World":
		var enemies = get_tree().get_nodes_in_group("Enemy")
		if !enemies and is_opened == false:
			var portal = get_parent().get_node("Portal")
			if portal.has_method("open_portal"):
				portal.open_portal()
			is_opened = true
			Data.scene += 1