Shader "Custom/03_NormalShowerGlobal"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass { // HLSL starting here
            
            CGPROGRAM
            /*
             * What function is the vertex function, what function is the fragment shader?
             * We are telling here to compiler. Just pointing function name.
             * 
             */
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" // Built in function lib.

            float4 _Color;
               
            struct MeshData {  // The old name is appData | per-vertex mesh data
                float4 vertex : POSITION;   // vertex position
                float3 normals : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
                float2 uv0 : TEXCOORD0;      // uv0 coordinates
                float2 uv1 : TEXCOORD1;      // uv1 coordinates
            };

            // from the vertex shader to the fragment shader we pass data with this sturct
            // Look at the vert function. vert function returns Interpolators struct.
            struct Interpolators // renamed from v2f
            {
                float4 vertex : SV_POSITION; // clip space position of vertex
                //float2 uv : TEXCOORD0;
                float3 normal: TEXCOORD0;
            };
            

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.normal = UnityObjectToWorldNormal(v.normals);
                o.normal = mul(v.normals, (float3x3)unity_WorldToObject);   // Same thing with this function -> UnityObjectToWorldNormal(v.normals) 
                return o;
            }

            

            fixed4 frag (Interpolators i) : SV_Target { // SV_Target is the output! You can write multiple target. But not in case.
                return float4(i.normal, 1);
            }
            
            ENDCG
        }
    }
}
