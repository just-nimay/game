extends CharacterBody2D

@export var speed = 300
@export var width_jump_wall = 450
@export var jump_speed = -450
@export var gravity = 1000
@onready var anim_player = $AnimatedSprite2D
var wall_jump = true
func _physics_process(delta):
    # Add gravity every frame
    velocity.y += gravity * delta

    # Input affects x axis only
    velocity.x = Input.get_axis("left", "right") * speed
    print(velocity)
    move_and_slide()

    # Only allow jumping when on the ground
    if Input.is_action_just_pressed("up") and is_on_floor():
        velocity.y = jump_speed
    if Input.is_action_pressed("up") and is_on_wall() and wall_jump:
        wall_jump = false
        velocity.y = jump_speed
        velocity.x = width_jump_wall
    if is_on_floor():
        wall_jump = true
        
    AnimPlayer(velocity)

func AnimPlayer(velocity):
    if velocity.x == 0:
        anim_player.play("idle")
    if velocity.x > 0:
        anim_player.flip_h = false
        anim_player.play("run")
        if Input.is_action_just_released("right"):
            anim_player.play("stop_run")
            await get_tree().create_timer(0.7).timeout
            print("yes")
    if velocity.x < 0:
        anim_player.flip_h = true
        anim_player.play("run")
