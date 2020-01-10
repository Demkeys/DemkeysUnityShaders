Shader "Custom/ColorChanger"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "red" {}

        [Toggle] _UseColorChange ("Use Color Change?", Float) = 1
        [Toggle] _UseTempBuffer ("Calculate Channels Independently", Float) = 1

        [Header(Red Channel Operations)]
        [KeywordEnum(Keep,Switch,Add,Subtract,Multiply,Divide)] _R_Op ("Red Channel Operator", Float) = 0
        [KeywordEnum(R,G,B,A)] _R ("Red Channel Operand", Float) = 0
        
        [Header(Green Channel Operations)]
        [KeywordEnum(Keep,Switch,Add,Subtract,Multiply,Divide)] _G_Op ("Green Channel Operator", Float) = 0
        [KeywordEnum(R,G,B,A)] _G ("Green Channel Operand", Float) = 1
        
        [Header(Blue Channel Operations)]
        [KeywordEnum(Keep,Switch,Add,Subtract,Multiply,Divide)] _B_Op ("Blue Channel Operator", Float) = 0
        [KeywordEnum(R,G,B,A)] _B ("Blue Channel Operand", Float) = 2
        
        [Header(Alpha Channel Operations)]
        [KeywordEnum(Keep,Switch,Add,Subtract,Multiply,Divide)] _A_Op ("Alpha Channel Operator", Float) = 0
        [KeywordEnum(R,G,B,A)] _A ("Alpha Channel Operand", Float) = 3

        [Header(Final Color Operation)]
        [KeywordEnum(Add,Subtract,Multiply,Divide)] _FinalColOp ("Final Color Operator", Float) = 2
        _FinalColOperand ("Final Color Operand", Color) = (1,1,1,1)
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _UseColorChange; float _UseTempBuffer;
            float _R_Op; float _G_Op; float _B_Op; float _A_Op; 
            float _R; float _G; float _B; float _A; 
            float _FinalColOp; float4 _FinalColOperand;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            void ColorChannelOp(float Op, inout float Val1, float Val2)
            {
                if(Op==0) return; //Keep
                else if(Op==1) Val1 = Val2; // Switch
                else if(Op==2) Val1 += Val2; // Add
                else if(Op==3) Val1 -= Val2; // Sub
                else if(Op==4) Val1 *= Val2; // Mul
                else if(Op==5) Val1 /= Val2; // Div
            }

            void ChooseColorChannel(float channelOp, float outColorCh, inout float inColorCh, float4 inColor)
            {
                if(outColorCh==0) ColorChannelOp(channelOp, inColorCh, inColor.r); 
                else if(outColorCh==1) ColorChannelOp(channelOp, inColorCh, inColor.g); 
                else if(outColorCh==2) ColorChannelOp(channelOp, inColorCh, inColor.b); 
                else if(outColorCh==3) ColorChannelOp(channelOp, inColorCh, inColor.a); 
            }

            void FinalColorOp(float colorOp, inout float4 inCol, float4 colOperand)
            {
                if(colorOp==0) inCol += colOperand; // Add
                else if(colorOp==1) inCol -= colOperand; // Subtract
                else if(colorOp==2) inCol *= colOperand; // Multiply
                else if(colorOp==3) inCol /= colOperand; // Divide
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                
                if(_UseColorChange)
                {
                    if(_UseTempBuffer==1)
                    {
                        // Temp buffer to store initial color value, since col will be affected
                        // during calculations.
                        float4 tempBuffer = col;

                        ChooseColorChannel(_R_Op, _R, col.r, tempBuffer);
                        ChooseColorChannel(_G_Op, _G, col.g, tempBuffer);
                        ChooseColorChannel(_B_Op, _B, col.b, tempBuffer);
                        ChooseColorChannel(_A_Op, _A, col.a, tempBuffer);
                    }
                    else
                    {
                        ChooseColorChannel(_R_Op, _R, col.r, col);
                        ChooseColorChannel(_G_Op, _G, col.g, col);
                        ChooseColorChannel(_B_Op, _B, col.b, col);
                        ChooseColorChannel(_A_Op, _A, col.a, col);
                    }
                    FinalColorOp(_FinalColOp, col, _FinalColOperand);
                }

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
