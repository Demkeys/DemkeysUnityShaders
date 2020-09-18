Shader "Unlit/DissolveNoClip"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTexCol ("Texture Color", Color) = (1,1,1,1)
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _AlphaCutOff ("Alpha Cut Off", Range(0,1)) = 1
        _EdgeSize ("Edge Size", Range(0,0.5)) = 0.5
        _EdgeColor ("Edge Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderQueue"="Transparent" }
        LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        CGINCLUDE

        #include "UnityCG.cginc"

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
        fixed4 _MainTexCol;
        sampler2D _NoiseTex;
        fixed _AlphaCutOff;
        fixed _EdgeSize;
        fixed4 _EdgeColor;

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            fixed4 col = tex2D(_MainTex, i.uv);
            fixed4 noise = tex2D(_NoiseTex, i.uv);
            fixed dissolve = lerp(1,0,step(noise.r,_AlphaCutOff));
            fixed dissolve2 = lerp(1,0,step(noise.r,_AlphaCutOff+_EdgeSize));
            col *= _MainTexCol;
            _EdgeColor.rgb = lerp(col.rgb, _EdgeColor.rgb, 
                smoothstep(0,0.1,_AlphaCutOff));
            col.rgb = lerp(_EdgeColor.rgb, col.rgb, dissolve2);
            col.a = dissolve;
            col.a = saturate(col.a);
            return col;
        }
        ENDCG
        // Render inner faces
        Pass
        {
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
        // Render outer faces
        Pass
        {
            Cull Back
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
