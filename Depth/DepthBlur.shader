// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Depth/DepthBlur"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_R( "R", Float ) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
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
		uniform float _R;


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
			
			float clampDepth3 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			
			float r = clampDepth3 * _R;
			float4 screenColor8 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 screenColor1 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy +float2(1,0)*r );
			float4 screenColor2 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy +float2(-1,0)*r);
			float4 screenColor3 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy +float2(0,1)*r);
			float4 screenColor4 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy +float2(0,r)*r);

			o.Emission = (screenColor2+screenColor3+screenColor4+screenColor1+screenColor8)/5;
			o.Metallic = 0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
782;23;1140;1004;610.1467;770.7008;1;True;False
Node;AmplifyShaderEditor.GrabScreenPosition;6;-626.5,-541.5;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;3;-449.5,-269.5;Float;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;8;-23.5,-477.5;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;9;241,-229;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/NewSurfaceShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;6;0
WireConnection;9;2;8;0
WireConnection;9;3;3;0
ASEEND*/
//CHKSM=5B34D48520F35B191B166987BB7C9C1F592A5CCC
