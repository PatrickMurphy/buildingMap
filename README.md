# About Procedural City
Generates a random city, with buildings trees and random terrain.


# Controls: 
Press W,A,S,D, Up, Down, Left, Right to move the camera focus.

The camera is looking at the red line on the Z axis. Press Q to toggle.

Press E to toggle between 3D map, 2D noise height map, and 2D population density noise map.

Click and drag to move the camera.


# Code Settings
There are some parameters to play with in `mapBuilding.pde`: 

` // Settings`

` int maxBuildings = 150;`

` int maxTrees = 75;`

` int mapHeightScale = 25*cellScale;`

# TODO:
1. Buildings
	* Optimize Random building geometry (Don't draw hidden stuff)
	* add more building type variety
2. City
	* Draw Roads
	* cars?
3. Environment
	* Weather
	* Time of day
	* skybox
	* Texture terrain and trees 