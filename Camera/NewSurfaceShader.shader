// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Camera/NewSurfaceShader"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Scale("Scale", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Scale;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			float4 lerpResult15 = lerp( tex2DNode1 , ( 1.0 - tex2DNode1 ) , _Scale);
			o.Emission = lerpResult15.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
807;92;1113;926;825.8267;680.7331;1.6;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-428.9591,-159.2186;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;None;ee600d7161d15e44eb00a4c78ef39fd0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;13;-59.72729,-179.7707;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-259.4299,112.2422;Float;False;Property;_Scale;Scale;2;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;12;307.0861,224.5333;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;60.05176,463.1255;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-257.8417,188.4724;Float;False;Property;_Offset;Offset;1;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;10;-337.2481,293.2887;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;89.95782,185.2961;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;6;-2.153512,-91.03784;Float;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;15;215.8332,-336.6924;Float;False;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;548.1021,-94.94248;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Custom/NewSurfaceShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;False;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;1;0
WireConnection;12;0;11;0
WireConnection;11;0;6;0
WireConnection;11;1;10;2
WireConnection;6;0;1;0
WireConnection;6;1;8;0
WireConnection;6;2;9;0
WireConnection;15;0;1;0
WireConnection;15;1;13;0
WireConnection;15;2;8;0
WireConnection;3;2;15;0
ASEEND*/
//CHKSM=125D64488B75AB7A9EB5F07D48BB676A663E93E9
