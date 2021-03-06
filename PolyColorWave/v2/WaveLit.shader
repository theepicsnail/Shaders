
Shader "snail/PolyColorWave/v2/WaveLit" {
	
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Palette ("Color Palette", 2D) = "white" {}
		_PaletteIntensity("Color intensity", Range(0,1)) = .5
		_FlashColor("Flash Color", Color) = (1,1,1,1)
		
		// Wave fronts come by every _Speed seconds.
		_Speed("Speed", Float) = .1

		// The slope controls propigation of the wave down the UVs
		_Slope("Slope", Float) = .1

		// Noise is added to the wave front. 0 = no noise, 1 = all noise
		_Noise("Wave Noise", Range(0,1)) = .1

		// Flash length is the percentage of the wave front spent on the flash.
		_FlashLength("Flash Length", Range(0,1)) = .0333

		[Header(Rendering)]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull [Back]", Float) = 2
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend [One]", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DestBlend [Zero]", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest [LessEqual]", Float) = 4
        [Enum(Off,0,On,1)] _ZWrite("ZWrite [On]", Float) = 1

		[Header(Lighting)]
		_Shadow("Shadow ramp", 2D) = "white" {}
    }

    SubShader
    {
		
        //Tags { "RenderType" = "Opaque"}
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }
		
        LOD 100
        Blend[_SrcBlend][_DstBlend]
        ZTest[_ZTest]
        ZWrite[_ZWrite]
        Cull[_Cull]


        Pass
        {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag  
            #pragma geometry geom
			#pragma multi_compile_fwdbase
			#include "UnityCG.cginc"

			uniform float4 _FlashColor;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform sampler2D _Palette;
            uniform sampler2D _Shadow;
			uniform float _PaletteIntensity;
			uniform float _Speed;
			uniform float _FlashLength;
			uniform float _Noise;
			uniform float _Slope;

			float random (in float st) {
				return frac(cos(st * 12345.6543) * 43758.5453123);
			}
 
            struct v2g
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 lighting : COLOR;
            };
 
            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 col : COLOR;
				float3 lighting : COLOR1;
            };
			
			
            v2g vert (appdata_base v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				
				float3 normal = normalize(mul(unity_ObjectToWorld, float4(v.normal.xyz,0)));
				o.lighting.xyz = max(0,ShadeSH9(float4(normal, 1))) +
								Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                                    unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                                    unity_4LightAtten0, 
									normalize(mul(unity_ObjectToWorld, float4(v.vertex.xyz,1))),
									normal
									);

                return o;
            }
			
            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], uint id:SV_PrimitiveID, inout TriangleStream<g2f> tristream)
            {
				float2 mid = (IN[0].uv + IN[1].uv + IN[2].uv)/3;
				float hash = random(id);

				float time = _Time.y * _Speed + lerp(IN[0].uv.y, hash, _Noise) * _Slope;

				float colorId = floor(time);
				float percent = frac(time);

				float3 color = tex2Dlod(_Palette, float4(random(colorId), random(colorId*2), 0, 0));
				float flash = lerp(0, 1.0-percent/(_FlashLength+.00001), percent< _FlashLength);

				g2f o;
				
				for(int i = 0 ; i < 3 ; i ++) {
					o.pos = UnityObjectToClipPos(IN[i].vertex);
					o.uv = IN[i].uv;
					o.col.rgb = color;
					o.col.a = flash;
					
					o.lighting = IN[i].lighting;

                    tristream.Append(o);
				}
                tristream.RestartStrip();
			}
           
            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= lerp(1, i.col.rgb, _PaletteIntensity);
				
				return lerp(col, _FlashColor, i.col.a * _FlashColor.a)
					 * lerp(.2, 1, float4(tex2D(_Shadow, length(i.lighting))))
				;
            }

            ENDCG
        }
		
		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
