extends Control

func _ready() -> void:
	GodotRemote.connect("device_added",Callable(self,"device_added"))

func device_added():
	print(GodotRemote.get_output_device().get_custom_input_scene())
	GodotRemote.get_output_device().connect("user_data_received",Callable(self,"user_data_received"))

func user_data_received(packet_id, user_data):
	print("Received packet: %s, data: %s" % [packet_id, user_data])
	match packet_id:
		"bg_color": RenderingServer.set_default_clear_color(user_data)

func _on_HSlider_value_changed(value: float) -> void:
	GodotRemote.get_output_device().send_user_data("slider_value", value, false)
