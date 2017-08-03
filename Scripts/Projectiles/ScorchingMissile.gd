

extends KinematicBody2D

const SPEED = 5

var direction = Vector2( 0, 0 ) # direction that the fireball flies to
var parent

var target
var accel


func fire( direction, parent ):
	self.direction = direction
	self.parent = parent
	set_rot( rad2deg( direction.angle() ) )
#	add_collision_exception_with( parent )
	set_pos( parent.get_pos() )
	set_process( true )


func _process(delta):
	move( direction * SPEED )
	if target != null:
		home()


# Given the conditions, homes in the direction of the target
func home():
	if !weakref(target).get_ref(): # target was freed
		target = null
		return

	var target_pos = target.get_pos()
	var dif = target_pos - get_pos()
	direction += dif.normalized() / 40
	
	if direction.x > 1.1:
		direction.x = 1.1
	elif direction.x < - 1.1:
		direction.x = - 1.1

	if direction.y > 1.1:
		direction.y = 1.1
	elif direction.y < - 1.1:
		direction.y = - 1.1


func _on_Area2D_body_enter( body ):
	# does damage if take damage function exists
	# dies out
	if body != parent:
		die()


func _on_DetectionArea_body_enter( body ):
	if body.is_in_group("Player") and body != parent:
		target = body
		get_node("DetectionArea").queue_free()


func _on_LifeTimer_timeout():
	die()

func die():
	get_node( "AnimationPlayer" ).play( "death" )
	set_process( false )

func free():
	queue_free()

