extends RigidBody2D

onready var col = $CollisionShape2D

func _physics_process(delta):
	var player = get_parent().get_node("Player")
	var ui = get_parent().get_node("GUI")
	if player:
		if position.distance_to(player.position) <= 25:
			player.can_attack = true
			ui.sword.visible = true
			queue_free()