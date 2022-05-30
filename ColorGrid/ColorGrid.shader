/* 
Color Grid: This is a grid system consisting of n by n cells. Use opcode, opr1, opr2 and opr3 (packed into op_data) to perform operations of filling cells. The grid system is implemented entirely in the fragment shader. op_data can be set from script to be able to control Color Grid via script.
For testing purposes there's a Debug mode. To enable Debug Mode set GRID_DEBUG to 1. With Debug Mode enabled, instructions can be created and executed in DebugIns method.
If Debug Mode is disabled set grid size by setting Texture's tiling in Inspector.
If Debug Mode is enabled set grid size by setting Debug Grid Size X and Y in Inspector.

NOTE for dev: The final color you're calculating, is the color for the pixel being drawn on the screen. Try not to confuse this with calculations for the color of the grid cell currently being drawn.

*/
Shader "Unlit/ColorGridShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // _GridSize ("Grid Size", Vector) = (0,0,0,0)
        [Header(Debug)]
        _DbgSeed ("Debug Seed", Range(0,255)) = 2
        _DbgGridSize ("Debug Grid Size", Vector) = (4,4,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define GRID_DEBUG 0

            // Used to set ins_arr's size because the size isn't always known at runtime.
            // This is especially useful when setting ins_arr from script.
            #define GRID_INS_MAX_COUNT 100 

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            // float4 _GridSize;
            uint _DbgSeed;
            float4 _DbgGridSize;

            // Color Grid variables
            uint4 ins_arr[GRID_INS_MAX_COUNT]; // Ins array. Set from script.
            uint ins_count; // Total ins in ins_arr. Set from script.
            uint4 op_data; // Op Data (opcode,opr1,opr2,opr3)
            fixed4 cell_color; // Color used when filling a cell
            
            float2 fragUV; // Interpolated UV coords
            uint2 pixelCellPos; // Current pixel pos converted to grid coords.
            uint2 gridSize;
            fixed4 final_color; // Shader output color

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                #if GRID_DEBUG == 0
                o.uv = v.uv * _MainTex_ST.xy;
                #elif GRID_DEBUG == 1
                o.uv = v.uv * _DbgGridSize.xy;
                #endif
                
                return o;
            }

            float remap (float value, float low1, float high1, float low2, float high2)
            {
                return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
            }

            // Set pixel color. This color will be used during draw_pixel_op.
            void set_color_op(uint3 color)
            {
                // Color is range(0-255) so remap to range(0-1).
                cell_color = fixed4(
                    remap((float)color.r, 0, 255, 0, 1),
                    remap((float)color.g, 0, 255, 0, 1),
                    remap((float)color.b, 0, 255, 0, 1),
                    0
                );
            }

            // Draw pixel in color grid.
            void draw_pixel_op(uint2 grid_pos)
            {
                // uint2 pixelCellPos = trunc(fragUV);

                // If pixelCellPos == grid_pos
                if(grid_pos.x == pixelCellPos.x && grid_pos.y == pixelCellPos.y) 
                    final_color = cell_color;

                // DEBUG CODE
                // final_color += cell_color;
            }

            // Draw row of pixels at 'index', starting from 'start'.
            // Index starts at uv(0,0).
            void draw_row_op(uint index, uint start)
            {
                for(uint i = start; i < gridSize.x; i++) draw_pixel_op(uint2(i,index));
            }

            // Draw column of pixels at 'index', starting from 'start'.
            // Index starts at uv(0,0).
            void draw_column_op(uint index, uint start)
            {
                for(uint i = start; i < gridSize.x; i++) draw_pixel_op(uint2(index,i));
            }

            void randomize_grid(uint seed)
            {
                // uint2 pixelCellPos = trunc(fragUV);
                for(uint i = 0; i < gridSize.x; i++)
                {
                    for(uint j = 0; j < gridSize.y; j++)
                    {
                        uint3 rand_col = uint3(
                            remap(frac(sin( dot(trunc(fragUV), float2(12.9898,91.233) )) * seed),
                            0,1,0,255),
                            remap(frac(sin( dot(trunc(fragUV), float2(92.9898,178.233) )) * seed),
                            0,1,0,255),
                            remap(frac(sin( dot(trunc(fragUV), float2(102.9898,38.233) )) * seed),
                            0,1,0,255)
                        );

                        // randomize_grid_op implicitly uses set_color_op. So store the 
                        // current cell_color value in a buffer. Then after the randomize
                        // op completes, set cell_color back to it's previous value.
                        fixed3 tempCol = cell_color;
                        set_color_op(rand_col);
                        draw_pixel_op(uint2(i,j));
                        set_color_op(tempCol);
                    }
                }
            }

            void fill_grid_op()
            {
                for(uint i = 0; i < gridSize.x; i++)
                {
                    for(uint j = 0; j < gridSize.y; j++)
                    {
                        draw_pixel_op(uint2(i,j));
                    }
                }
            }

            // Draws a circe of 'radius' radius at 'pos' position on the Color Grid.
            void draw_circle_op(uint2 pos, uint radius)
            {
                // TODO
            }

            void draw_line_op(uint2 posA, uint2 posB)
            {
                // TODO
            }

            // Decord op_data and execute op using opcode and oprands.
            // NOTE: op_data = (opcode, opr1, opr2, opr3)
            void decode_op_data()
            {
                uint opcode = op_data.r; // OpCode
                uint3 opr = op_data.gba; // Operands (opr1,opr2,opr3)

                switch(opcode)
                {
                    case 0x0: set_color_op(opr); break;
                    case 0x1: draw_pixel_op(uint2(opr.xy)); break;
                    case 0x2: draw_row_op(opr.x,opr.y); break;
                    case 0x3: draw_column_op(opr.x,opr.y); break;
                    case 0x4: randomize_grid(opr.x); break;
                    case 0x5: fill_grid_op(); break;
                    // case 0x6: draw_circle_op(opr.xy, opr.z); break;
                    // TODO: draw_line_op, draw_circle_op
                    default: break;
                } 
            }

            #if GRID_DEBUG == 1
            // Use this method to create and execute instructions in Debug Mode.
            void DebugIns()
            {
                // op_data = uint4(0,170,0,50);
                
                op_data = uint4(4,_DbgSeed,0,0);
                decode_op_data();
                
                op_data = uint4(0,127,0,0);
                decode_op_data();
                op_data = uint4(1,1,1,0);
                decode_op_data();
                op_data = uint4(0,0,127,0);
                decode_op_data();
                op_data = uint4(1,1,2,0);
                decode_op_data();
                op_data = uint4(2,0,0,0);
                decode_op_data();
                op_data = uint4(2,3,1,0);
                decode_op_data();
                // op_data = uint4(0,127,0,127);
                // decode_op_data();
                // op_data = uint4(3,0,2,0);
                // decode_op_data();


                // op_data = uint4(4,_DbgSeed,0,0);
                // decode_op_data();
                // op_data = uint4(6,0,0,0);
                // decode_op_data();


                // op_data = uint4(0,127,0,25);
                // decode_op_data();
                // op_data = uint4(5,0,0,0);
                // decode_op_data();
                // op_data = uint4(0,0,0,0);
                // decode_op_data();
                // op_data = uint4(2,5,0,0);
                // decode_op_data();
            }
            #endif

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col = 0;
                fragUV = i.uv;
                pixelCellPos = trunc(fragUV);
                final_color = 0;
                // cell_color = 0;

                #if GRID_DEBUG == 0
                gridSize = (uint2)_MainTex_ST.xy;

                for(uint j = 0; j < ins_count; j++)
                {
                    op_data = ins_arr[j];
                    decode_op_data();
                }
                #elif GRID_DEBUG == 1
                gridSize = (uint2)_DbgGridSize.xy;

                DebugIns();
                #endif

                col = final_color;
                // col = fixed4(fragUV,0,0);
                // col = fixed4(i.uv,0,0);

                return col;
            }
            ENDCG
        }
    }
}
