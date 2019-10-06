extends Area2D

onready var anim_sprite = $MeleeEffect
onready var col = $CollisionShape2D
var DMG = 50

func attack_enemy(face_dir):
	var attack_pos = get_parent().get_node("Position2D")
	if face_dir == "right":
		position = Vector2(26, 0)
		scale = Vector2(1, 1)
	elif face_dir == "left":
		position = Vector2(-26, 0)
		scale = Vector2(-1, 1)
	
	anim_sprite.frame = 0
	anim_sprite.play()

func _physics_process(delta):
	if anim_sprite.frame >= 4:
		col.disabled = false
	
func _on_MeleeEffect_animation_finished():
	queue_free()

func _on_MeleeAttack_body_entered(body):
	if body.is_in_group("Enemy"):
		if body.has_method("take_damage"):
			body.take_damage(DMG)