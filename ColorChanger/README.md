## Color Changer shader ##

This is shader changes the colors of the texture in fragment shader. For each color channel, you can choose to Switch, Add, Subtract, Multiply or Divide it's value with the R, G, B or A channel's value. After these calculations are done, you can additionally choose to Add, Subtract, Multiply or Divide the result with another color. This shader is meant to be used as a debugging shader, so for example, if you wanna see what a certain model would look like with different colored textures, you can use this shader to test out different color schemes, rather than repainting and attaching a new texture for a different color scheme. That being said, the shader can be used as is, to change the color of your textures, if you wish to do so.

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


TODO: Examples to help you understand how to use the various options.
