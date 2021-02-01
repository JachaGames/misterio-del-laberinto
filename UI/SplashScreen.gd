extends Control

var sceneChanger = SceneChanger


func _ready():
	sceneChanger.change_scene("res://UI/MainMenu.tscn", 4)
