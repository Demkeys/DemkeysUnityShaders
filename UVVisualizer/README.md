# UV Visualizer Shader #

This shader allows you to visualize a mesh's UV mapping within the Unity Editor. It displays UV coordinated as RGB colors on the mesh. The UV coordinates map to the R and G color channels respectively.


### Usage instructions: ###
* Import this shader into your project. Create a material and select the UV Visualizer shader in the shader menu.
* Shader Properties:
  - Main Texture - The texture that you want to apply to the mesh. If left blank, a white texture is used.
  - Show Texture - Whether to show the texture on the mesh or not.
  - Texture Blend Mode - The method to use to blend the UV VIsualization colors and Main Texture. Blend modes available: Multiply, Add, Subtract, Divide, LerpMin and LerpMax.


#### ___NOTE: There are other ways to see the UV mapping of a mesh, for example, you could open up the 3D model in a 3D modelling program like Blender, Maya, etc. This shader is meant for situations where you wish to get an idea of what a mesh's UV mapping looks like, right within the Unity Editor. This shader is meant to be used for debugging purposes, not really meant to be used within a game, but you can use it however you'd like.___ ####
