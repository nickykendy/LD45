extends "res://Actors/pActor.gd"

onready var attack_pos = $Position2D
onready var melee_attack = preload("res://Attack/MeleeAttack.tscn")

var right_key
var left_key
var up_key
var down_key
var attack_key
var interact_key
var can_talk = false
var is_talking = false
var can_attack = false

signal StartDialogue
signal UpdateDialogue

func _ready():
	SPEED = 40

func control():
	right_key = Input.is_action_pressed("right_key")
	left_key = Input.is_action_pressed("left_key")
	up_key = Input.is_action_pressed("up_key")
	down_key = Input.is_action_pressed("down_key")
	attack_key = Input.is_action_just_pressed("attack_key")
	interact_key = Input.is_action_just_pressed("interact_key")
	
	if is_alive and !is_talking:
		var hspd = int(right_key) - int(left_key)
		
		motion.x = hspd * SPEED
		get_face_dir()
		
		# player attack
		if attack_key and attacking == false and can_attack:
			motion.x = 0
			attacking = true
			
			var box = melee_attack.instance()
			var child_node = get_node("Position2D")
			add_child_below_node(child_node, box)
			if box.has_method("attack_enemy"):
				box.attack_enemy(face_dir)
			
		if attacking == true:
			state = "attack"
		else:
			if motion.x != 0:
				state = "walk"
			else:
				state = "idle"
		
		if is_hurting:
			modulate = "ff0000"
		else:
			modulate = "ffffff"
	else:
		motion.x = 0
		modulate = "ffffff"
	
	# player can jump and fall
	if is_on_floor():
		if up_key and is_alive and !is_talking:
			motion.y = -JUMP_HEIGHT
	else:
		motion.y += GRAVITY
	
	# talk
	if can_talk and interact_key and !is_talking:
		is_talking = true
		var dealer = get_parent().get_node("Dealer")
		dealer.talk.visible = false
		emit_signal("StartDialogue")
		
	if is_talking and interact_key:
		emit_signal("UpdateDialogue")

func _on_HurtTimer_timeout():
	is_hurting = false

func _on_Dealer_body_exited(body):
	if body.name == "Player":
		var dealer = get_parent().get_node("Dealer")
		if Data.scene == 0 or Data.scene == 2 or Data.scene == 4 or Data.scene == 6:
			dealer.talk.visible = false
			can_talk = false

func _on_Dealer_body_entered(body):
	if body.name == "Player":
		var dealer = get_parent().get_node("Dealer")
		if Data.scene == 0 or Data.scene == 2 or Data.scene == 4 or Data.scene == 6:
			dealer.talk.visible = true
			can_talk = true

func _on_Loot_body_entered(body):
	print(body)
	if body.name == "Player":
		can_attack = true
		var loot = get_parent().get_node("Loot")
		loot.queue_free()
