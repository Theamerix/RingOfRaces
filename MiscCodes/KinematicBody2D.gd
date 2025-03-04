extends CharacterBody2D

const GRAVITY = 0.0
const WALK_SPEED = 200
const interaction_circle_size = 150
#onready var background_map  = get_node("/root/base_scene/background")
@onready var background_map  = get_node("../background")
@onready var vegetation_map  = get_node("../vegetation")
@onready var interaction_map = get_node("../interaction_map")
@onready var player_interaction_map = get_node("../player_interaction")
#onready var cell_size = background_map._get_cell_size()
@onready var cell_size = 32

# var velocity = Vector2()
var world_position
var ItemClass = preload("res://MiscScenes/Item.tscn")
var previous_position = Vector2(0,0)

#Moving buttons
func _physics_process(delta):
	var cur = Vector2(int(self.position.x / cell_size.x), int(self.position.y / cell_size.y))
	if(cur != previous_position):
		player_interaction_map.set_cell(int(self.position.x / cell_size.x), int(self.position.y / cell_size.y) , 0)
		player_interaction_map.set_cell(previous_position.x, previous_position.y, -1)
		previous_position = Vector2(int(self.position.x / cell_size.x), int(self.position.y / cell_size.y))
	if Input.is_action_just_pressed("interact_with_cell"):
		_interaction_process()
	velocity.y += delta * GRAVITY
	if Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x =  WALK_SPEED
	elif Input.is_action_pressed("move_up"):
		velocity.y =  -WALK_SPEED
	elif Input.is_action_pressed("move_down"):
		velocity.y =  WALK_SPEED
	else:
		velocity.x = 0
		velocity.y = 0
	set_velocity(velocity)
	set_up_direction(Vector2(0, -1))
	move_and_slide()
	
	Global.current_camera.Update()

func InteractWithCell():
	for _i in self.get_parent().get_children():
		print("Nodes visible ",_i)
		if _i is TileMap:
			print("Checking ", _i)
			for x in 300:
				for y in 300:
					if _i.get_cell(x, y) != -1:
						print(_i.get_cell(x, y))
#					else:
#						_i.set_cell(x, y, 1)
			
	var plant_cell_mouse = interaction_map.get_cell(int(world_position[0] / cell_size.x), int(world_position[1] / cell_size.y))
	var plant_cell_character = interaction_map.get_cell(int(self.position.x / cell_size.x), int(self.position.y / cell_size.y))
	
	var background_cell = background_map.get_cell(int(world_position[0] / cell_size.x), int(world_position[1] / cell_size.y))
	var interaction_cell = player_interaction_map.get_cell(int(world_position[0] / cell_size.x), int(world_position[1] / cell_size.y))
	
	print("plant cell mouse line 1: ", interaction_map.get_cell(12, 36))
	print('plant_cell_mouse=',plant_cell_mouse,' | plant_cell_character=', plant_cell_character,' | background_cell=', background_cell,' | interaction_cell=',interaction_cell)
	
	if plant_cell_mouse > 0 and plant_cell_mouse % 2 == 0:
		Global.AddInventoryItem(plant_cell_mouse/2, 1)
		interaction_map.set_cell(int(world_position[0] / cell_size.x), int(world_position[1] / cell_size.y), (plant_cell_mouse-1)) 
		AnimationOnInteraction(1)
		GlobalGameFunctions.SoundOnInteraction(self, "standard")
		Global.Save()
	elif plant_cell_character > 0 and plant_cell_character % 2 == 0:
		Global.AddInventoryItem(plant_cell_character/2, 1)
		interaction_map.set_cell(int(self.position.x / cell_size.x), int(self.position.y / cell_size.y), (plant_cell_character-1)) 
		AnimationOnInteraction(1)
	else:
		pass
	
func _interaction_process():
	world_position = get_global_mouse_position()
	InteractWithCell()

func AnimationOnInteraction(Item):
	print("Item = ", Item, " Animation")
	var itemimage = TextureRect.new()	
	var item = null

func _ready():
	Global.player_inventory_items = Database.GetInventoryItems().duplicate()
	print("Map = ", Global.map_name)
	
