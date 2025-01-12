Shader "Custom/01_Unlit"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass { 
            

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" // Built in function lib.



            //  This function is builtin. you can find it with lerp name
            //  this is just showing math func.
            float Lerp(float a, float b, float t)
            {
                return (1.0 - t) * a + b *t;    
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

            float Remap(float iMin, float iMax, float oMin, float oMax, float v)
            {
                float t = InverseLerp(iMin, iMax, v);
                return Lerp(oMin, oMax, t);
            }
            

            struct MeshData { 
            };
            
            struct Interpolators
            {
            };
            
            Interpolators vert (MeshData v)
            {
                Interpolators o;
                return o;
            }

            
            float frag (Interpolators i) : SV_Target { 
                return 0;
            }
            
            ENDCG
        }
    }
}
