// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Disco/NewSurfaceShader 1"
{
	Properties
	{
		_Posterize("Posterize", Float) = 0.1
		_Float0("Float 0", Range( 0 , 0.5)) = 0.1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float3 data7_g1;
		};

		uniform float _Float0;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Posterize;


		inline float3 MyCustomExpression23( float v , float3 i )
		{
			return float3(i.x<v, i.y<v, i.z<v);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_vertex4Pos = v.vertex;
			o.data7_g1 = ( (mul( UNITY_MATRIX_MV, ase_vertex4Pos )).xyz * float3(-1,-1,1) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float v23 = ( _Float0 * 2.0 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float clampDepth11_g1 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float4 appendResult15_g1 = (float4(( clampDepth11_g1 * ( i.data7_g1 * ( _ProjectionParams.z / (i.data7_g1).z ) ) ) , 1.0));
			float4 temp_output_1_0 = mul( unity_CameraToWorld, appendResult15_g1 );
			float4 temp_output_28_0 = ( ( temp_output_1_0 - ( floor( ( temp_output_1_0 / _Posterize ) ) * _Posterize ) ) / _Posterize );
			float3 i23 = frac( ( _Float0 + temp_output_28_0 ) ).xyz;
			float3 localMyCustomExpression2323 = MyCustomExpression23( v23 , i23 );
			o.Emission = ( localMyCustomExpression2323 * (localMyCustomExpression2323).yzx );
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1111;92;809;552;325.4415;733.752;1.676334;True;False
Node;AmplifyShaderEditor.FunctionNode;1;-1353.583,-150.8053;Float;False;Reconstruct World Position From Depth;-1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;1;21;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1172.825,-44.39925;Float;False;Property;_Posterize;Posterize;0;0;Create;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;-962.7953,-60.37121;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FloorOpNode;26;-844.401,-60.37122;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-731.3079,-60.3712;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-594.0783,-142.6374;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;28;-437.9718,-74.50811;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-515.4632,-369.1851;Float;False;Property;_Float0;Float 0;1;0;Create;0.1;0.1;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-95.12823,-269.7322;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT4;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FractNode;19;26.02516,-265.0802;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-115.1282,-373.7322;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;23;156.5481,-366.1139;Float;False;float3(i.x<v, i.y<v, i.z<v);3;False;2;True;v;FLOAT;0.0;In;True;i;FLOAT3;0,0,0;In;My Custom Expression;2;0;FLOAT;0.0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;30;117.1107,-135.3009;Float;False;FLOAT3;1;2;0;2;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;9;-844.9142,-913.7546;Float;False;Constant;_Vector1;Vector 1;1;0;Create;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;12;-774.1172,-494.5486;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;304.86,-173.8566;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;15;-825.6741,-753.8531;Float;False;1;0;FLOAT3;0.0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;16;-825.345,-661.1674;Float;False;Constant;_Vector3;Vector 3;1;0;Create;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RotateAboutAxisNode;14;-445.7578,-716.6074;Float;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-910.8186,-492.7733;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;17;-106.0946,-715.3502;Float;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;10;-1109.656,-579.7647;Float;False;Constant;_Vector2;Vector 2;1;0;Create;0.618,1.618;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1079.475,-455.4912;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;8;-1093.974,-741.0123;Float;False;Constant;_Vector0;Vector 0;1;0;Create;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;484.2119,-378.8174;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/NewSurfaceShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;0;False;0;0;Opaque;0.5;True;False;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;1;0
WireConnection;25;1;3;0
WireConnection;26;0;25;0
WireConnection;27;0;26;0
WireConnection;27;1;3;0
WireConnection;18;0;1;0
WireConnection;18;1;27;0
WireConnection;28;0;18;0
WireConnection;28;1;3;0
WireConnection;22;0;7;0
WireConnection;22;1;28;0
WireConnection;19;0;22;0
WireConnection;21;0;7;0
WireConnection;23;0;21;0
WireConnection;23;1;19;0
WireConnection;30;0;23;0
WireConnection;12;0;13;0
WireConnection;29;0;23;0
WireConnection;29;1;30;0
WireConnection;15;0;8;0
WireConnection;14;0;15;0
WireConnection;14;1;12;0
WireConnection;14;2;9;0
WireConnection;14;3;16;0
WireConnection;13;0;10;0
WireConnection;13;1;11;0
WireConnection;17;0;14;0
WireConnection;17;1;12;1
WireConnection;17;2;9;0
WireConnection;17;3;28;0
WireConnection;0;2;29;0
ASEEND*/
//CHKSM=01741F836525D0471F45E51A10F0477D333D8A39
