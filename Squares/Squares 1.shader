// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Squares/Squares 1"
{
	Properties
	{
		_Float0("Float 0", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Float0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_30_0 = ( ase_worldPos * 30.0 );
			float3 temp_cast_0 = (pow( max( max( frac( temp_output_30_0 ).x , max( frac( temp_output_30_0 ).y , frac( temp_output_30_0 ).z ) ) , ( 1.0 - min( frac( temp_output_30_0 ).x , min( frac( temp_output_30_0 ).y , frac( temp_output_30_0 ).z ) ) ) ) , _Float0 )).xxx;
			o.Albedo = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
897;92;1023;926;-985.1279;718.9943;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;31;1051.429,-312.0939;Float;False;Constant;_Scale;Scale;0;0;Create;30;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;28;1009.829,-453.7937;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1220.429,-400.4937;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FractNode;46;1264.628,-106.6938;Float;False;1;0;FLOAT3;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;39;948.729,-26.0942;Float;False;FLOAT3;1;0;FLOAT3;0.0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMinOpNode;44;1189.228,205.3057;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;42;1311.429,176.7058;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;1186.628,62.30577;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;1431.027,179.3057;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;41;1308.829,33.70581;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;49;1601.328,53.20565;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;1598.728,154.6056;Float;False;Property;_Float0;Float 0;0;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;1550.629,-305.5939;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;50.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;50;1809.328,85.70561;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;1706.629,-249.694;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;34;1463.529,-76.79388;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;32;1381.629,-397.894;Float;False;1;0;FLOAT3;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;37;1874.329,-257.4941;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;33;1519.429,-408.294;Float;False;Simplex3D;1;0;FLOAT3;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;19;2147.73,-287.5915;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/Squares;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;28;0
WireConnection;30;1;31;0
WireConnection;46;0;30;0
WireConnection;39;0;46;0
WireConnection;44;0;39;1
WireConnection;44;1;39;2
WireConnection;42;0;39;0
WireConnection;42;1;44;0
WireConnection;43;0;39;1
WireConnection;43;1;39;2
WireConnection;47;0;42;0
WireConnection;41;0;39;0
WireConnection;41;1;43;0
WireConnection;49;0;41;0
WireConnection;49;1;47;0
WireConnection;36;0;33;0
WireConnection;50;0;49;0
WireConnection;50;1;51;0
WireConnection;35;0;36;0
WireConnection;35;1;34;0
WireConnection;32;0;30;0
WireConnection;37;0;35;0
WireConnection;33;0;32;0
WireConnection;19;0;50;0
ASEEND*/
//CHKSM=5029672BE05F0F248172508A3291BB7A87E793CF
