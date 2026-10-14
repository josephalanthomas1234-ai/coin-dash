extends Sprite2D

var speed = 300
var score = 0
var coin
var label
var time_left = 30.0
var game_over = false

func _ready():
	coin = Sprite2D.new()
	coin.texture = texture
	coin.scale = Vector2(0.3, 0.3)
	coin.position = Vector2(800, 300)
	get_parent().add_child.call_deferred(coin)

	label = Label.new()
	label.text = "Score: 0"
	label.position = Vector2(20, 20)
	label.add_theme_font_size_override("font_size", 32)
	get_parent().add_child.call_deferred(label)

func _process(delta):
	if game_over:
		return
	time_left -= delta
	if time_left <= 0:
		game_over = true
		label.text = "Game over! Final score: " + str(score)
		return
		
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * speed * delta

	var screen_size = get_viewport_rect().size
	var half = texture.get_size() / 2
	position = position.clamp(half, screen_size - half)

	if is_instance_valid(coin) and position.distance_to(coin.position) < 100:
		score += 1
		label.text = "Score: " + str(score) + "   Time: " + str(int(time_left))
		coin.position = Vector2(randf_range(50, screen_size.x - 50), randf_range(50, screen_size.y - 50))
