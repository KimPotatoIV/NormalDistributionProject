extends Node2D

const SCREEN_SIZE: Vector2 = Vector2(1920.0, 1080.0)

const DISTRIBUTION_COUNT: int = 100000
const SECTION_COUNT: int = 100

var distribution_array: Array = []

func _ready() -> void:
	for i in range(SECTION_COUNT):
		distribution_array.append(0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		for i in range(DISTRIBUTION_COUNT):
			var value: float = MathManager.get_ndn(0.0, 100.0, 15.0)
			var value_to_int: int = round(value)
			distribution_array[value_to_int - 1] += 1
		
		queue_redraw()

func _draw() -> void:
	var bar_width: float = SCREEN_SIZE.x / SECTION_COUNT
	var max_height: float = SCREEN_SIZE.y
	var max_count = 0
	
	for i in range(distribution_array.size()):
		if distribution_array[i] > max_count:
			max_count = distribution_array[i]
	
	for i in range(SECTION_COUNT):
		if max_count * max_height == 0:
			break
		
		var bar_height = max_height * (float(distribution_array[i]) / float(max_count))
		
		draw_rect(Rect2(Vector2(i * bar_width, max_height - bar_height), \
						Vector2(bar_width, bar_height)), Color.HOT_PINK)
		
		draw_rect(Rect2(Vector2(i * bar_width, max_height - bar_height), \
						Vector2(bar_width, bar_height)), Color.MEDIUM_VIOLET_RED, false)
