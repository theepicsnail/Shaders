// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Snail/Shaders/PointCloud" 
{
    Properties 
    {
		// Super handy guide for prettier properties!
		// https://gist.github.com/keijiro/22cba09c369e27734011
		_MainTex("Texture", 2D) = "white" {}
    	_SCALE("Scale", Float) = 0 
    	_DIST("Dist", Float) = 1
    	_ITER_SCALE("Iter scale", Float) = 1

    }

    SubShader 
    {
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
		}
    	CGINCLUDE
    		#include "UnityCG.cginc"
    		#include "../ShaderUtils/Inlines.cginc"
    		#include "../ShaderUtils/Noise.cginc"
    		uniform float _SCALE;
    		uniform float _DIST;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _ITER_SCALE;
    	ENDCG

    	Pass {
	        ZWrite Off
	        Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
            	#pragma shader_feature DEBUGGING
            	#pragma shader_feature SCALE_PROPORTIONAL

				struct VS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
			    	float3 normal : NORMAL;
				};
				struct GS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
			    	float3 normal : NORMAL;
				};
				struct FS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
					// uv.w is tranpancy
				};


				// Mostly passthrough shader.
				// I do want all the verticies in world space (not clip yet).
				#pragma vertex VS_Main
				GS_INPUT VS_Main(VS_INPUT input)
				{
					GS_INPUT output = (GS_INPUT)0;
					output.vertex =  mul(unity_ObjectToWorld, input.vertex);
					output.normal = input.normal;
					output.uv = input.uv;
					return output;
				}

				inline float iter(float3 p) {
					return snoise_grad(p).w;
					float x = p.x;
					float x3 = x*x*x;
					float x5 = x*x*x3;

					float y2 = p.y*p.y;
					float y4 = y2*y2;

					float z2 = p.z*p.z;
					float z4 = z2*z2;

					//return x5 
					//	- 10*x3*(y2 + z2) 
					//	+ 5*x*(y4 + z4);
					return cos(p.x)*cos(p.y)*cos(p.z);
				}
				#pragma geometry GS_Main
				[maxvertexcount(3)] 
				void GS_Main(point GS_INPUT input[1], 
							 uint pid : SV_PrimitiveID, 
							 inout PointStream<FS_INPUT> stream) {
					FS_INPUT output = (FS_INPUT) 0;
					float r = 1/40.0;
					float3 pos = normalize(frac(float3(
						pid*r,
						pid*r*r + _Time.x, 
						pid*r*r*r
						))*2-1) ;

					float v = snoise(pos+ float3(0,-1,0)*_Time.y);
					pos *= 1+v*.3;
					output.uv.xy=1-(v+1)/2;
					/*for(int i = 0 ; i <2 ; i++) {
						float4 space_noise = snoise_grad(pos*_ITER_SCALE+_Time.y*float3(0,-.6,0));
						pos += space_noise.xyz * _DIST * .0001;
						output.uv.xy = frac(abs(space_noise.w));
					}*/
					

					// Shift the vertex
					output.vertex = input[0].vertex;
					output.vertex.xyz += pos;//z;

					// Convert from world to clip space.
					output.vertex = mul(UNITY_MATRIX_VP, output.vertex);
					stream.Append(output);
					
				}

				
                #pragma fragment FS_Main
				float4 FS_Main(FS_INPUT input) : COLOR
				{
					return tex2D(_MainTex, input.uv.xx);
				}
			ENDCG
		}
    } 
}
