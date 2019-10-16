extends Control

onready var HPsprite = $HP
onready var EquipSprite = $Equip
onready var HP = $HP/Label
onready var Dia = $Dialogue
onready var content = $Dialogue/RichTextLabel
onready var sword = $Equip/sword

var is_opened = false

var dialogue0 = [
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
var dialogue2 = [
				"Stranger: Congrats! Now you can enter the second portal.",
				"You: What? There is more?",
				"Stranger: Why quit! Sure there is more."
				]
var dialogue4 = [
				"Stranger: No no! You can enter the last portal! Oh no!",
				"You: Boss fight?",
				"Stranger: I'm sorry to inform you, no boss fight.",
				"You: Oh."
				]
var dialogue6 = [
				"Stranger: Well, I have no more portals for you.",
				"Stranger: As you see, this game is too small.",
				"Stranger: Because the designer, Nicky, first time in LD.",
				"Stranger: Took all he could, still couldn't finish what he design.",
				"You: What a shame.",
				"Stranger: Nevertheless, congrats on beating the game."
				]
var dialogueRe = [
				"Stranger: Those slimes are tough, ha?",
				"You: I'm getting there!",
				"Stranger: Good! Then enter the portal again."
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
	var index = floor(Data.scene)
	if index == 0 or index == 2 or index == 4 or index == 6:
		Dia.visible = true
		page = -1

func _on_Player_UpdateDialogue():
	match Data.scene:
		0.0:
			if page < dialogue0.size() - 1:
				page += 1
				content.text = dialogue0[page]
			else:
				close_dialogue()
		2.0:
			if page < dialogue2.size() - 1:
				page += 1
				content.text = dialogue2[page]
			else:
				close_dialogue()
		4.0:
			if page < dialogue4.size() - 1:
				page += 1
				content.text = dialogue4[page]
			else:
				close_dialogue()
		6.0:
			if page < dialogue6.size() - 1:
				page += 1
				content.text = dialogue6[page]
			else:
				close_dialogue()
		_:
			if page < dialogueRe.size() - 1:
				page += 1
				content.text = dialogueRe[page]
			else:
				close_dialogue()

func close_dialogue():
	Dia.visible = false
	var player = get_parent().get_node("Player")
	player.is_talking = false
	player.can_talk =false
	var portal_name = "Portal" + str(floor(Data.scene))
	var portal = get_parent().get_node(portal_name)
	if portal.has_method("open_portal"):
		portal.open_portal()
	Data.scene = floor(Data.scene + 1.0)

func _physics_process(delta):
	if get_parent().name != "World":
		var enemies = get_tree().get_nodes_in_group("Enemy")
		if !enemies and is_opened == false:
			var portal = get_parent().get_node("Portal")
			if portal.has_method("open_portal"):
				portal.open_portal()
			is_opened = true
			Data.scene += 1.0