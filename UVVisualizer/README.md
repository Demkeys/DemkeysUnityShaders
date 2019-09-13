# UV Visualizer Shader #

This shader allows you to visualize a mesh's UV mapping within the Unity Editor. It displays UV coordinated as RGB colors on the mesh. The UV coordinates map to the R and G color channels respectively. UV coordinates can be anything between 0 and 1. Since the coordinates only map to the R and G channels, the B channel is always 0 and A is 1. That being said, you're mostly only gonna see colors created by mixing R and G channels. So...
- (0,0) = Black
- (1,0) = Red
- (0,1) = Green
- (1,1) = Yellow
![](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/UVVisualizer/UVMapping.png)
...and ofcourse, if you toggle the ShowTexture option ON, the color of the texture will be blended with the UV Visualization colors.

### Usage instructions: ###
* Import this shader into your project. Create a material and select the UV Visualizer shader in the shader menu.
* Shader Properties:
  - Main Texture - The texture that you want to apply to the mesh. If left blank, a white texture is used.
  - Show Texture - Whether to show the texture on the mesh or not.
  - Texture Blend Mode - The method to use to blend the UV VIsualization colors and Main Texture. Blend modes available: Multiply, Add, Subtract, Divide, LerpMin and LerpMax. If Show Texture is false, Texture Blend Mode is ignored.

### Here are some examples shows the UV Visualizer shader in use: ###
In each example you'll see two meshes, left using the UV Visualizer shader, right using the Standard shader.
- Cylinder (ShowTexture:False)
![](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/UVVisualizer/Example01.png)
- Cube (ShowTexture:False)
![](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/UVVisualizer/Example02.png)
- Cube (ShowTexture:True, BlendMode:Multiply)
![](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/UVVisualizer/Example03_1.png)
- Cube (ShowTexture:True, BlendMode:Add)
![](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/UVVisualizer/Example04_1.png)

#### ___NOTE: There are other ways to see the UV mapping of a mesh, for example, you could open up the 3D model in a 3D modelling program like Blender, Maya, etc. This shader is meant for situations where you wish to get an idea of what a mesh's UV mapping looks like, right within the Unity Editor. This shader is meant to be used for debugging purposes, not really meant to be used within a game, but you can use it however you'd like.___ ####
