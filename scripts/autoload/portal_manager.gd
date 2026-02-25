extends Node

var portals: Array[Portal] = []
var connections: Dictionary = {} # Portal -> Portal
var player: CharacterBody3D = null
var player_camera: Camera3D = null


func register(portal: Portal) -> void:
	if portal not in portals:
		portals.append(portal)
	if portal.other_portal:
		connections[portal] = portal.other_portal
		connections[portal.other_portal] = portal


func unregister(portal: Portal) -> void:
	portals.erase(portal)
	connections.erase(portal)
	for key in connections:
		if connections[key] == portal:
			connections.erase(key)


func get_linked(portal: Portal) -> Portal:
	return connections.get(portal, null)


func link(a: Portal, b: Portal) -> void:
	connections[a] = b
	connections[b] = a


func unlink(portal: Portal) -> void:
	var other = connections.get(portal, null)
	connections.erase(portal)
	if other:
		connections.erase(other)
