// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Camera/2/UpdateGeometry"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			fixed filler;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TextureSample0 = v.texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_cast_0 = (0.0).xxxx;
			float4 temp_cast_1 = (1.0).xxxx;
			float4 temp_cast_2 = (-1.0).xxxx;
			float4 temp_cast_3 = (1.0).xxxx;
			v.vertex.xyz += (temp_cast_2 + (tex2Dlod( _TextureSample0, float4( uv_TextureSample0, 0, 0.0) ) - temp_cast_0) * (temp_cast_3 - temp_cast_2) / (temp_cast_1 - temp_cast_0)).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
772;92;1148;926;885.9235;96.1749;1.050122;True;False
Node;AmplifyShaderEditor.RangedFloatNode;7;-422,286;Float;False;Constant;_Float1;Float 1;1;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-421,366;Float;False;Constant;_Float0;Float 0;1;0;Create;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-423,448;Float;False;Constant;_Float2;Float 2;1;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-458,73;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;None;73e13c93b460f97439307a3accebad03;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;4;-159,278;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;22,3;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Memory;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;0
WireConnection;4;1;7;0
WireConnection;4;2;8;0
WireConnection;4;3;6;0
WireConnection;4;4;8;0
WireConnection;0;11;4;0
ASEEND*/
//CHKSM=6802E9CB4C564EEDB3D3B0F23CCABFF024B6D16D
