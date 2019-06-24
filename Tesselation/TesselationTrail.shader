Shader "snail/Tesselation/TesselationTrail" 
{
    Properties 
    {
		[Header(Grid)]
		// Snap to grid size (meters)
        _Center ("Center Point", Vector) = (0,0,-1,0)

		[Header(Textures)]
		_MainTex("Texture (8 rows of 6-wide cubemaps).", 2D) = "white" {}
		_CursorTex("Cursor", CUBE) = "white" {}

		// Super handy guide for prettier properties!
		// https://gist.github.com/keijiro/22cba09c369e27734011
		[Header(Debugging)]
		[Toggle(DEBUG_LINE)]
		_DEBUG("Show trail", Float) = 0
    }

    SubShader 
    {

		CGINCLUDE
			uniform float4 _Center;
			

			struct VS_INPUT { float4 vertex : POSITION; float4 uv : TEXCOORD0; };
			struct GS_INPUT { float4 vertex : POSITION; float4 uv : TEXCOORD0; };
			struct FS_INPUT { float4 vertex : POSITION; float4 uv : TEXCOORD0; };

			GS_INPUT VS_Main(VS_INPUT v)
			{
				GS_INPUT output = (GS_INPUT)0;
				output.vertex =  v.vertex;
				output.uv = v.uv;
				return output;
			}

			// Geometry Shader -----------------------------------------------------
			inline float2 rotate(float2 i, float a) {
				float s = sin(a);
				float c = cos(a);
				return float2(i.x*c - i.y*s, i.x*s + i.y*c);
			}

			[maxvertexcount(48)] 
			void GS_Main(triangle GS_INPUT p[3], uint pid : SV_PrimitiveID, inout TriangleStream<FS_INPUT> triStream) 
			{
				FS_INPUT o;
				for(int rep = -8 ; rep <= 8 ; rep ++) {
					for(int i = 0 ; i < 3 ; i ++) {
						float4 center = float4(_WorldSpaceCameraPos, 0);
						float4 v = p[i].vertex-center;
						v.xz = rotate(v.xz, rep*3.14158/8);
						o.vertex = UnityObjectToClipPos(v+center);
						o.uv = p[i].uv;
						triStream.Append(o);
					}
					triStream.RestartStrip();
				}


			}

			float4 FS_Main(FS_INPUT input) : COLOR
			{
				return float4(sin((input.uv.x+_Time.y)*float3(.6,1,1.6)),1);
			}
		ENDCG
		
		// Normal MC Renderer
        Pass
        {
			Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
			
			Blend SrcAlpha OneMinusSrcAlpha
			CULL off
			Stencil {
	            Ref 1
				Comp notequal 
			}

            CGPROGRAM
            #pragma vertex VS_Main
            #pragma geometry GS_Main
            #pragma fragment FS_Main
            ENDCG
        }
    }
	FallBack "Diffuse"
	CustomEditor "MinecraftShaderEditor"
}
