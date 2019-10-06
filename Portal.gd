extends Area2D

onready var anim = $AnimationPlayer
onready var collision = $CollisionShape2D
export (String) var scene

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			if body.interact_key:
				get_tree().change_scene(scene)

func open_portal():
	anim.play("PortalEffect")
	collision.disabled = false