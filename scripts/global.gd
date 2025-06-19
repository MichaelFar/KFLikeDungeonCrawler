extends Node

#Holds important references for access anywhere, please don't spaghettify with this thanks
var camera : Camera3D :
	set(value):
		camera = value
		print("Camera value set")

var player
