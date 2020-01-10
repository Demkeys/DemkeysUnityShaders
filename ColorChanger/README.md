## Color Changer shader ##

This is shader changes the colors of the texture in fragment shader. For each color channel, you can choose to Switch, Add, Subtract, Multiply or Divide it's value with the R, G, B or A channel's value. After these calculations are done, you can additionally choose to Add, Subtract, Multiply or Divide the result with another color. You can also choose whether calculations on one color channel affect calculations on another color channel. This shader is meant to be used as a debugging shader, so for example, if you wanna see what a certain model would look like with different colored textures, you can use this shader to test out different color schemes, rather than repainting and attaching a new texture for a different color scheme. That being said, the shader can be used as is, to change the color of your textures, if you wish to do so.

### Properties ###

- __Texture__: Texture to use.
- __Use Color Change?__: Should color change operations be done or not? If false, all operations are ignored, and the texture is not affected.
- __Calculate Channels Independently__: If true, the initial color is stored in a temp buffer, so that calculations done on one channel won't affect calculations done on another channel. If false, the initial color variable is used as is in the calculations. Color channel calculations are done in the following order - R, G, B then A. So whether the color channels are calculated independently or not, affects the result. This will become moer clear in the examples.
- __Red Channel Opeator__: Operator to use when doing calculations on the R channel.
- __Red Channel Operand__: Operand to use when doing calculations on the R channel.
- __Green Channel Opeator__: Operator to use when doing calculations on the G channel.
- __Green Channel Operand__: Operand to use when doing calculations on the G channel.
- __Blue Channel Opeator__: Operator to use when doing calculations on the B channel.
- __Blue Channel Operand__: Operand to use when doing calculations on the B channel.
- __Alpha Channel Opeator__: Operator to use when doing calculations on the A channel.
- __Alpha Channel Operand__: Operand to use when doing calculations on the A channel.
- __Final Color Opeator__: Operator to use when doing calculations on the color produced by previous calculations.
- __Final Color Operand__: Operand to use when doing calculations on the color produced by previous calculations.

Hopefully some examples will help you better understand how to use the properties in the shader. However, if you would rather just experiment by changing options randomly, that works perfectly fine too, because the whole point if this shader is to see what new color schemes you can come up with.

__Example 1__: 
![Example1](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/ColorChanger/ExamplePic1.png)
A simpler example to help you understand the operations and how the values change. In this example the texture has only one color, Red, which in RGB would be (1,0,0). On the left you see the original texture color (red). On the right you see the resulting color after color changing operations (green). Let's take a look at the properties:
Red Channel Operator: Subtract
Red Channel Operand: R
This means the value of R will be subtracted by itself.
Green Channel Operator: Add
Green Channel Operand: R
This means the value of R will be added to the value of G.
Blue Channel Operator: Keep
Blue Channel Operand: B
Since Blue Channel Operator is set to Keep, Blue channel keeps it's value, and no calculation is done. Same for Alpha channel.
Final Color Operator: Multiply
Final Color Operand: White (1,1,1,1)
This leaves the color unaffected because is basically multiplying the values by 1.

The calculation would then go like so...
Initial color RGB value is (1,0,0), which is Red.

`R = R-R = 1-1 = 0`

`G = G+R = 0+1 = 1`

`B = 0`

Thus, the resulting color is Green (0,1,0).

__Example 2__:
Now, notice that Calculate Channels Independently is set to True. Let's set it to false. This is the result.
![Example2](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/ColorChanger/ExamplePic2.png)

Here's a breakdown of the calculation:

`R = R-R = 1-1 = 0`

`G = G+R = 0+0 = 0`

`B = 0`

The resulting color is Black (0,0,0). Notice how the calculation done on the R channel affected the later calculation done on the G channel? That's what Calculate Channels Independently does. The channels are calculated in the order R-G-B-A, so if Calculate Channels Independently is set to False, calculations done on R, will affect later calculations, if the value of R is being used in them.

__Example 3__:
In this example I tried using the shader on the materials attached to Unity-chan. I changed some of the values for the body and hair materials. Here are the values, along with the results:
![Example3_2](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/ColorChanger/ExamplePic3_2.png)
![Example3_1](https://github.com/Demkeys/DemkeysUnityShaders/blob/master/ColorChanger/ExamplePic3_1.png)

