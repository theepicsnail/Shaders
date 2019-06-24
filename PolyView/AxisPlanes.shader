// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/PolyView/AxisPlanes"
{
	Properties
	{
		_Thickness("Thickness", Float) = 0.1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:premul keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float3 data7_g1;
		};

		uniform sampler2D _CameraDepthTexture;
		uniform float _Thickness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_vertex4Pos = v.vertex;
			o.data7_g1 = ( (mul( UNITY_MATRIX_MV, ase_vertex4Pos )).xyz * float3(-1,-1,1) );
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float clampDepth11_g1 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float4 appendResult15_g1 = (float4(( clampDepth11_g1 * ( i.data7_g1 * ( _ProjectionParams.z / (i.data7_g1).z ) ) ) , 1.0));
			float4 temp_output_2_0 = mul( unity_CameraToWorld, appendResult15_g1 );
			float4 transform20 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_output_22_0 = ( ( 1.0 - saturate( ( frac( ( temp_output_2_0 + _Thickness ) ) / ( _Thickness * 2.0 ) ) ) ) / sqrt( distance( transform20 , temp_output_2_0 ) ) );
			o.Emission = temp_output_22_0.xyz;
			o.Alpha = length( temp_output_22_0 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
963;92;957;650;433.643;1063.933;1.643944;True;False
Node;AmplifyShaderEditor.FunctionNode;2;-630.5,-456.5;Float;False;Reconstruct World Position From Depth;-1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;1;21;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-412.5,-342.5;Float;False;Property;_Thickness;Thickness;0;0;Create;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-249.5,-457.5;Float;False;2;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-159.5,-350.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;5;-125.5,-451.5;Float;False;1;0;FLOAT4;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;13;1.5,-408.5;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;20;-481.3175,-710.4866;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;15;134.5,-400.5;Float;False;1;0;FLOAT4;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DistanceOpNode;21;-211.7104,-631.5773;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;291.4694,-404.3484;Float;False;1;0;FLOAT4;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SqrtOpNode;24;13.51005,-629.9324;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;468.8826,-648.0161;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;3;-204.5,-233.5;Float;False;Constant;_Vector0;Vector 0;0;0;Create;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;23;648.0729,-578.9705;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;4;806.5235,-768.9099;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Snail/AxisPlanes;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Front;0;0;False;0;0;Premultiply;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;3;One;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;2;0
WireConnection;6;1;7;0
WireConnection;11;0;7;0
WireConnection;5;0;6;0
WireConnection;13;0;5;0
WireConnection;13;1;11;0
WireConnection;15;0;13;0
WireConnection;21;0;20;0
WireConnection;21;1;2;0
WireConnection;16;0;15;0
WireConnection;24;0;21;0
WireConnection;22;0;16;0
WireConnection;22;1;24;0
WireConnection;23;0;22;0
WireConnection;4;2;22;0
WireConnection;4;9;23;0
ASEEND*/
//CHKSM=D50158706F261BC5707992EFDD3E01C116216B8A
