Shader "Custom/01_Unlit"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        // Subshader Tags
        Tags { "RenderType"="Opaque" }

        Pass { // HLSL starting here
            
            //Pass Tags
            
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

            // This struct automatically filled by unity 
            struct MeshData {  // The old name is appData | per-vertex mesh data
                float4 vertex : POSITION;   // local space vertex position
                float3 normals : NORMAL;    // local space normal direction
                float4 tangent : TANGENT;   // tangent direction xyz and tagnent sign w
                float4 color : COLOR;       // vertex colors
                float2 uv0 : TEXCOORD0;      // uv0 coordinates
                float2 uv1 : TEXCOORD1;      // uv1 coordinates
            };

            // from the vertex shader to the fragment shader we pass data with this sturct
            // Look at the vert function. vert function returns Interpolators struct.
            struct Interpolators // renamed from v2f
            {
                float4 vertex : SV_POSITION; // clip space position of vertex
                //float2 uv : TEXCOORD0;       //
            };
            
            // This function is the calculating vertex and return last info to Fragment func.
            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.vertex = v.vertex;  // This can be usefull for postprocessing shaders. Because you usually postprocessing shaders cover entire screen.
                return o;
            }

            
            // This function is the last function before the output. Calculating and returning last status of all fragments. 
            fixed4 frag (Interpolators i) : SV_Target { // SV_Target is the output! You can write multiple target. But not in case.
                return _Color;
            }
            
            ENDCG
        }
    }
}
