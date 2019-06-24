// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "snail/PointCloud/5" 
{
    Properties 
    {
		// Super handy guide for prettier properties!
		// https://gist.github.com/keijiro/22cba09c369e27734011
		_MainTex("Texture", 2D) = "white" {}
    	_SCALE("Scale", Float) = 0 
    	_SPEED("Speed", Float) = 1
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
    		uniform float _SPEED;
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


				float3 pos(float3 p) {
					float3 t = p.xyz*100.135 + p.yzx*40.135 + p.zxy*543.556;
					return (p+.5 * sin(t*6.28 + _Time.y*_SPEED*float3(1,.6,1.3)));
				}

				void edge(float3 p1, float3 p2, point GS_INPUT input, inout LineStream<FS_INPUT> stream){
				
					p1 = pos(p1);
					p2 = pos(p2);
					float c = (p1.x+p1.y+p1.z)/2;
					float d = length(p1-p2);
					d = saturate(1-d);
					FS_INPUT output = (FS_INPUT) 0;
					output.uv.xy = float2(c,d);
					output.vertex = floor(input.vertex);
					output.vertex.xyz += p1*_SCALE;
					output.vertex = mul(UNITY_MATRIX_VP, output.vertex);
					stream.Append(output);

					output.uv.xy = float2(c+1,d);
					output.vertex = floor(input.vertex);
					output.vertex.xyz += p2*_SCALE;
					output.vertex = mul(UNITY_MATRIX_VP, output.vertex);
					stream.Append(output);
					
				}

				#pragma geometry GS_Main
				[maxvertexcount(12)] 
				void GS_Main(point GS_INPUT input[1], 
							 uint pid : SV_PrimitiveID, 
							 inout LineStream<FS_INPUT> stream) {

					float r = 10;
					float3 ipos = floor(float3(pid, pid/r, pid/r/r)%r)-r/2;
					if(pid>r*r*r)return;
					
					edge(ipos, ipos + float3( 0, 0, 1), input[0], stream);
					edge(ipos, ipos + float3( 0, 0,-1), input[0], stream);
					edge(ipos, ipos + float3( 0, 1, 0), input[0], stream);
					edge(ipos, ipos + float3( 0,-1, 0), input[0], stream);
					edge(ipos, ipos + float3( 1, 0, 0), input[0], stream);
					edge(ipos, ipos + float3(-1, 0, 0), input[0], stream);
				}

				
                #pragma fragment FS_Main
				float4 FS_Main(FS_INPUT input) : COLOR
				{
					return float4(tex2D(_MainTex, input.uv+_Time.x).xyz,input.uv.y);
				}
			ENDCG
		}
    } 
}
