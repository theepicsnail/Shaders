Shader "Snail/Minecraft" 
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
			float _Size; 
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform samplerCUBE _CursorTex;


			struct VS_INPUT { float4 vertex : POSITION; };
			struct GS_INPUT { float4 pos    : POSITION; };
			struct FS_INPUT { float4 pos    : POSITION; 
							  float2 uv     : TEXCOORD0; 
							  float2 tileID : POSITION1; // float2(column=face, row=texture id)
							  float3 view   : DIRECTION;  
							  };

			GS_INPUT VS_Main(VS_INPUT v)
			{
				GS_INPUT output = (GS_INPUT)0;
				output.pos =  v.vertex;
				return output;
			}

			// Geometry Shader -----------------------------------------------------

			inline float3 WorldSpaceViewDir( in float3 v ) { 
				return _WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, float4(v,1)).xyz; 
			}

			inline void AppendFace(inout TriangleStream<FS_INPUT> triStream,
									float3 bl, float3 br, float3 tr, in float3 tl,
									FS_INPUT tmp
									) { 
				tmp.uv=float2(0,0);
				tmp.view = WorldSpaceViewDir(bl);
				tmp.pos=UnityObjectToClipPos(bl);
				triStream.Append(tmp);

				tmp.uv=float2(0,1);
				tmp.view = WorldSpaceViewDir(tl);
				tmp.pos=UnityObjectToClipPos(tl);
				triStream.Append(tmp);

				tmp.uv=float2(1,0);
				tmp.view = WorldSpaceViewDir(br);
				tmp.pos=UnityObjectToClipPos(br);
				triStream.Append(tmp);

				tmp.uv=float2(1,1);
				tmp.view = WorldSpaceViewDir(tr);
				tmp.pos=UnityObjectToClipPos(tr);
				triStream.Append(tmp);
				triStream.RestartStrip();
			}

			void cube(inout TriangleStream<FS_INPUT> triStream, float3 cubeOrigin, float size, float data){
			
				float3 xv = float3(1, 0, 0) * size;
				float3 yv = float3(0, 1, 0) * size;
				float3 zv = float3(0, 0, 1) * size;
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
				tmp.tileID = float3(0,0,0);
				tmp.tileID.y = data;
				// Face             AppendFace(stream, bl, br, tr, tl) 
				tmp.tileID.x = 0;	AppendFace(triStream, c4, c0, c2, c6, tmp); // left
				tmp.tileID.x = 1;	AppendFace(triStream, c1, c5, c7, c3, tmp); // right
				tmp.tileID.x = 2;	AppendFace(triStream, c2, c3, c7, c6, tmp); // top
				tmp.tileID.x = 3;	AppendFace(triStream, c4, c5, c1, c0, tmp); // bottom
				tmp.tileID.x = 4;	AppendFace(triStream, c0, c1, c3, c2, tmp); // front
				tmp.tileID.x = 5;	AppendFace(triStream, c5, c4, c6, c7, tmp); // back
			}

			[maxvertexcount(48)] 
			void GS_Main(line GS_INPUT p[2], uint pid : SV_PrimitiveID, inout TriangleStream<FS_INPUT> triStream) 
			{
				/*
					Trail renderers produce verticies like:
					0  2  4  ...
					1  3  5
					<--- movement
					The edges go [0-1] [1-2] [2-3] ...
					with pids of   0     1     2   ...
					width=0 means points 0 and 1 are the same. 2 and 3 are too. etc.
					
					I want to use where the person clicks to render, so thow out the odd
					positions.
				*/
				if(pid%2==1) return;
					
				
				float3 cubeOrigin = floor(p[0].pos/_Size)*_Size; // Snap to grid.
				float3 selectionPosition = frac(p[0].pos/_Size); // 0-1 float3 of location inside the volume.

				// Convert selection position into a float3 of -1 0 or 1 
				selectionPosition = floor(selectionPosition*3)-1;

				// I'm only using the outmost 8 corners for selection, so check that all components are 1 or -1.
				if(dot(selectionPosition, selectionPosition) < 2.9) { 
					// At least one of the components was a 0. Bail
					return;
				}
				
				cube(triStream, cubeOrigin, _Size, 
					// Convert selection position to a texture id. (0-7, same as cube above)
					dot(1,(selectionPosition+1)*float3(.5, 1, 2)));
			}

			float4 FS_Main(FS_INPUT input) : COLOR
			{
				float4 color = float4(1,0,1,1);

				float2 uv = (input.uv + input.tileID.xy)/float2(6,8);
				return tex2D(_MainTex, uv*_MainTex_ST.xy+_MainTex_ST.zw);
			}
			
			// Cursor
			[maxvertexcount(24)] 
			void GS_Cursor_Outside(line GS_INPUT p[2], uint pid : SV_PrimitiveID, inout TriangleStream<FS_INPUT> triStream) 
			{
				if(pid != 1) return;

				float3 cubeDestination = floor(p[0].pos/_Size)*_Size;
				cube(triStream, cubeDestination-0.05*_Size, _Size*1.1, float2(0,1));	
			}

			[maxvertexcount(24)] 
			void GS_Cursor_Inside(line GS_INPUT p[2], uint pid : SV_PrimitiveID, inout TriangleStream<FS_INPUT> triStream) 
			{
				if(pid != 1) return;

				float3 cubeDestination = floor(p[0].pos/_Size)*_Size;
				cube(triStream, cubeDestination+.001, _Size-.002, float2(0,1));	
			}
			
			float4 FS_Cursor(FS_INPUT input) : COLOR
			{
				float2 uv = (input.uv + input.tileID.xy)/float2(6,8);
				return texCUBE(_CursorTex, input.view);
			}
		ENDCG
		

		// Cursor
		// Write background space view
        Pass
        {
			cull front
			zwrite off
			Stencil {
				Ref 1
				Comp always
				Pass replace
	        }
            CGPROGRAM
            #pragma vertex VS_Main
            #pragma geometry GS_Cursor_Outside
            #pragma fragment FS_Cursor
            ENDCG
        }
		// Cut a hole in the stencil where the placed object goes.
        Pass
        {
			zwrite on
			cull front
			Stencil {
				Ref 0
				Comp always
				Pass replace
	        }
            CGPROGRAM
            #pragma vertex VS_Main
            #pragma geometry GS_Cursor_Inside
            #pragma fragment FS_Cursor
            ENDCG
        }

		// Normal MC Renderer
        Pass
        {
			Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
			ZTest less
			ZWrite on
			
			Blend SrcAlpha OneMinusSrcAlpha
			
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

		
		// Debug line
		Pass
        {
            Tags { "RenderType"="Opaque" }
            ZTest always
			Cull off

            CGPROGRAM
				#pragma shader_feature DEBUG_LINE

                #pragma vertex DEBUG_VS_Main
                #pragma fragment DEBUG_FS_Main
                #pragma geometry DEBUG_GS_Main
				struct DEBUG_VS_INPUT
				{
					float4 vertex : POSITION;
				};
                struct DEBUG_GS_INPUT
                {
                    float4  pos     : POSITION;
                };
                struct DEBUG_FS_INPUT
                {
                    float4  color   : COLOR;
                    float4  pos     : POSITION;
                };

				// Vertex Shader ------------------------------------------------
                DEBUG_GS_INPUT DEBUG_VS_Main(DEBUG_VS_INPUT v)
                {
                    DEBUG_GS_INPUT output = (DEBUG_GS_INPUT)0;
                    output.pos =  v.vertex;
                    return output;
                }

                // Geometry Shader -----------------------------------------------------
                [maxvertexcount(3)]
                void DEBUG_GS_Main(line DEBUG_GS_INPUT p[2], 
                            uint pid : SV_PrimitiveID,
                            inout TriangleStream<DEBUG_FS_INPUT> triStream)
                {
					// Skip the joints.
					#ifdef DEBUG_LINE
					if(pid%2==0) return;

					DEBUG_FS_INPUT f;
					f.color = float4(pow(abs(sin(pid*.1 - _Time.y)),100),0,0,1);
					
					f.pos=UnityObjectToClipPos(p[1].pos);
					triStream.Append(f);
					
					f.pos=UnityObjectToClipPos((p[0].pos+p[1].pos)/2) + 0.01;
					triStream.Append(f);
					
					f.pos=UnityObjectToClipPos(p[0].pos);
					triStream.Append(f);
					triStream.RestartStrip();
					#endif
				}

                float4 DEBUG_FS_Main(DEBUG_FS_INPUT input) : COLOR
                {
                    return input.color;
                }
            ENDCG
        }
    } 
	FallBack "Diffuse"
	CustomEditor "MinecraftShaderEditor"
}
