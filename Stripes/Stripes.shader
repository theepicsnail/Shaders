// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Stripes/Stripes"
{
	Properties
	{
		_Thickness("Thickness", Float) = 0
		_TimeScaling("Time Scaling", Float) = 0
		_SpaceScaling("Space Scaling", Float) = 0
		_ColorBandSize("Color Band Size", Float) = 0
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
			float3 worldPos;
		};

		uniform float _SpaceScaling;
		uniform float _TimeScaling;
		uniform float _ColorBandSize;
		uniform float _Thickness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float mulTime12 = _Time.y * _TimeScaling;
			float temp_output_9_0 = (ase_worldPos.y*_SpaceScaling + mulTime12);
			float3 _Vector0 = float3(0.5,0.5,0.5);
			o.Emission = ( (cos( ( (float3(1,1,1)*( temp_output_9_0 / _ColorBandSize ) + float3(0,0.33,0.66)) * 6.28318548202515 ) )*_Vector0 + _Vector0) * saturate( (sin( temp_output_9_0 )*_Thickness + 0.5) ) );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1015;92;905;926;1178.347;434.9403;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-1241.5,-1;Float;False;Property;_TimeScaling;Time Scaling;1;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1057.5,2;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1219.5,-71;Float;False;Property;_SpaceScaling;Space Scaling;2;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-1197.5,-220;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;9;-871.5,-72;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-773.5,133;Float;False;Property;_Thickness;Thickness;0;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-783.3472,-269.9403;Float;False;Property;_ColorBandSize;Color Band Size;3;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-613.5,218;Float;False;Constant;_Float0;Float 0;0;0;Create;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;4;-542.5,38;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;5;-422.5,43;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-622.3472,-286.9403;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;21;-491.682,-288.6115;Float;True;Palette;-1;;7;2f1d135a9eacb7143a627c10266d6f7a;5;5;FLOAT;0.0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;13;-228.5,41.79352;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-31.49502,-90.2632;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;129.7168,-108.0973;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Snail/shaders/Stripes;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;9;0;8;2
WireConnection;9;1;10;0
WireConnection;9;2;12;0
WireConnection;4;0;9;0
WireConnection;5;0;4;0
WireConnection;5;1;7;0
WireConnection;5;2;6;0
WireConnection;23;0;9;0
WireConnection;23;1;24;0
WireConnection;21;5;23;0
WireConnection;13;0;5;0
WireConnection;17;0;21;0
WireConnection;17;1;13;0
WireConnection;2;2;17;0
ASEEND*/
//CHKSM=3B30BD7A90B49CC5B086A4039F2FEA13D97AEE02
