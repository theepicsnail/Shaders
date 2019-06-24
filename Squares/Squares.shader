// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "snail/Squares/Squares" 
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
    	CGINCLUDE
    		#include "UnityCG.cginc"
    		uniform float _SCALE;
    		uniform float _DIST;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _ITER_SCALE;
    	ENDCG

    	Pass {

			CGPROGRAM
            	#pragma shader_feature DEBUGGING
            	#pragma shader_feature SCALE_PROPORTIONAL

				struct VS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
			    	float3 normal : NORMAL;
				};
				struct FS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
				};

				#pragma vertex VS_Main
				FS_INPUT VS_Main(VS_INPUT input)
				{
					FS_INPUT output = (FS_INPUT)0;
					output.vertex =  UnityObjectToClipPos(input.vertex);
					output.uv = input.uv;
					return output;
				}

				
                #pragma fragment FS_Main
				float4 FS_Main(FS_INPUT input) : COLOR
				{
					return tex2D(_MainTex, input.uv);
				}
			ENDCG
		}
    } 
}
