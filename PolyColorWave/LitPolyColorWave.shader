Shader "Snail/LitPolyColorWave" {
	
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Saturation ("Saturation", Range(0, 1)) = 1
		_Value ("Value", Range(0, 1)) = 1
		_Noise ("Noise", Range(0, 1)) = .1

        [Header(Rendering)]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2 //"Back"
    }
    SubShader
    {
		Tags {
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
			"IsEmissive" = "true"  }
        ZWrite off
		Blend SrcAlpha OneMinusSrcAlpha
        Cull[_Cull]
        
        Pass
        {
			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag  
            #pragma geometry geom
			#pragma multi_compile_fwdbase
			#include "UnityCG.cginc"
	
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
			uniform float _Saturation;
			uniform float _Value;
			uniform float _Noise;

            float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, clamp( p - K.xxx, 0.0, 1.0 ), c.y );
			}

			float3 getColor(float f) {
				return HSVToRGB(float3(f*1.618, _Saturation, _Value));
			}

			float getTime(float phase, float step) {
				float t = (_Time.y + phase) * .1;
				return t - frac(t) * step;
			}


			float random (in float2 st) {
				return frac(
					cos(dot(st, float2(12.9898, 78.233)))
					* 43758.5453123
				);
			}
 
            struct v2g
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
 
            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 col : COLOR;
            };
			
			
            v2g vert (appdata_base v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.normal = v.normal;
                return o;
            }
			
            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], uint id:SV_PrimitiveID, inout TriangleStream<g2f> tristream)
            {
				float2 mid = (IN[0].uv + IN[1].uv + IN[2].uv)/3;
				float hash = random(id*.1);
				float3 pos = mul(unity_ObjectToWorld, mid);
				
				float v = getTime(lerp(IN[0].uv.y, hash, _Noise), 0);
				float3 color = getColor(floor(v));
				float flash = 1-saturate(frac(v) * 30);

				g2f o;
				for(int i = 0 ; i < 3 ; i ++) {
					o.pos = UnityObjectToClipPos(IN[i].vertex);
					o.uv = IN[i].uv;
					o.col.rgb = color;
					o.col.a = flash;
                    tristream.Append(o);
				}
                tristream.RestartStrip();
			}
           
            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= i.col.rgb;
				//clip(col.a-0.01);
				return lerp(col, fixed4(1,1,1,col.a), i.col.a);
            }

            ENDCG
        }
		
		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
