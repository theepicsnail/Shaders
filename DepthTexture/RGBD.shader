// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/DepthTexture/RGBD"
{
	Properties
	{
		_Add("Add", Float) = 0
		_Multiply("Multiply", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ }
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform sampler2D _GrabTexture;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Multiply;
		uniform float _Add;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor16 = tex2D( _GrabTexture, ( (ase_grabScreenPosNorm).xy + float2( -0.5,0 ) ) );
			float clampDepth13 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float temp_output_10_0 = ( ( clampDepth13 * _Multiply ) + _Add );
			float4 temp_cast_0 = (temp_output_10_0).xxxx;
			float4 temp_cast_1 = (temp_output_10_0).xxxx;
			float4 ifLocalVar15 = 0;
			if( ase_grabScreenPosNorm.r <= 0.5 )
				ifLocalVar15 = temp_cast_1;
			else
				ifLocalVar15 = screenColor16;
			o.Albedo = ifLocalVar15.rgb;
			o.Emission = ifLocalVar15.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
509;312;872;643;1470.199;777.387;1.9;True;False
Node;AmplifyShaderEditor.GrabScreenPosition;14;-1130.31,-530.4648;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;13;-863.567,-98.05684;Float;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-819.1208,-15.10764;Float;False;Property;_Multiply;Multiply;2;0;Create;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;18;-840.6365,-351.3431;Float;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-639.7366,-329.5432;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-0.5,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-610.1206,-82.10762;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-619.1206,18.89238;Float;False;Property;_Add;Add;1;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;16;-510.4327,-331.8719;Float;False;Global;_GrabScreen0;Grab Screen 0;3;0;Create;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-449.1206,-82.10762;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;15;-250.9742,-377.0784;Float;False;False;5;0;FLOAT;0.0;False;1;FLOAT;0.5;False;2;COLOR;0,0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-27.19979,-413.4;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Snail/RGBD;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;2;7;False;0;0;Custom;0.5;True;True;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;14;0
WireConnection;19;0;18;0
WireConnection;9;0;13;0
WireConnection;9;1;11;0
WireConnection;16;0;19;0
WireConnection;10;0;9;0
WireConnection;10;1;12;0
WireConnection;15;0;14;1
WireConnection;15;2;16;0
WireConnection;15;3;10;0
WireConnection;15;4;10;0
WireConnection;0;0;15;0
WireConnection;0;2;15;0
ASEEND*/
//CHKSM=AB36420255400980A6860B174C420BD3F88D8ED3
