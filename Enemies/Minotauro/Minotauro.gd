extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var sprite = $SpriteToro
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

var state = IDLE

func _ready():
	
	state = pick_random_state([IDLE, WANDER])
	animationTree.active = true
#	print(sprite)


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animationState.travel("Idle")
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
		WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
			
			var direction = global_position.direction_to(wanderController.target_position)
			
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			var input_vector = Vector2(-velocity.x, -velocity.y)
			
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationTree.set("parameters/Attack/blend_position", input_vector)
			#anim.play("WalkRight")
			animationState.travel("Run")
			sprite.flip_h = velocity.x < 0
			
			if global_position.distance_to(wanderController.target_position) <= 4:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				var input_vector = velocity
			
				animationTree.set("parameters/Idle/blend_position", input_vector)
				animationTree.set("parameters/Run/blend_position", input_vector)
				animationTree.set("parameters/Attack/blend_position", input_vector)
				var distance = global_position.distance_to(player.global_position)
				print('distance: ', distance)
				if distance < 10:
					print('attack!')
					state = ATTACK
			else:
				state = IDLE
			
			sprite.flip_h = velocity.x < 0
			animationState.travel("Run")
		ATTACK:
			attack_state(delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)


func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func attack_animation_finished():
	state = pick_random_state([IDLE, WANDER])


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
