# About Procedural City
Generates a random city, with buildings trees and random terrain.


# Controls: 
Press W,A,S,D, Up, Down, Left, Right to move the camera focus.

The camera is looking at the red line on the Z axis. Press Q to toggle.

Press E to toggle between 3D map, 2D map, 2D noise height map, and 2D population density noise map.

Press G to generate a new map

Click and drag to move the camera, mouse wheel to zoom in.


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
	* Draw main Roads
	* cars?
3. Environment
	* Weather
	* Time of day
	* skybox
	* Texture terrain and trees 

## Top Down View
![alt text](http://imgur.com/uJRC26D.jpg "Top Down View 3D")
## Terrain Height Noise Map
![alt text](http://imgur.com/9WmZ0QG.jpg "Height Map")
## Population Density Noise Map
![alt text](http://imgur.com/BPa5YIl.jpg "Population Density Map")
## 3D view including trees
![alt text](http://imgur.com/KpVAMBK.jpg "Trees and Buildings")
