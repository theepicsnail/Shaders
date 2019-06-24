// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_CameraToWorld' with 'unity_CameraToWorld'

// Upgrade NOTE: replaced '_CameraToWorld' with 'unity_CameraToWorld'

Shader "snail/Minecraft/MC" 
{
    Properties 
    {
		[Header(Grid)]
		// Snap to grid size (meters)
        _Size ("StepSize", Range(0, .5)) = 0.1

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
			#include "UnityCG.cginc"
			float _Size; 
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform samplerCUBE _CursorTex;


			struct VS_INPUT { float4 vertex : POSITION; };
			struct GS_INPUT { float4 pos    : POSITION; };
			struct FS_INPUT { float4 pos    : POSITION;
							  float4 color  : COLOR;
							  float3 worldPos : POSITION1;
							  float3 origin: POSITION2;
							  float3 normal: NORMAL;
							  };
			struct FS_OUTPUT {
				float4 color : SV_Target;
				float depth : SV_Depth;
            };     

			GS_INPUT VS_Main(VS_INPUT v)
			{
				GS_INPUT output = (GS_INPUT)0;
				output.pos =  v.vertex;
				return output;
			}

			// Geometry Shader -----------------------------------------------------
			inline void AppendFace(inout TriangleStream<FS_INPUT> triStream,
									float3 bl, float3 br, float3 tr, in float3 tl,
									FS_INPUT tmp
									) { 

				tmp.normal = -normalize(cross(br-bl, tl-bl));
				tmp.worldPos =bl;// mul(unity_ObjectToWorld, bl);
				tmp.pos=UnityObjectToClipPos(bl);
				triStream.Append(tmp);
				
				tmp.worldPos =tl;// mul(unity_ObjectToWorld, tl);
				tmp.pos=UnityObjectToClipPos(tl);
				triStream.Append(tmp);
				
				tmp.worldPos = br;//mul(unity_ObjectToWorld, br);
				tmp.pos=UnityObjectToClipPos(br);
				triStream.Append(tmp);
				
				tmp.worldPos = tr;//mul(unity_ObjectToWorld, tr);
				tmp.pos=UnityObjectToClipPos(tr);
				triStream.Append(tmp);

				triStream.RestartStrip();
			}

			void lego_volume(inout TriangleStream<FS_INPUT> triStream, float3 cubeOrigin, float3 scale) {
				// A lego is a 5x6x5 ratio block where the extra height is the peg that plugs into the above brick.

				float3 xv = float3(1, 0, 0) * scale;
				float3 yv = float3(0, 1, 0) * scale * 6 / 5;
				float3 zv = float3(0, 0, 1) * scale;
				// corners
				//    6----7
				//   /|   /|
				//  2----3 |
				//  | 4--|-5   y z
				//  |/   |/    |/
				//  0----1     .--x
				float3 c0 = cubeOrigin;
				float3 c1 = cubeOrigin + (xv          );
				float3 c2 = cubeOrigin + (     yv     );
				float3 c3 = cubeOrigin + (xv + yv     );
				float3 c4 = cubeOrigin + (        + zv);
				float3 c5 = cubeOrigin + (xv      + zv);
				float3 c6 = cubeOrigin + (     yv + zv);
				float3 c7 = cubeOrigin + (xv + yv + zv);
				
				FS_INPUT tmp;
				tmp.origin = cubeOrigin;
				tmp.color = float4(1,0,0,1);
				AppendFace(triStream, c4, c0, c2, c6, tmp); // left
				AppendFace(triStream, c1, c5, c7, c3, tmp); // right
				AppendFace(triStream, c2, c3, c7, c6, tmp); // top
				AppendFace(triStream, c4, c5, c1, c0, tmp); // bottom
				AppendFace(triStream, c0, c1, c3, c2, tmp); // front
				AppendFace(triStream, c5, c4, c6, c7, tmp); // back

			}

			[maxvertexcount(48)] 
			void GS_Main(line GS_INPUT p[2], uint pid : SV_PrimitiveID, inout TriangleStream<FS_INPUT> triStream) 
			{
				float3 cubeOrigin = floor(p[0].pos/_Size)*_Size; // Snap to grid.
				float3 selectionPosition = frac(p[0].pos/_Size); // 0-1 float3 of location inside the volume.

				// Convert selection position into a float3 of -1 0 or 1 
				selectionPosition = floor(selectionPosition*2)*2-1;

				// I'm only using the outmost 8 corners for selection, so check that all components are 1 or -1.
				if(dot(selectionPosition, selectionPosition) < 2.9) { 
					// At least one of the components was a 0. Bail
					return;
				}
				
				lego_volume(triStream, cubeOrigin, _Size);
			}

			
			/*
			float signedDistanceField (float3 pos)
			{
				pos += 100;
				#define SPHERE_RADIUS 0.3
				#define SPHERE_REPETITION 0.8
				pos = fmod(pos, SPHERE_REPETITION) - 0.5*SPHERE_REPETITION;
				return length(pos) - SPHERE_RADIUS;
			}			
			void raymarch (float3 rayStart, float3 rayDir, out float4 color, out float clipDepth)
			{
				color = float4(0,0,0,0);
				int maxSteps = 40;
				float minDistance = 0.001;
				float3 currentPos = rayStart;
				for (int i = 0; i < maxSteps; i++)
				{
					float distance = signedDistanceField(currentPos);
					currentPos += rayDir * distance;
					if (distance < minDistance)
					{
						color = float4((40-i)*0.025, (40-i)*0.025, (40-i)*0.025, 1);
						break;
					}
				}
				float4 clipPos = mul(UNITY_MATRIX_VP, float4(currentPos, 1.0));
				clipDepth = clipPos.z / clipPos.w;
			}
			struct fragOut 
			{
				float4 color : SV_Target;
				float depth : SV_Depth;
			};

			fragOut frag (FS_INPUT i)
			{
				float3 rayStart = i.worldPos.xyz;;
				float3 rayDir = normalize(rayStart - _WorldSpaceCameraPos);
				float4 rayColor;
				float clipDepth;
				raymarch(rayStart, rayDir, rayColor, clipDepth);

				fragOut f;
				f.depth = clipDepth;
				f.color = rayColor;
				return f;
			}
			*/
            

			FS_OUTPUT FS_Main(FS_INPUT input) : COLOR
			{
			
				FS_OUTPUT o;
				float3 legoPos = (input.worldPos - input.origin) / _Size;
				
				float3 cam = _WorldSpaceCameraPos;
				float3 normal = input.normal;
				float3 viewDir = normalize(input.worldPos- cam);
				
				float dist = length(input.worldPos - cam);
				
				
				float3 currentPos = input.worldPos;
				float4 clipPos = mul(UNITY_MATRIX_VP, float4(currentPos, 1.0));
				o.depth = clipPos.z / clipPos.w;
				

				o.color = float4(o.depth.xxx,1);
				return o;
				


				/*


				float3 lighting = max(0,
					ShadeSH9(float4(normal, 1.0))) +
					Shade4PointLights(
						unity_4LightPosX0, 
						unity_4LightPosY0,
						unity_4LightPosZ0,
						unity_LightColor[0].rgb,
						unity_LightColor[1].rgb,
						unity_LightColor[2].rgb,
						unity_LightColor[3].rgb,
                        unity_4LightAtten0, 
						input.worldPos,
						normal);

				// color for everything except the peg sides. 
				o.color = float4(lighting,1) * input.color;

				// walls/bottom
				if(legoPos.y < 1)
					return o;
				// peg top
				//if(length(legoPos.xz - .5) < .3)
				//	return color;
				
				// top plane intersection
				float plane_dist = ((1-legoPos.y)/viewDir.y);
				float3 plane_pos = legoPos + viewDir *plane_dist;
				float hit_plane = 
					abs(length(saturate(plane_pos.xz)-plane_pos.xz))<.01;



				// 'peg' intersection
				float a = dot(viewDir, viewDir);
				float3 sr = legoPos - float3(.5,1,.5);
				float b = 2 * dot(viewDir, sr);
				float c = dot(sr, sr) - dot(_Size*.4, _Size*.4);
				float det = b*b-4*a*c;
					normal = float3(0,1,0);
				if(det < 0) {
					clip(hit_plane-.01);
				} else {
					float dist = (-b - sqrt((b*b) - 4.0*a*c))/(2.0*a);
					float3 pos = legoPos + viewDir * dist;
					if(pos.y > 1)
					normal = (legoPos + viewDir * dist) - float3(.5, 1, .5);
				}
				o.color = float4(max(0,
					ShadeSH9(float4(normal, 1.0))) +
					Shade4PointLights(
						unity_4LightPosX0, 
						unity_4LightPosY0,
						unity_4LightPosZ0,
						unity_LightColor[0].rgb,
						unity_LightColor[1].rgb,
						unity_LightColor[2].rgb,
						unity_LightColor[3].rgb,
                        unity_4LightAtten0, 
						input.worldPos,
						normal),1) * input.color;
				return o;
				//float3 top = legoPos + viewDir *plane_dist;
				//return o;//float4(frac(top.xz), 0, 1);
				//return input.color;
				*/
			}
		ENDCG
		
		// Normal MC Renderer
        Pass
        {
			Tags {"Queue"="Opaque"}
			
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
