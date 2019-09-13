Shader "Custom/UV Visualizer"
{
    Properties
    {
        _MaixTex01 ("Main Texture (white texture if left blank)", 2D) = "white" {}
        [Toggle] _ShowTexture ("ShowTexture", Float) = 0
        [KeywordEnum(Multiply,Add,Subtract,Divide,LerpMin,LerpMax)] 
        _BlendMode ("Texture Blend Mode (if texture is shown)", Float) = 0
    }
    SubShader
    {
        Tags { "RenderQueue"="Geometry" }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MaixTex01;
            float4 _MaixTex01_ST;
            float _BlendMode;
            float _ShowTexture;

            void vert (
                float4 pos : POSITION,
                out float4 opos : SV_POSITION,
                inout float4 texCoord0 : TEXCOORD0
            )
            {
                opos = UnityObjectToClipPos(pos);

                // Texture coordinates without tiling and offset.
                texCoord0.zw = texCoord0.xy;

                // Texture coordinates with tiling and offset.
                texCoord0.xy = texCoord0.xy * _MaixTex01_ST.xy + _MaixTex01_ST.zw;
            }

            fixed4 frag (
                float4 pos : SV_POSITION,
                float4 texCoord0 : TEXCOORD0
            ) : SV_TARGET
            {
                // Convert texture coordinates to color by assigning
                // x and y coordinates to r and g color channels.
                // The texture coordinates being used have not been
                // tiled or offset.
                fixed4 col = fixed4(texCoord0.zw, 0, 1);
                
                fixed4 texCol = tex2D(_MaixTex01, texCoord0.xy);
                
                // If ShowTexture is true, blend col and texCol based
                // on the selected BlendMode.
                if(_ShowTexture)
                {
                    if(_BlendMode == 0) // Multiply
                        col *= texCol;
                    else if(_BlendMode == 1) // Add
                        col += texCol;
                    else if(_BlendMode == 2) // Subtract
                        col -= texCol;
                    else if(_BlendMode == 3) // Divide
                        col /= texCol;
                    else if(_BlendMode == 4) // LerpMin
                        col = lerp(col, texCol, min(col, texCol));
                    else if(_BlendMode == 5) // LerpMax
                        col = lerp(col, texCol, max(col, texCol));
                }
                    
                return col;
            }
            ENDCG
        }
    }
}
