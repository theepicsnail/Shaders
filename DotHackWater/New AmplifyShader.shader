// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/DotHackWater/New AmplifyShader"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_Speed("Speed", Float) = 0.1
		_Scale("Scale", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" }
		Cull Back
		Blend One One
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha exclude_path:deferred 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _Texture0;
		uniform float _Speed;
		uniform float _Scale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Speed).xx;
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_4_0 = (( ase_worldPos * _Scale )).xz;
			float cos6 = cos( 0.0 );
			float sin6 = sin( 0.0 );
			float2 rotator6 = mul( temp_output_4_0 - float2( 0,0 ) , float2x2( cos6 , -sin6 , sin6 , cos6 )) + float2( 0,0 );
			float2 panner5 = ( rotator6 + 1.0 * _Time.y * temp_cast_0);
			float2 temp_cast_1 = (_Speed).xx;
			float cos12 = cos( 2.0 );
			float sin12 = sin( 2.0 );
			float2 rotator12 = mul( temp_output_4_0 - float2( 0,0 ) , float2x2( cos12 , -sin12 , sin12 , cos12 )) + float2( 0,0 );
			float2 panner13 = ( rotator12 + 1.0 * _Time.y * temp_cast_1);
			float2 temp_cast_2 = (_Speed).xx;
			float cos17 = cos( 4.0 );
			float sin17 = sin( 4.0 );
			float2 rotator17 = mul( temp_output_4_0 - float2( 0,0 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0,0 );
			float2 panner19 = ( rotator17 + 1.0 * _Time.y * temp_cast_2);
			float4 temp_output_15_0 = ( tex2D( _Texture0, panner5 ) + tex2D( _Texture0, panner13 ) + tex2D( _Texture0, panner19 ) );
			o.Albedo = temp_output_15_0.rgb;
			o.Alpha = ( length( temp_output_15_0 ) / 10.0 );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
983;92;937;926;614.9257;34.16437;1.0258;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1441.615,35.57616;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;-1401.695,192.1738;Float;False;Property;_Scale;Scale;2;0;Create;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1257.695,101.1738;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1063.834,810.3281;Float;False;Constant;_Float4;Float 4;3;0;Create;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1069.129,295.8138;Float;False;Constant;_Float0;Float 0;6;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;4;-1131.314,42.77618;Float;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1069.739,579.3101;Float;False;Constant;_Float2;Float 2;5;0;Create;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;6;-922.2283,163.2141;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;12;-922.8383,446.7105;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-926.0352,66.72855;Float;False;Property;_Speed;Speed;1;0;Create;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;17;-916.9345,677.7285;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;19;-723.2346,689.4286;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;13;-729.1384,458.4105;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;5;-728.5284,174.9141;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-783.1287,-133.1858;Float;True;Property;_Texture0;Texture 0;0;0;Create;None;c8c032a344521064e942612ae008a78f;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;20;-510.0058,667.8146;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;c8c032a344521064e942612ae008a78f;c8c032a344521064e942612ae008a78f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-515.9097,436.7965;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;c8c032a344521064e942612ae008a78f;c8c032a344521064e942612ae008a78f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-515.2997,153.3001;Float;True;Property;_TEX_see00;TEX_see00;1;0;Create;c8c032a344521064e942612ae008a78f;c8c032a344521064e942612ae008a78f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-114.2875,464.2685;Float;False;3;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LengthOpNode;23;20.04482,497.2003;Float;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;24;37.48346,601.8319;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;10.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ShadeVertexLightsHlpNode;1;-372.5,-113.5;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;168.8963,264.2141;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;New AmplifyShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;False;0;False;Transparent;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;4;One;One;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;0;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;3;0
WireConnection;21;1;22;0
WireConnection;4;0;21;0
WireConnection;6;0;4;0
WireConnection;6;2;7;0
WireConnection;12;0;4;0
WireConnection;12;2;10;0
WireConnection;17;0;4;0
WireConnection;17;2;16;0
WireConnection;19;0;17;0
WireConnection;19;2;18;0
WireConnection;13;0;12;0
WireConnection;13;2;18;0
WireConnection;5;0;6;0
WireConnection;5;2;18;0
WireConnection;20;0;9;0
WireConnection;20;1;19;0
WireConnection;14;0;9;0
WireConnection;14;1;13;0
WireConnection;2;0;9;0
WireConnection;2;1;5;0
WireConnection;15;0;2;0
WireConnection;15;1;14;0
WireConnection;15;2;20;0
WireConnection;23;0;15;0
WireConnection;24;0;23;0
WireConnection;0;0;15;0
WireConnection;0;9;24;0
ASEEND*/
//CHKSM=A6563E25DAAC77F9B52A626CC803E13F06CCB984
