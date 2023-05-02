extends CharacterBody2D

@export var speed = 300
@export var width_jump_wall = 450
@export var jump_speed = -550
@export var gravity = 1000
@onready var anim_player = $AnimatedSprite2D
var wall_jump = true 
var is_jump = false

func _physics_process(delta):
    # Add gravity every frame
    velocity.y += gravity * delta

    # Input affects x axis only
    velocity.x = Input.get_axis("left", "right") * speed
    print(velocity)
    move_and_slide()
    # Player jump
    
    ### --- JUMP (WITH ANIMATION) --- ###
    
    # -- Animation -- #
    
    # Player moving to top
    if round(velocity.y) < 0 and is_jump:
        anim_player.play("jump")
    # Player fall down
    if round(velocity.y) > 0 and is_jump:
        anim_player.play("fall")
    # Player touch the foor
    if round(velocity.y) >= -jump_speed - 100:
        anim_player.play("landing")
        is_jump = false
        await get_tree().create_timer(0.3).timeout
        AnimPlayer(velocity)
    
    # -- Moving Jump -- #
    
    # Only allow jumping when on the ground
    if Input.is_action_just_pressed("up") and is_on_floor():
        is_jump = true
        # Change vector y
        # Play animation "start_jump"
        anim_player.play("start_jump")
        await get_tree().create_timer(0.3).timeout
        velocity.y = jump_speed
        # Play next animation with detay 0.5
        AnimPlayer(velocity)
        
    # Alow jump off the wall when on the wall and not second jump off the wall
    if Input.is_action_pressed("up") and is_on_wall() and wall_jump:
        # Not avaible to double jump off the wall
        
        wall_jump = false
        # Change vector y
        velocity.y = jump_speed
        # chenge vector x
        velocity.x = width_jump_wall
    # Allow jump off the wall if Player touched the floor
    if is_on_floor():
        wall_jump = true
    
    ###  --- ANIMATE MOVING RUN---  ####

    
    # prints for logs
    # print("D" if Input.is_action_pressed("right") else "")
    # print("A" if Input.is_action_pressed("left") else "")
    # If Player press both keys
    if Input.is_action_pressed("right") and Input.is_action_pressed("left"):
        anim_player.play("idle")
        
    # If Player start moving right
    if velocity.x > 0 and Input.is_action_just_pressed("right") and !Input.is_action_just_pressed("left"):
        # Play animation "run"
        AnimPlayer(velocity)
    # When Player stoped moving right
    if Input.is_action_just_released("right"):
        # Player released "right" while NOT pressing "left"
        if !Input.is_action_pressed("left"):
            # Play animation "stop_run"
            anim_player.play("stop_run")
            await get_tree().create_timer(0.4).timeout
        # Play next animation (with delay 0.4 in case player not pressing "left")
        AnimPlayer(velocity)
   
    # If Player start moving left
    if velocity.x < 0 and Input.is_action_just_pressed("left") and !Input.is_action_just_pressed("right"):
        # Play next animation
        AnimPlayer(velocity)
    # When Player stoped moving left
    if Input.is_action_just_released("left"):
        # Player released "left" while NOT pressing "right"
        if !Input.is_action_pressed("right"):
            # Play animation "stop_run"
            anim_player.play("stop_run")
            await get_tree().create_timer(0.4).timeout
        # Play next animation (with delay 0.4 in case player not pressing "right")
        AnimPlayer(velocity)
    
func AnimPlayer(velocity):
    
    # Player is staying
    if velocity.x == 0:
        anim_player.play("idle")
        
    # Player moving right
    if velocity.x > 0 and !is_jump:
        anim_player.flip_h = false    # Dont flip animation frame by horizontal 
        # Play animation "start_run" with delay 0.2
        anim_player.play("start_run")
        await get_tree().create_timer(0.2).timeout
        # When animation "start_run" is over, play "run" animation
        anim_player.play("run")
        
    # Player moving left
    if velocity.x < 0 and !is_jump:
        anim_player.flip_h = true    # Flip animation frame by horizontal
        # Play animation "start_run" with delay 0.2
        anim_player.play("start_run")
        await get_tree().create_timer(0.2).timeout
        # When animation "start_run" is over, play "run" animation
        anim_player.play("run")
