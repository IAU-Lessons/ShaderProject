Shader "Custom/21_Textured"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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


            sampler2D _MainTex;
            float4 _MainTex_ST; // optional :: texture scale and offset values
            
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
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x += _Time.y * 0.1;
                return o;
            }

            float4 frag (InterPolators i) : SV_Target {
                float2 topDownProjection = i.worldPos.xz; // Top to down projection !
                float4 col = tex2D(_MainTex, topDownProjection);
                return col; 
            }
            ENDCG
        }
    }
}
