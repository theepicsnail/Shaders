// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "snail/PointCloud/PointCloud 3" 
{
    Properties 
    {
		// Super handy guide for prettier properties!
		// https://gist.github.com/keijiro/22cba09c369e27734011
		_MainTex("Texture", 2D) = "white" {}
    	_GRID_SIZE("Grid Size", Float) = .1
    	_DIST("Dist", Float) = 1
    	_ITER_SCALE("Iter scale", Float) = 1
    	_FILL("Fill", Range(0,1)) = 1

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
    		#include "../ShaderUtils/Noise2.cginc"
    		uniform float _GRID_SIZE;
    		uniform float _DIST;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _ITER_SCALE;
			uniform float _FILL;
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
					output.vertex =  input.vertex;
					output.normal = input.normal;
					output.uv = input.uv;
				//	output.color = input.color;
					return output;
				}

				inline void doPoint(inout FS_INPUT io, float3 pos, float3 center) {
					float t = _Time.y/2;
					float theta = t * UNITY_PI - length(pos-center);
					float color = frac(sin(floor(theta/(UNITY_TWO_PI))*100)*100);
					io.uv.x = color;
					float v = abs(sin(theta+color));
					v *= snoise(float4(pos, color*100));
					v *= v;
					v *= v;
					v *= v;
					io.uv.w = v;
					
				}
				// Put an edge in the output stream
				inline void edge(
						float3 objPos, 
						float3 edgeDir, 
						inout LineStream<FS_INPUT> stream) {

					FS_INPUT output = (FS_INPUT) 0;
					float4 center = mul(unity_ObjectToWorld, float4(0,0,0,1));
					float4 start = mul(unity_ObjectToWorld, float4(objPos,1));
					float4 end = mul(unity_ObjectToWorld, float4(objPos+edgeDir,1));

					doPoint(output, start, center);
					output.vertex = mul(UNITY_MATRIX_VP, start);
					stream.Append(output);

					doPoint(output, end, center);
					output.vertex = mul(UNITY_MATRIX_VP, end);
					stream.Append(output);
					stream.RestartStrip();
				}

				#pragma geometry GS_Main
				[maxvertexcount(6)] 
				void GS_Main(point GS_INPUT input[1], 
							 uint pid : SV_PrimitiveID, 
							 inout LineStream<FS_INPUT> stream) {
					FS_INPUT output = (FS_INPUT) 0;
					//float3 vertex = input[0].vertex;

					int size = 40;
					float3 offset = float3(size/2, size/2, size/2);
					float3 vertex = float3(
						pid%size,
						pid/size%size,
						pid/size/size%size
					);
					if(vertex.x < size-1) edge(vertex-offset, float3(1,0,0), stream);
					if(vertex.y < size-1) edge(vertex-offset, float3(0,1,0), stream);
					if(vertex.z < size-1) edge(vertex-offset, float3(0,0,1), stream);					
				}

				
                #pragma fragment FS_Main
				float4 FS_Main(FS_INPUT input) : COLOR
				{
					float4 o = tex2D(_MainTex, input.uv.xx);
					o.a *= abs(input.uv.w);
					return o;
				}
			ENDCG
		}
    } 
}
