// Made with Amplify Shader Editor
// UNITY_MATRIX_MVP UNITY_MATRIX_MV UNITY_MATRIX_V UNITY_MATRIX_P UNITY_MATRIX_VP UNITY_MATRIX_T_MV UNITY_MATRIX_IT_MV _Object2World _World2Object _WorldSpaceCameraPos _ProjectionParams _ScreenParams _ZBufferParams unity_OrthoParams unity_CameraProjection unity_CameraInvProjection unity_CameraWorldClipPlanes _Time _SinTime _CosTime unity_DeltaTime _LightColor0 _WorldSpaceLightPos0 _LightMatrix0 unity_4LightPosX0 unity_4LightAtten0 unity_LightColor _LightColor _LightMatrix0 unity_LightColor unity_LightPosition unity_LightAtten unity_SpotDirection unity_AmbientSky unity_AmbientEquator unity_AmbientGround UNITY_LIGHTMODEL_AMBIENT unity_FogColor unity_FogParams unity_LODFade 
// UnityObjectToClipPos UnityObjectToViewPos WorldSpaceViewDir ObjSpaceViewDir ParallaxOffset Luminance DecodeLightmap EncodeFloatRGBA DecodeFloatRGBA EncodeFloatRG DecodeFloatRG EncodeViewNormalStereo DecodeViewNormalStereo WorldSpaceLightDir ObjSpaceLightDir Shade4PointLights ComputeScreenPos ComputeGrabScreenPos ShadeVertexLights 

// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Camera/2/Geometry"
{
	Properties
	{
		__MainTex("Memory", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}
	
    SubShader 
    {
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
		}
    	CGINCLUDE
    		#include "UnityCG.cginc"
			uniform sampler2D _MainTex;
    	ENDCG

    	Pass {
	        ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
            	#pragma shader_feature DEBUGGING
            	#pragma shader_feature SCALE_PROPORTIONAL

				struct VS_INPUT { 
					float4 color : COLOR;
					float4 vertex : POSITION;
				};
				struct GS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
				};
				struct FS_INPUT { 
					float4 vertex : POSITION;
					float4 uv : TEXCOORD0;
				};

				#pragma vertex VS_Main
				GS_INPUT VS_Main(VS_INPUT input)
				{
					GS_INPUT output = (GS_INPUT)0;
					output.uv = input.color;
					output.vertex = input.vertex;
					return output;
					/*
					int size = 40;
					float3 offset = float3(size/2, size/2, size/2);
					float3 vertex = float3(
						pid%size,
						pid/size%size,
						pid/size/size%size
					) / 40.0f;
					float2 px = frac(floor(float2(pid%256,pid/256))/256.0f);
					float4 samplePoint = tex2Dlod(_MainTex, float4(px,0,0));
					output.uv = samplePoint;
					output.vertex = float4(vertex,1);*/
				}

				#pragma geometry GS_Main
				[maxvertexcount(1)] 
				void GS_Main(point GS_INPUT input[1], 
							 uint pid : SV_PrimitiveID, 
							 inout PointStream<FS_INPUT> stream) {
					FS_INPUT output = (FS_INPUT) 0;
					//vertex.xyz += samplePoint.xyz -.5;
					//output.uv = float4(samplePoint.xyz,0);
					//output.vertex = UnityObjectToClipPos(float4(vertex,1));
					output.uv = input[0].uv;
					output.vertex = UnityObjectToClipPos(input[0].vertex);
					stream.Append(output);
				}

				
                #pragma fragment FS_Main
				float4 FS_Main(FS_INPUT input) : COLOR
				{
					//float4 o = tex2D(_MainTex, input.uv.xx);
					//o.a *= abs(input.uv.w);
					return float4(input.uv.xyz,1);
				}
			ENDCG
		}
    } 
}
