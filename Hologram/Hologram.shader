// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Hologram/Hologram"
{
	Properties
	{
		_VerticalBandScale("VerticalBandScale", Float) = 0
		[Toggle] _ScreenSpacevsWorld("ScreenSpace(vsWorld)", Float) = 0.0
		_VerticalSpeed("Vertical Speed", Float) = 0
		_VerticalNoise("Vertical Noise", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _SCREENSPACEVSWORLD_ON
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
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

		uniform float _VerticalSpeed;
		uniform float _VerticalBandScale;
		uniform float _VerticalNoise;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime21 = _Time.y * _VerticalSpeed;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 ase_worldPos = i.worldPos;
			#ifdef _SCREENSPACEVSWORLD_ON
				float staticSwitch17 = ( ( ase_screenPosNorm * _ScreenParams ) / _VerticalBandScale ).y;
			#else
				float staticSwitch17 = ( _VerticalBandScale * ase_worldPos.y );
			#endif
			float2 temp_cast_2 = (staticSwitch17).xx;
			float simplePerlin2D30 = snoise( temp_cast_2 );
			float Vertical18 = (simplePerlin2D30*_VerticalNoise + staticSwitch17);
			float temp_output_9_0 = sin( ( mulTime21 + Vertical18 ) );
			float Albedo26 = ( temp_output_9_0 * temp_output_9_0 );
			float temp_output_19_0 = Albedo26;
			c.rgb = 0;
			c.a = temp_output_19_0;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float mulTime21 = _Time.y * _VerticalSpeed;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 ase_worldPos = i.worldPos;
			#ifdef _SCREENSPACEVSWORLD_ON
				float staticSwitch17 = ( ( ase_screenPosNorm * _ScreenParams ) / _VerticalBandScale ).y;
			#else
				float staticSwitch17 = ( _VerticalBandScale * ase_worldPos.y );
			#endif
			float2 temp_cast_0 = (staticSwitch17).xx;
			float simplePerlin2D30 = snoise( temp_cast_0 );
			float Vertical18 = (simplePerlin2D30*_VerticalNoise + staticSwitch17);
			float temp_output_9_0 = sin( ( mulTime21 + Vertical18 ) );
			float Albedo26 = ( temp_output_9_0 * temp_output_9_0 );
			float temp_output_19_0 = Albedo26;
			float3 temp_cast_1 = (temp_output_19_0).xxx;
			o.Albedo = temp_cast_1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
799;92;1121;926;1440.92;1250.948;1.636323;True;False
Node;AmplifyShaderEditor.ScreenParams;6;-1116.502,-485.6238;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;5;-1152.502,-653.6238;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-1157.002,-315.4238;Float;False;Property;_VerticalBandScale;VerticalBandScale;0;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-887.8019,-507.8238;Float;False;2;2;0;FLOAT4;0.0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-740.808,-508.6693;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-1128.035,-201.0003;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-878.4346,-223.1002;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;12;-593.0889,-505.8181;Float;False;FLOAT4;1;0;FLOAT4;0.0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StaticSwitch;17;-689.3062,-238.8598;Float;False;Property;_ScreenSpacevsWorld;ScreenSpace(vsWorld);1;0;Create;0;False;False;True;;Toggle;2;0;FLOAT;0.0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;30;-243.132,-836.958;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-269.3131,-566.9647;Float;False;Property;_VerticalNoise;Vertical Noise;3;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1318.195,279.0122;Float;False;Property;_VerticalSpeed;Vertical Speed;2;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;32;-84.40857,-601.3275;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-360.5921,-235.9019;Float;False;Vertical;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-1103.836,342.8289;Float;False;18;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;21;-1100.56,250.5282;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-904.2055,285.5576;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;9;-730.1635,290.8116;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-589.908,280.2057;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;1044.684,22.43749;Float;False;26;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-339.6745,305.1934;Float;False;Albedo;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;29;1282.9,34;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Custom/Hologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0,0,0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;5;0
WireConnection;10;1;6;0
WireConnection;20;0;10;0
WireConnection;20;1;13;0
WireConnection;16;0;13;0
WireConnection;16;1;15;2
WireConnection;12;0;20;0
WireConnection;17;0;12;1
WireConnection;17;1;16;0
WireConnection;30;0;17;0
WireConnection;32;0;30;0
WireConnection;32;1;33;0
WireConnection;32;2;17;0
WireConnection;18;0;32;0
WireConnection;21;0;25;0
WireConnection;24;0;21;0
WireConnection;24;1;23;0
WireConnection;9;0;24;0
WireConnection;11;0;9;0
WireConnection;11;1;9;0
WireConnection;26;0;11;0
WireConnection;29;0;19;0
WireConnection;29;9;19;0
ASEEND*/
//CHKSM=522FBBF3161B210DEDAEFA02BD4F096693AD2F31
