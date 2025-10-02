extends Node2D

const SCREEN_SIZE: Vector2 = Vector2(1920.0, 1080.0)

const DISTRIBUTION_COUNT: int = 100000
const SECTION_COUNT: int = 100

const MIN_VALUE: float = 0.0
const MAX_VALUE: float = 100.0
const DEVIATION: float = 15.0

var distribution_array: Array = []

func _ready() -> void:
	for i in range(SECTION_COUNT):
		distribution_array.append(0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		for i in range(DISTRIBUTION_COUNT):
			var value: float = MathManager.get_ndn(MIN_VALUE, MAX_VALUE, DEVIATION)
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
		var bar_height = \
			max_height * (float(distribution_array[i]) / float(max_count))
		
		draw_rect(Rect2(Vector2(i * bar_width, max_height - bar_height), \
						Vector2(bar_width, bar_height)), Color.CORNFLOWER_BLUE)
		
		draw_rect(Rect2(Vector2(i * bar_width, max_height - bar_height), \
						Vector2(bar_width, bar_height)), \
						Color.BLUE, false)
	
	for i in range(SECTION_COUNT):
		var bar_height = \
			max_height * (float(distribution_array[i]) / float(max_count))
		
		var next_bar_height: float
		if i == SECTION_COUNT - 1:
			continue
			
		next_bar_height = \
			max_height * (float(distribution_array[i + 1]) / float(max_count))
		
		draw_line(Vector2(i * bar_width + bar_width / 2, max_height - bar_height), \
					Vector2((i + 1) * bar_width + bar_width / 2, \
					max_height - next_bar_height), Color.YELLOW, 10.0)
