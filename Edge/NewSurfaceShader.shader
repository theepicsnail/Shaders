// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Edge/NewSurfaceShader"
{
	Properties
	{
		_Clip("Clip", Float) = 0.0015
		_Radius("Radius", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _CameraDepthTexture;
		uniform float _Radius;
		uniform float _Clip;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float eyeDepth27 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(( float4( ( _Radius * float2( 0,-1 ) ), 0.0 , 0.0 ) + ase_grabScreenPosNorm )))));
			float eyeDepth26 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_grabScreenPosNorm))));
			float eyeDepth28 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(( float4( ( _Radius * float2( 0,1 ) ), 0.0 , 0.0 ) + ase_grabScreenPosNorm )))));
			float temp_output_39_0 = ( eyeDepth26 * _Clip );
			float ifLocalVar41 = 0;
			if( abs( ( ( eyeDepth27 - eyeDepth26 ) - ( eyeDepth28 - eyeDepth26 ) ) ) >= temp_output_39_0 )
				ifLocalVar41 = 1.0;
			else
				ifLocalVar41 = 0.0;
			float eyeDepth30 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(( ase_grabScreenPosNorm + float4( 0,0,0,0 ) )))));
			float temp_output_36_0 = ( eyeDepth26 - ( eyeDepth30 - eyeDepth26 ) );
			float ifLocalVar42 = 0;
			if( temp_output_39_0 <= abs( temp_output_36_0 ) )
				ifLocalVar42 = 0.0;
			else
				ifLocalVar42 = 1.0;
			float3 temp_cast_2 = (( ifLocalVar41 + ifLocalVar42 )).xxx;
			o.Emission = temp_cast_2;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1175;100;737;910;1345.391;239.1775;1;True;False
Node;AmplifyShaderEditor.Vector2Node;2;-1027.512,131.4904;Float;False;Constant;_Vector1;Vector 1;0;0;Create;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;1;-1031.36,-2.158012;Float;False;Constant;_Vector0;Vector 0;0;0;Create;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;52;-1010.539,-94.30652;Float;False;Property;_Radius;Radius;1;0;Create;0;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;66;-915.1962,250.6517;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-825.7988,130.0214;Float;False;2;2;0;FLOAT;0.0,0;False;1;FLOAT2;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-827.4482,-3.585435;Float;False;2;2;0;FLOAT;0.0,0;False;1;FLOAT2;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-646.1219,509.7711;Float;False;2;2;0;FLOAT4;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-639.6318,125.0571;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-640.8062,-1.959291;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT4;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenDepthNode;30;-511.0442,506.5874;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;28;-506.7554,123.8516;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;27;-509.3552,-3.937162;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;26;-512.15,254.6212;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-255.3228,515.9545;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-253.6061,-0.4593735;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-255.3228,127.9545;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-125.3228,439.9545;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-179.3228,314.9545;Float;False;Property;_Clip;Clip;0;0;Create;0.0015;0.0015;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-125.3228,43.95453;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;160.5817,494.5536;Float;False;Constant;_Float1;Float 1;0;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;157.2826,-11.83257;Float;False;Constant;_Float2;Float 2;0;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;3.677246,253.9545;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;38;26.67725,388.9545;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;37;27.67725,66.95453;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;42;342.6345,325.5008;Float;False;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;41;343.6345,104.5008;Float;False;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-1024.722,435.4721;Float;False;Constant;_Vector2;Vector 2;0;0;Create;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;4;-1024.92,565.0723;Float;False;Constant;_Vector3;Vector 3;0;0;Create;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-833.096,560.0985;Float;False;2;2;0;FLOAT;0.0,0;False;1;FLOAT2;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-823.1991,436.3883;Float;False;2;2;0;FLOAT;0.0,0;False;1;FLOAT2;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-640.5331,384.254;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT4;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;554.3754,238.4683;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-255.3228,382.9545;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;29;-501.4336,384.4537;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;761.2878,114.8503;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Custom/NewSurfaceShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Front;0;0;False;0;0;Translucent;0.5;True;False;0;False;Opaque;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0,0,0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;52;0
WireConnection;54;1;2;0
WireConnection;53;0;52;0
WireConnection;53;1;1;0
WireConnection;16;0;66;0
WireConnection;31;0;54;0
WireConnection;31;1;66;0
WireConnection;13;0;53;0
WireConnection;13;1;66;0
WireConnection;30;0;16;0
WireConnection;28;0;31;0
WireConnection;27;0;13;0
WireConnection;26;0;66;0
WireConnection;34;0;30;0
WireConnection;34;1;26;0
WireConnection;21;0;27;0
WireConnection;21;1;26;0
WireConnection;32;0;28;0
WireConnection;32;1;26;0
WireConnection;36;0;26;0
WireConnection;36;1;34;0
WireConnection;35;0;21;0
WireConnection;35;1;32;0
WireConnection;39;0;26;0
WireConnection;39;1;40;0
WireConnection;38;0;36;0
WireConnection;37;0;35;0
WireConnection;42;0;39;0
WireConnection;42;1;38;0
WireConnection;42;2;46;0
WireConnection;42;3;45;0
WireConnection;42;4;45;0
WireConnection;41;0;37;0
WireConnection;41;1;39;0
WireConnection;41;2;46;0
WireConnection;41;3;46;0
WireConnection;41;4;45;0
WireConnection;56;0;52;0
WireConnection;56;1;4;0
WireConnection;55;0;52;0
WireConnection;55;1;3;0
WireConnection;15;0;55;0
WireConnection;15;1;66;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;33;0;29;0
WireConnection;33;1;36;0
WireConnection;29;0;15;0
WireConnection;0;2;43;0
ASEEND*/
//CHKSM=F85A9E0196FEC56836F9361465A2F51BB928DD9F
