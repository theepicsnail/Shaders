// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Disco/NewSurfaceShader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Front
		ZWrite On
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float3 vertexToFrag7_g8;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _CameraDepthTexture;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_vertex4Pos = v.vertex;
			o.vertexToFrag7_g8 = ( (mul( UNITY_MATRIX_MV, ase_vertex4Pos )).xyz * float3(-1,-1,1) );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float clampDepth11_g8 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float4 appendResult15_g8 = (float4(( clampDepth11_g8 * ( i.vertexToFrag7_g8 * ( _ProjectionParams.z / (i.vertexToFrag7_g8).z ) ) ) , 1.0));
			float4 temp_output_103_0 = mul( unity_CameraToWorld, appendResult15_g8 );
			float3 normalizeResult126 = normalize( cross( ddy( temp_output_103_0 ).xyz , ddx( temp_output_103_0 ).xyz ) );
			c.rgb = normalizeResult126;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1927;29;1906;1004;1224.525;-128.1648;1.381662;True;False
Node;AmplifyShaderEditor.FunctionNode;103;-787.084,1072.347;Float;False;Reconstruct World Position From Depth;-1;;8;e7094bcbcc80eb140b2a3dbe6a861de8;0;1;21;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DdxOpNode;123;-331.3603,1042.059;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DdyOpNode;124;-327.7193,1107.736;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CrossProductOpNode;125;-197.3199,1064.762;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;45;-1821.925,132.8626;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;1,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;119;113.332,612.4411;Float;False;Property;_Scale;Scale;2;0;Create;True;0;0;False;0;0;1000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;112;-1430.167,160.9292;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;63;-737.0114,255.2025;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;46;-1825.478,383.0446;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;0,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-1374.353,415.9045;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenDepthNode;53;-1157.867,-183.529;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;272.9068,422.1199;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;-735.6968,63.27628;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-1814.837,299.6924;Float;False;Property;_Radius;Radius;1;0;Create;True;0;0;False;0;2;0.003;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-902.7209,52.00785;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-897.782,317.3378;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-566.7724,152.2799;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;52;-1210.667,289.8816;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;34;-1678.338,-184.5556;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;-902.2537,143.2068;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;60;-902.9297,229.9864;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;50;-1214.567,155.0828;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;33;-1213.517,34.98502;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;51;-1219.444,416.5616;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;115;-146.7207,530.9138;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;272.6471,587.3026;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;105;-395.3373,838.1738;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;113;-1421.067,285.7292;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1598.466,382.8021;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;121;-374.8795,301.7501;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;101;472.3062,721.717;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;86;72.70679,370.1199;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;98;-2258.392,37.07791;Float;False;0;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;104;-627.0477,892.6938;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;133;-101.3418,1186.039;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;126;-42.31993,1072.762;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;86.61389,444.1484;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;273.0421,834.8417;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;118;-423.4628,139.7642;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;106;-247.3541,832.3324;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1374.354,286.3009;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;85;415.9068,431.2198;Float;False;Simple HUE;-1;;9;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;108;-0.8595841,932.3323;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1377.284,32.9799;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;111;-1430.168,60.82919;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-1373.693,157.0304;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;132;179.8509,1121.304;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;90;-140.5861,375.3484;Float;False;Constant;_Vector3;Vector 3;3;0;Create;True;0;0;False;0;0.5,-10;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;84;453.844,588.8813;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;109;10.74652,824.3969;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1601.714,128.4169;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;675.1213,966.7388;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;snail/Disco/NewSurfaceShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Front;1;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;123;0;103;0
WireConnection;124;0;103;0
WireConnection;125;0;124;0
WireConnection;125;1;123;0
WireConnection;112;0;111;0
WireConnection;63;0;60;0
WireConnection;63;1;61;0
WireConnection;49;0;113;0
WireConnection;49;1;44;0
WireConnection;53;0;34;0
WireConnection;88;0;86;0
WireConnection;88;1;89;0
WireConnection;62;0;58;0
WireConnection;62;1;59;0
WireConnection;58;0;33;0
WireConnection;58;1;53;0
WireConnection;61;0;53;0
WireConnection;61;1;51;0
WireConnection;79;0;62;0
WireConnection;79;1;63;0
WireConnection;52;0;47;0
WireConnection;59;0;53;0
WireConnection;59;1;50;0
WireConnection;60;0;52;0
WireConnection;60;1;53;0
WireConnection;50;0;48;0
WireConnection;33;0;39;0
WireConnection;51;0;49;0
WireConnection;81;0;121;0
WireConnection;81;1;119;0
WireConnection;105;0;103;0
WireConnection;105;1;104;0
WireConnection;113;0;112;0
WireConnection;44;0;110;0
WireConnection;44;1;46;0
WireConnection;121;0;79;0
WireConnection;101;0;81;0
WireConnection;101;1;106;0
WireConnection;86;0;90;1
WireConnection;126;0;125;0
WireConnection;89;0;90;2
WireConnection;89;1;106;0
WireConnection;107;0;109;0
WireConnection;107;1;108;0
WireConnection;118;0;79;0
WireConnection;118;1;79;0
WireConnection;106;0;105;0
WireConnection;47;0;113;0
WireConnection;47;1;44;0
WireConnection;85;1;88;0
WireConnection;39;0;111;0
WireConnection;39;1;41;0
WireConnection;111;0;34;0
WireConnection;48;0;112;0
WireConnection;48;1;41;0
WireConnection;132;0;133;0
WireConnection;132;1;126;0
WireConnection;84;0;81;0
WireConnection;109;0;106;0
WireConnection;41;0;110;0
WireConnection;41;1;45;0
WireConnection;0;13;126;0
ASEEND*/
//CHKSM=0B3FB64ECE29DF9CA01C077B9172A926F2D0D514