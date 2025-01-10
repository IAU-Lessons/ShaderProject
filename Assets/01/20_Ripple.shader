Shader "Custom/20_Ripple"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1)) = 1
        _ColorEnd ("Color End", Range(0,1)) = 1
        _AnimationSpeed ("Animation Speed", Float) = 0.1
        _WaveAmp ("Wave Amplitude", Range(0, 0.2)) = 0.1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"  // This is just a tag for informing Rendering Pipeline of type of shader.
        }

        Pass { // HLSL starting here
                        
            CGPROGRAM
            /*
             * What function is the vertex function, what function is the fragment shader?
             * We are telling here to compiler. Just pointing function name.
             * 
             */
            #pragma vertex vert
            #pragma fragment frag

            // This is just a preprocessor define. Not special.
            // But the number is special. Search it TAU value.
            #define TAU 6.28318530718
            
            #include "UnityCG.cginc" // Built in function lib.
            
            float4 _ColorA;
            float4 _ColorB;
            
            float _ColorStart;
            float _ColorEnd;

            float _AnimationSpeed;
            float _WaveAmp;
            
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
                float2 uv : TEXCOORD1;
                float3 normal: TEXCOORD0;
            };


            float GetRippleWave(float2 uv) {
                // Ripple Effect - Distance From The Distance
                float2 uvsCentered = uv * 2 -1;
                float radialDistance = length(uvsCentered);
                //return float4(radialDistance.xxx,1);
                
                float wave = cos((radialDistance - _Time.y * _AnimationSpeed) * TAU * 5) * 0.5 + 0.5;
                wave *= 1-radialDistance;
                return wave;
            }
            

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                //float wave = cos((v.uv0.y - _Time.y * _AnimationSpeed) * TAU * 5);
                v.vertex.y = GetRippleWave(v.uv0) * _WaveAmp;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }
            


            fixed4 frag (Interpolators i) : SV_Target { // SV_Target is the output! You can write multiple target. But not in case.
                return GetRippleWave(i.uv);
            }
            
            ENDCG
        }
    }
}
