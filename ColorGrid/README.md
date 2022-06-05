## Color Grid

![](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/ColorGrid/ColorGridScreenshot.png)

A programmable color grid implemented in a fragment shader. The color grid executes instructions to perform operations. 

Instruction format - (OpCode, Operand1, Operand2 and Operand3).

Currently supported OpCodes:
* 0 = set_color_op - Set current color. This color will be used when coloring pixels on the grid.
* 1 = draw_pixel_op - Color a cell at (x,y) position. Params: x=opr1, y=opr2
* 2 = draw_row_op - Fill row of cells at index. Params: index=opr1
* 3 = draw_column_op - Fill column of cells at index. Params: index=opr1
* 4 = randomize_grid - Fill each grid cell with a random color using seed for randomization. Params: seed=opr1
* 5 = fill_grid_op - Fill all grid cells with current color.
More operations might be added in the future.

Color Grid has two modes: Normal and Debug. To enable debug mode set GRID_DEBUG to 1. In Debug mode you can set type out instructions directly in the shader without having to set it via script.

* Normal Mode:
    * Set ins_arr via script. This is a Vector4 array containing instructions.
    * Set ins_count via script. This is the total number of instructions.
    * Set grid size by setting _MainTex's tiling, either via script, or in Inspector.
    * Color Grid will execute instructions from ins_arr.
* Debug Mode:
    * In DebugIns() method:
        * Set op_data value. This is the instruction to execute.
        * Call decode_op_data().
        * Repeat above two steps for every instruction.
    * Set grid size by setting _DbgGridSize x and y values in Inspector.
    * If using randomize_grid op, set _DbgSeed value in Inspector.
    * Color Grid will call DebugIns() method to execute instructions.

To use Color Grid:
* Create a material and attach the shader to the material.
* Create a Quad in the scene and attach the material to the quad.

___NOTE: The Color Grid is implemented in the fragment shader, so the more pixels the rendered mesh is occupying on screen, the heavier the shader will become. This means that at bigger resolutions the shader can get heavier when the camera is close to the mesh. To get around this issue, use another camera to render the quad to a render texture, then use that render texture wherever. This way you can also have multiple copies of that Color Grid to display in multiple places.___
