extends KinematicBody2D

signal Attack
signal UpdateHp

const UP = Vector2(0, -1)

onready var body = $Body
onready var hurt_cd = $HurtTimer
onready var restartTimer = $PlayerTimer

var SPEED = 25
var GRAVITY = 10
var JUMP_HEIGHT = 250
var MAX_HEALTH = 100
var DMG = 10

var motion = Vector2()
var state = "idle"
var face_dir = "right"
var attacking = false
var cur_health
var is_alive = true
var is_hurting = false

func _ready():
	cur_health = MAX_HEALTH

func _physics_process(delta):
	control()
	animate()
	move_and_slide(motion, UP)
	
func animate():
	body.animation = state
	
	if face_dir == "right":
		body.flip_h = false
	elif face_dir == "left":
		body.flip_h = true

func get_face_dir():
	if motion.x > 0:
		face_dir = "right"
	elif motion.x < 0:
		face_dir = "left"

func control():
	pass

func take_damage(damage):
	is_hurting = true
	hurt_cd.start(0.1)
	cur_health = clamp(cur_health-damage, 0, MAX_HEALTH)
	emit_signal("UpdateHp", MAX_HEALTH, cur_health)
	update_hp()
	if cur_health <= 0 and is_alive:
		is_alive = false
		die()

func die():
	state = "die"
	is_alive = false
	body.play()

func update_hp():
	pass

func _on_Body_animation_finished():
	if state == "attack":
		attacking = false
	if state == "die":
		if self.name == "Player":
			body.stop()
			body.frame = 4
			restartTimer.start(1.5)
			Data.scene -= 0.5
		else:
			queue_free()

func _on_HurtTimer_timeout():
	pass # Replace with function body.


func _on_PlayerTimer_timeout():
	get_tree().change_scene("res://Levels/World.tscn")
