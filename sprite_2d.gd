extends Sprite2D

var speed = 300
var score = 0
var coin
var label
var time_left = 30.0
var game_over = false
var coin_sound
var enemy
var enemy_velocity = Vector2(200, 150)
var high_score = 0

func _ready():
	coin = Sprite2D.new()
	coin.texture = texture
	coin.scale = Vector2(0.3, 0.3)
	coin.position = Vector2(800, 300)
	get_parent().add_child.call_deferred(coin)

	label = Label.new()
	label.text = "Score: 0   Time: 30"
	label.position = Vector2(20, 20)
	label.add_theme_font_size_override("font_size", 32)
	get_parent().add_child.call_deferred(label)

	coin_sound = AudioStreamPlayer.new()
	coin_sound.stream = load("res://toggle._004.ogg")
	get_parent().add_child.call_deferred(coin_sound)

	enemy = Sprite2D.new()
	enemy.texture = texture
	enemy.scale = Vector2(0.4, 0.4)
	enemy.modulate = Color.RED
	enemy.position = Vector2(200, 400)
	get_parent().add_child.call_deferred(enemy)

func _process(delta):
	if game_over:
		if Input.is_key_pressed(KEY_SPACE):
			restart()
		return

	time_left -= delta
	if time_left <= 0:
		game_over = true
		if score > high_score:
			high_score = score
		label.text = "Game over! Final score: " + str(score) + "\nHigh score: " + str(high_score) + "\nPress Space to restart"
		return

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * speed * delta

	var screen_size = get_viewport_rect().size
	var half = texture.get_size() / 2
	position = position.clamp(half, screen_size - half)

	label.text = "Score: " + str(score) + "   Time: " + str(int(time_left))

	enemy.position += enemy_velocity * delta
	if enemy.position.x < 0 or enemy.position.x > screen_size.x:
		enemy_velocity.x = -enemy_velocity.x
	if enemy.position.y < 0 or enemy.position.y > screen_size.y:
		enemy_velocity.y = -enemy_velocity.y

	if position.distance_to(enemy.position) < 80:
		game_over = true
		if score > high_score:
			high_score = score
		label.text = "Hit! Final score: " + str(score) + "\nHigh score: " + str(high_score) + "\nPress Space to restart"
		return

	if is_instance_valid(coin) and position.distance_to(coin.position) < 100:
		score += 1
		coin_sound.play()
		var new_x = randf_range(50, screen_size.x - 50)
		var new_y = randf_range(50, screen_size.y - 50)
		coin.position = Vector2(new_x, new_y)

func restart():
	score = 0
	time_left = 30.0
	game_over = false
	position = get_viewport_rect().size / 2
	coin.position = Vector2(800, 300)
	enemy.position = Vector2(200, 400)
