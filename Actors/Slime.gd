extends "res://Actors/pActor.gd"

onready var cd = $Timer
onready var zone = $Position2D/Area2D
onready var alert = $Sprite

export var PURSUE_RANGE = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED = 25
	GRAVITY = 10
	JUMP_HEIGHT = 250
	MAX_HEALTH = 100
	DMG = 10
	randomize()

func control():
	if is_alive == true:
		var target = get_parent().get_node("Player")
		if is_hurting == false:
			if target and target.is_alive:
				if target.position.distance_to(position) <= PURSUE_RANGE:
					slime_run_state("pursue", target)
				else:
					slime_run_state("wander", 0)
			else:
				slime_run_state("wander", 0)
		else:
			slime_run_state("hurt", target)
		
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
		
		if !is_on_floor():
			motion.y += GRAVITY
	else:
		motion = Vector2(0, 0)
	
	get_face_dir()

func slime_run_state(slime_state, target):
	match slime_state:
		"pursue":
			motion.x = SPEED * sign(target.position.x - position.x)
			if target.position.distance_to(position) <= 20 and target.is_alive:
				attacking = true
				slime_run_state("attack", target)
			alert.visible = true
			
		"wander":
			alert.visible = false
			if cd.is_stopped():
				cd.start(3)
				motion.x = SPEED * 0.5 * random_face()
				
		"attack":
			motion.x = SPEED * 1.5 * sign(target.position.x - position.x)
			alert.visible = true
			
		"hurt":
			if hurt_cd.is_stopped():
				is_hurting = false
			else:
				motion.x = -SPEED * 3 * sign(target.position.x - position.x)
				motion.y = -50

func random_face():
	var i = rand_range(0, 100)
	if i < 30:
		return -1
	elif i >= 30 and i <= 70:
		return 0
	else:
		return 1

func _physics_process(delta):
	var bodies = zone.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			if body.has_method("take_damage") and body.is_hurting == false:
				body.take_damage(DMG)