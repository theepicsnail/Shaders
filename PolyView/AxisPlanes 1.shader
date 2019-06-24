// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/PolyView/AxisPlanes 1"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			fixed filler;
		};

		uniform sampler2D _GrabTexture;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 screenColor163 = tex2D( _GrabTexture, float2( 0,0 ) );
			o.Emission = screenColor163.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
976;92;944;655;115.1604;-1312.601;1;True;False
Node;AmplifyShaderEditor.Vector2Node;165;219.8396,1542.601;Float;False;Constant;_Vector3;Vector 3;1;0;Create;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;125;404.7543,-9.111615;Float;False;Reconstruct World Position From Depth;-1;;6;e7094bcbcc80eb140b2a3dbe6a861de8;1;21;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;136;988.846,-220.7697;Float;False;Constant;_Float6;Float 6;1;0;Create;50;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;161;-522.334,1190.25;Float;False;Reconstruct World Position From Depth;-1;;5;e7094bcbcc80eb140b2a3dbe6a861de8;1;21;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;123;564.0248,-475.3088;Float;False;2;0;FLOAT;1.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;-231.4927,895.7551;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CrossProductOpNode;48;-531.0865,-230.3651;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;108;60.05366,-851.0409;Float;False;float4($  LinearEyeDepth($    tex2Dproj($      _CameraDepthTexture, $      UNITY_PROJ_COORD(uv+x)$    ).r$  ),$$  LinearEyeDepth($    tex2Dproj($      _CameraDepthTexture, $      UNITY_PROJ_COORD(uv-x)$    ).r$  ),$$  LinearEyeDepth($    tex2Dproj($      _CameraDepthTexture, $      UNITY_PROJ_COORD(uv+y)$    ).r$  ),$$  LinearEyeDepth($    tex2Dproj($      _CameraDepthTexture, $      UNITY_PROJ_COORD(uv-y)$    ).r$  )$)$;4;False;3;True;x;FLOAT4;0,0,0,0;In;True;y;FLOAT4;0,0,0,0;In;True;uv;FLOAT4;0,0,0,0;In;My Custom Expression;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;39;-382.3268,-522.3919;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;124;622.4769,-673.4548;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-442.5164,965.4134;Float;False;Constant;_Float7;Float 7;1;0;Create;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DdyOpNode;128;807.5697,-41.23636;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;120;-169.4147,-933.8674;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;162;217.7556,886.6434;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;121;-387.107,-1186.133;Float;False;Constant;_Vector2;Vector 2;0;0;Create;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CrossProductOpNode;147;192.238,445.1602;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;122;-163.0121,-1029.907;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;151;37.6217,332.0974;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CrossProductOpNode;43;-537.5444,-377.2852;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;38;-540.5482,-524.0067;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;63;-177.6873,-317.5508;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;13.75824,-195.863;Float;False;Constant;_Float5;Float 5;0;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;1150.949,-252.1445;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;150;46.80094,708.6552;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;138;1419.378,-252.1445;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-417.1029,462.1843;Float;False;2;2;0;FLOAT4x4;0.0;False;1;FLOAT4;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenParams;115;-576.6268,-942.8314;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;118;-388.3871,-1059.359;Float;False;Constant;_Vector1;Vector 1;0;0;Create;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DdxOpNode;127;809.3127,44.17272;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;49;-372.865,-228.7503;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;105;-0.7222369,-383.2792;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;149;-130.3389,533.6724;Float;False;2;0;FLOAT4;0.0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;126;1079.484,147.0123;Float;False;World;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;180.2121,-322.6851;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;140;1262.287,257.6909;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;112;308.2275,-764.8364;Float;False;(abs(length(D.x-O)-length(D.y-O))+abs(length(D.z-O)-length(D.w-O)))/O;1;False;2;True;D;FLOAT4;0,0,0,0;In;True;O;FLOAT;0.0;In;My Custom Expression;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;157;-148.7007,803.4755;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GrabScreenPosition;110;-256.5307,-760.8062;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CrossProductOpNode;129;943.5271,-8.118539;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;141;1534.201,149.5264;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;103;341.9637,-306.5508;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;130;1102.144,-2.889414;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;44;-367.4333,-369.7256;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenDepthNode;111;65.03882,-716.3271;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;1521.868,-115.0473;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-1597.015,-791.5681;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1360.873,-519.2441;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GrabScreenPosition;71;-1970.6,-316.3994;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;81;-1404.893,619.8914;Float;False;FLOAT;2;1;2;3;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ProjectionParams;80;-1404.893,475.8914;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;82;-1180.893,507.8914;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-743.3396,929.697;Float;False;Constant;_Float4;Float 4;0;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-789.7742,362.8944;Float;False;Constant;_Float2;Float 2;0;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1036.893,395.8914;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenDepthNode;100;-1208.653,-274.5974;Float;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;60;-1218.796,-522.4732;Float;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;76;-2012.893,395.8914;Float;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;77;-2028.893,491.8914;Float;False;Constant;_Vector0;Vector 0;0;0;Create;-1,-1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2220.893,395.8914;Float;False;2;2;0;FLOAT4x4;0.0;False;1;FLOAT4;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.MVMatrixNode;73;-2460.893,395.8914;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.PosVertexDataNode;74;-2460.893,475.8914;Float;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-1788.893,395.8914;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,-1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;-1788.561,-772.6401;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1817.319,-865.6728;Float;False;Constant;_Float1;Float 1;0;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;79;-1628.893,395.8914;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2002.285,-842.7034;Float;False;Constant;_Float0;Float 0;0;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenParams;35;-1996.684,-711.7564;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-789.7742,266.8944;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;-577.1028,542.1848;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;156;534.4993,279.9251;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;64;-176.1182,-429.8236;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;137;1286.906,-252.1445;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;131;1274.705,99.95007;Float;False;2;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;119;-366.6183,-930.0252;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;59;-1782.909,-670.119;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;61;-1215.567,-386.8549;Float;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-1626.363,-679.0471;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;155;445.5772,485.4385;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-1403.259,-382.0111;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CameraToWorldMatrix;97;-663.3396,753.6962;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.DynamicAppendNode;87;-629.7742,266.8944;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-583.3396,833.6967;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-743.3396,833.6967;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CameraToWorldMatrix;86;-709.7742,186.8945;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-414.594,765.9406;Float;False;2;2;0;FLOAT4x4;0.0;False;1;FLOAT4;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-737.1028,542.1848;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CameraToWorldMatrix;92;-657.1028,462.1843;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-737.1028,638.1851;Float;False;Constant;_Float3;Float 3;0;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-469.774,186.8945;Float;False;2;2;0;FLOAT4x4;0.0;False;1;FLOAT4;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;153;-193.4242,328.4927;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;163;462.8396,1555.601;Float;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;4;770.8947,1552.261;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Snail/AxisPlanes;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Front;2;7;False;0;0;Custom;0.5;True;False;0;True;Opaque;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;161;21;100;0
WireConnection;123;0;112;0
WireConnection;123;1;111;0
WireConnection;159;0;99;0
WireConnection;159;1;160;0
WireConnection;108;0;122;0
WireConnection;108;1;120;0
WireConnection;108;2;110;0
WireConnection;39;0;38;0
WireConnection;124;0;112;0
WireConnection;128;0;125;0
WireConnection;120;0;118;0
WireConnection;120;1;119;0
WireConnection;162;0;153;0
WireConnection;147;0;150;0
WireConnection;147;1;151;0
WireConnection;122;0;121;0
WireConnection;122;1;119;0
WireConnection;151;0;153;0
WireConnection;63;0;44;0
WireConnection;63;1;49;0
WireConnection;135;0;130;0
WireConnection;135;1;136;0
WireConnection;150;0;149;0
WireConnection;138;0;137;0
WireConnection;94;0;92;0
WireConnection;94;1;93;0
WireConnection;127;0;125;0
WireConnection;49;0;48;0
WireConnection;105;0;64;0
WireConnection;105;1;63;0
WireConnection;149;0;94;0
WireConnection;149;1;99;0
WireConnection;101;0;105;0
WireConnection;101;1;102;0
WireConnection;112;0;108;0
WireConnection;112;1;111;0
WireConnection;157;0;161;0
WireConnection;129;0;128;0
WireConnection;129;1;127;0
WireConnection;141;0;131;0
WireConnection;141;1;140;0
WireConnection;103;0;101;0
WireConnection;130;0;129;0
WireConnection;44;0;43;0
WireConnection;111;0;110;0
WireConnection;139;0;138;0
WireConnection;139;1;131;0
WireConnection;56;0;53;0
WireConnection;56;1;57;0
WireConnection;51;0;71;0
WireConnection;51;1;56;0
WireConnection;81;0;79;0
WireConnection;82;0;80;3
WireConnection;82;1;81;0
WireConnection;83;0;79;0
WireConnection;83;1;82;0
WireConnection;100;0;71;0
WireConnection;60;0;51;0
WireConnection;76;0;75;0
WireConnection;75;0;73;0
WireConnection;75;1;74;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;53;0;54;0
WireConnection;53;1;35;1
WireConnection;79;0;78;0
WireConnection;84;0;60;0
WireConnection;84;1;83;0
WireConnection;93;0;90;0
WireConnection;93;3;91;0
WireConnection;64;0;39;0
WireConnection;64;1;49;0
WireConnection;137;0;135;0
WireConnection;131;0;130;0
WireConnection;131;1;126;0
WireConnection;119;0;115;1
WireConnection;119;1;115;2
WireConnection;59;0;54;0
WireConnection;59;1;35;2
WireConnection;61;0;52;0
WireConnection;58;0;57;0
WireConnection;58;1;59;0
WireConnection;155;0;147;0
WireConnection;52;0;71;0
WireConnection;52;1;58;0
WireConnection;87;0;84;0
WireConnection;87;3;85;0
WireConnection;98;0;95;0
WireConnection;98;3;96;0
WireConnection;95;0;100;0
WireConnection;95;1;83;0
WireConnection;99;0;97;0
WireConnection;99;1;98;0
WireConnection;90;0;61;0
WireConnection;90;1;83;0
WireConnection;88;0;86;0
WireConnection;88;1;87;0
WireConnection;153;0;88;0
WireConnection;153;1;99;0
WireConnection;163;0;165;0
WireConnection;4;2;163;0
ASEEND*/
//CHKSM=25958E1D05B5D2A02427957D1301DA40AE181FE0
