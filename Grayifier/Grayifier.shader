// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Grayifier/Grayifier"
{
	Properties
	{
		_GrayDistance("GrayDistance", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Overlay+0" "IsEmissive" = "true"  }
		Cull Front
		ZWrite Off
		ZTest Always
		GrabPass{ }
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
		uniform float _GrayDistance;
		uniform sampler2D _GrabTexture;


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
			float eyeDepth1 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor4 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float dotResult7 = dot( screenColor4 , float4( float3(0.299,0.587,0.114) , 0.0 ) );
			float4 temp_cast_1 = (dotResult7).xxxx;
			float4 temp_cast_2 = (dotResult7).xxxx;
			float4 ifLocalVar2 = 0;
			if( eyeDepth1 <= _GrayDistance )
				ifLocalVar2 = temp_cast_2;
			else
				ifLocalVar2 = screenColor4;
			o.Emission = ifLocalVar2.rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
931;92;989;926;775.1003;255.6814;1;True;False
Node;AmplifyShaderEditor.Vector3Node;6;-858.5,348;Float;False;Constant;_Vector0;Vector 0;1;0;Create;0.299,0.587,0.114;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenColorNode;4;-839.5,175;Float;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;1;-525.5,18;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-502.5,121;Float;False;Property;_GrayDistance;GrayDistance;1;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;7;-563.5,293;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;8;-240.1003,-47.6814;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;2;-277.5,122;Float;False;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Custom/Grayifier;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;2;7;False;0;0;Custom;0.5;True;False;0;True;TransparentCutout;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0,0,0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;8;0;1;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;2;2;4;0
WireConnection;2;3;7;0
WireConnection;2;4;7;0
WireConnection;0;2;2;0
ASEEND*/
//CHKSM=1FA1439A9ADA532D0F4D167668E7D6898465AB71
