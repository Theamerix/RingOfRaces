extends Node2D

var ShowInventory = 0
var LeftClick = 0
var player_inventory_items = []
var loadedscenes = {"RiverIntersectionHome":"res://Maps/river_intersection_home.tscn"}
var loadgame_screen = null
var current_scene = null
var current_camera = null
var dev_stats = true
var dbname = "storage.db"
var mainscene = ""
var base_tilemap = preload("res://Other/base_tilemap/base_tilemap.tscn")
var map_name

func load_scene(map_data):
	map_name = map_data
	var scene = load(map_data+".tscn")
	print("MAP NAME ",map_data+".tscn")
	return scene.instantiate()

func AddInventoryItem(itemid, amount):
	for x in range(40):
		if(player_inventory_items[x].item_id == itemid):
			print(str(player_inventory_items[x]))
			player_inventory_items[x].amount += amount
			return
	#if we reached here then no exisiting item is found and we iterate the array again
	print("adding item")
	for x in range(40):
		if(player_inventory_items[x].item_id == 0):
			player_inventory_items[x].id = x
			player_inventory_items[x].item_name = "name"
			player_inventory_items[x].shortdesc = "desc"
			player_inventory_items[x].item_id = itemid
			player_inventory_items[x].amount = amount
			return

#Add scene as child
func AddScene(scene):
	print("Adding scene ", scene)
	var camera = get_node("/root/base_scene/Camera2D")
	var addedscene = load(scene).instantiate()
	addedscene.set_position(Vector2(-617,-300))
	camera.add_child(addedscene)

# Remove the child
func RemoveScene(scene):
	print("Removing scene ", scene)
	var camera = get_node("/root/base_scene/Camera2D")
	camera.remove_child(scene)
	
func AddMap(load_on, mapname):
	for _i in get_parent().get_children():
		print("Nodes visible before addMap ", _i)
	print("Adding map ", mapname)
	var addedscene = load(mapname).instantiate()
	#addedscene.set_position(Vector2(-617,-300))
	get_parent().add_child(addedscene)
	for _i in get_parent().get_children():
		print("Nodes visible at addMap ", _i)
#	var maps = load(mapname).instantiate().get_children()
#	for i in maps:
#		load_on.add_child(i)
#		print('Added ', i)
#
#		#There's a chance that 1) this is an on-load problem 2) the nodes never get instanced/loaded
#		for _i in self.get_children():
#			print("Nodes visible at addMap ", _i)

#Go to scene by name
func GoToScene(scene):
	print("Going to scene ", scene)
	var nextscene = load(scene)
	get_tree().change_scene_to_packed(nextscene)

func LoadSave(target="Storage.db"):
	dbname = target
	Database.OpenConnection()

#Save everything
func Save():
	Database.SaveInventory(player_inventory_items)
	print(player_inventory_items)

func Log(msg, level=1):
	match level:
		1:
			print("[Log]" + msg)
		2:
			print("[Warn]" + msg)
		3:
			print("[Err]" + msg)
