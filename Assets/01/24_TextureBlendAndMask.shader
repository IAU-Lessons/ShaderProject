Shader "Custom/24_TextureBlendAndMask"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Sand ("Sand", 2D) = "white" {}
        _Pattern ("Pattern", 2D) = "white" {}
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

            #define TAU 6.28318530718
            
            sampler2D _MainTex;
            float4 _MainTex_ST; // optional :: texture scale and offset values

            sampler2D _Sand;

            sampler2D _Pattern;
            
            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct InterPolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            InterPolators vert (MeshData v) {
                InterPolators o;
                // object to world conversation
                o.worldPos = mul( UNITY_MATRIX_M, float4(v.vertex) ) ; // unity_ObjectToWorld = UNITY_MATRIX_M => unity modal matrix    
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }


            float4 frag (InterPolators i) : SV_Target {
                float2 topDownProjection = i.worldPos.xz; // Top to down projection !
                float4 grass = tex2D(_MainTex, topDownProjection);
                float4 sand = tex2D(_Sand, topDownProjection);
                float pattern = tex2D(_Pattern, i.uv).x;


                float4 finalColor = lerp(sand, grass, pattern);
                    
                
                return finalColor; 
            }
            ENDCG
        }
    }
}
