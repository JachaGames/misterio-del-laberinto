extends Control

var sceneChanger = SceneChanger

func _on_TextureButton_pressed():
	print('inicio')
	sceneChanger.change_scene("res://world.tscn", 1)
