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
    		uniform float _SCALE;
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
					output.vertex =  float4(0,0,0,0);// We use SV_PrimitiveID instead of vert pos
					output.normal = input.normal;
					output.uv = input.uv;
					return output;
				}

				inline float2 uv_at(float4 pos){
					float v = abs(snoise(float4(_Time.x, pos.xyz/2)));
					v *= saturate(abs(sin(length(pos)-_Time.y)));
					float r = .5;
					v = (max(r, v)-r)/(1-r);
					return v;
				}

				// Put an edge in the output stream
				inline void edge(float3 pos, float3 dir, inout LineStream<FS_INPUT> stream) {
					FS_INPUT output = (FS_INPUT) 0;

					float4 center = mul(unity_ObjectToWorld, float4(0,0,0,1));

					float4 worldspace = mul(unity_ObjectToWorld, float4(pos*_SCALE,1));
					worldspace.xyz=floor(worldspace.xyz/_SCALE)*_SCALE;
					output.uv = lerp(
						0,
						uv_at(worldspace).xxxx,
						_FILL);

					output.vertex = mul(UNITY_MATRIX_VP, worldspace);
					stream.Append(output);

					worldspace.xyz += dir;
					output.uv = lerp(
						0,
						uv_at(worldspace).xxxx,
						_FILL);

					output.vertex = mul(UNITY_MATRIX_VP, worldspace);
					stream.Append(output);


					stream.RestartStrip();
				}

				#pragma geometry GS_Main
				[maxvertexcount(6)] 
				void GS_Main(point GS_INPUT input[1], 
							 uint pid : SV_PrimitiveID, 
							 inout LineStream<FS_INPUT> stream) {
					FS_INPUT output = (FS_INPUT) 0;

					float xid = pid%40;
					float yid = pid/40%40;
					float zid = pid/1600%40;
					float3 vert = float3(xid,yid,zid)-float3(20,10,20);
					// float3 pos = normalize(
					// 	float3(xid, yid, zid)/40
					// 	*2-1);


					// output.vertex = input[0].vertex;
					// output.uv = 0;


					// yield x-edge
					if(xid < 39) edge(vert*_SCALE, float3(1,0,0)*_SCALE, stream);
					if(yid < 39) edge(vert*_SCALE, float3(0,1,0)*_SCALE, stream);
					if(zid < 39) edge(vert*_SCALE, float3(0,0,1)*_SCALE, stream);



					// output.vertex.xyz += pos;//z;

					// // Convert from world to clip space.

					// output.vertex = input[0].vertex;
					// output.vertex.xyz += pos;
					// output.vertex.xyz += float3(1,0,0);
					// output.vertex = mul(UNITY_MATRIX_VP, output.vertex);
					// stream.Append(output);
					
				}

				
                #pragma fragment FS_Main
				float4 FS_Main(FS_INPUT input) : COLOR
				{
					float4 o = tex2D(_MainTex, input.uv.xx);
					o.a *= abs(input.uv.x);
					return o;
				}
			ENDCG
		}
    } 
}
