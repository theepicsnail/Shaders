// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Snail/shaders/VariableHueShift"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_HueShiftMap("HueShiftMap", 2D) = "white" {}
		_EmissionMap("EmissionMap", 2D) = "white" {}
		_Smoothness("Smoothness", Float) = 0
		_Metallic("Metallic", Float) = 0
		_PhaseScale("PhaseScale", Float) = 0
		_Speed("Speed", Float) = -0.5
		_Emission("Emission", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _HueShiftMap;
		uniform float4 _HueShiftMap_ST;
		uniform float _Speed;
		uniform float _PhaseScale;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _Emission;
		uniform float _Metallic;
		uniform float _Smoothness;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, clamp( p - K.xxx, 0.0, 1.0 ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_HueShiftMap = i.uv_texcoord * _HueShiftMap_ST.xy + _HueShiftMap_ST.zw;
			float mulTime6 = _Time.y * ( tex2D( _HueShiftMap, uv_HueShiftMap ).r * _Speed );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 hsvTorgb4 = RGBToHSV( tex2D( _MainTex, uv_MainTex ).rgb );
			float3 hsvTorgb5 = HSVToRGB( float3(( mulTime6 + ( _PhaseScale * hsvTorgb4.x ) ),hsvTorgb4.y,hsvTorgb4.z) );
			o.Albedo = hsvTorgb5;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			o.Emission = ( hsvTorgb5 * tex2D( _EmissionMap, uv_EmissionMap ).r * _Emission );
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
596;174;1317;839;801.6312;843.1293;1.72253;False;False
Node;AmplifyShaderEditor.SamplerNode;2;-642.0605,-509.7813;Float;True;Property;_HueShiftMap;HueShiftMap;1;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-518.3965,-321.9391;Float;False;Property;_Speed;Speed;6;0;Create;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-641.2225,-170.324;Float;True;Property;_MainTex;MainTex;0;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RGBToHSVNode;4;-323.7234,-133.3485;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;13;-272.443,-253.6473;Float;False;Property;_PhaseScale;PhaseScale;5;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-251.3796,-388.9391;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-58.83029,-216.5262;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-84.75282,-379.0544;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;130.8598,-210.5652;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;337.608,195.4685;Float;False;Property;_Emission;Emission;7;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;192.0331,3.733379;Float;True;Property;_EmissionMap;EmissionMap;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HSVToRGBNode;5;258.9341,-131.2271;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;536.3821,-53.93313;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;2;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;8;575.1469,94.03499;Float;False;Property;_Metallic;Metallic;4;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;584.8748,171.2027;Float;False;Property;_Smoothness;Smoothness;3;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;765.4656,-189.4139;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Snail/shaders/VariableHueShift;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;0
WireConnection;11;0;2;1
WireConnection;11;1;10;0
WireConnection;12;0;13;0
WireConnection;12;1;4;1
WireConnection;6;0;11;0
WireConnection;7;0;6;0
WireConnection;7;1;12;0
WireConnection;5;0;7;0
WireConnection;5;1;4;2
WireConnection;5;2;4;3
WireConnection;14;0;5;0
WireConnection;14;1;16;1
WireConnection;14;2;15;0
WireConnection;0;0;5;0
WireConnection;0;2;14;0
WireConnection;0;3;8;0
WireConnection;0;4;9;0
ASEEND*/
//CHKSM=FD0A850E32323881528F67C8EEFA39EB0AEF892A