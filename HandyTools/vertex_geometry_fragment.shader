Shader "Snail/VGF" 
{
    Properties 
    {
		_MainTex("Main Texture", 2D) = "white" {}

		// Super handy guide for prettier properties!
		// https://gist.github.com/keijiro/22cba09c369e27734011
    }

    SubShader 
    {
    	CGINCLUDE
    		// Anything common to all passes goes here.
    		#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
    	ENDCG

    	Pass {
    		// https://docs.unity3d.com/Manual/SL-CullAndDepth.html
			CGPROGRAM

				/* Reference from UnityCG.cginc
				struct appdata_full {
			    	float4 vertex : POSITION;
				    float4 tangent : TANGENT;
			    	float3 normal : NORMAL;
			    	float4 texcoord : TEXCOORD0;
			    	float4 texcoord1 : TEXCOORD1;
				    float4 texcoord2 : TEXCOORD2;
			    	float4 texcoord3 : TEXCOORD3;
		    		fixed4 color : COLOR;
		    		UNITY_VERTEX_INPUT_INSTANCE_ID
				};
				*/

				struct VS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
				};
				struct GS_INPUT { 
					float4 vertex    : POSITION; 
					float4 uv : TEXCOORD0;
				};
				struct FS_INPUT { 
					float4 vertex    : POSITION; 
					float2 uv     : TEXCOORD0;  
				};


				// Pass through vertex shader
				#pragma vertex VS_Main
				GS_INPUT VS_Main(VS_INPUT input)
				{
					GS_INPUT output = (GS_INPUT)0;
					// Convert from model to world space.
					output.vertex =  UnityObjectToClipPos(input.vertex);
					output.uv = input.uv;
					return output;
				}


				// Pass through geometry shader.
				// Reference for GS input/output types.
				// https://msdn.microsoft.com/en-us/library/windows/desktop/bb509609(v=vs.85).aspx
                #pragma geometry GS_Main
				[maxvertexcount(3)] 
				void GS_Main(triangle GS_INPUT input[3], 
							 // uint pid : SV_PrimitiveID, 
							 inout TriangleStream<FS_INPUT> stream) {

					FS_INPUT output = (FS_INPUT) 0;
					for(uint i = 0 ; i < 3; i++){
						output.vertex = input[i].vertex;
						output.uv = input[i].uv;
						stream.Append(output);
					}
				}

				// Plain texture
                #pragma fragment FS_Main
				float4 FS_Main(FS_INPUT input) : COLOR
				{
					return tex2D(_MainTex, input.uv);
				}
			ENDCG
		}
    } 
	FallBack "Diffuse"
}
