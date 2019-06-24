// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Water/Fog"
{
	Properties
	{
		_Height("Height", Float) = 1
		_Maximum("Maximum", Float) = 1
		_Density("Density", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			float4 screenPos;
			float3 data7_g3;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Height;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Density;
		uniform float _Maximum;


		float FogDistance126( float3 start , float3 direction , float3 destination )
		{
			float3 surface = start + direction * (start.y / direction.y);
			float startToSurface = length(surface - start);
			float startToDest = length(destination - start);
			float belowWater = 
			lerp(
			//Looking down
			startToDest,
			//Looking up
			min(startToDest, startToSurface),
			direction.y >0);
			float aboveWater = max(lerp(
				startToDest - startToSurface,
				0, direction.y > 0),0);
			return lerp(belowWater,aboveWater, start.y > 0);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_vertex4Pos = v.vertex;
			o.data7_g3 = ( (mul( UNITY_MATRIX_MV, ase_vertex4Pos )).xyz * float3(-1,-1,1) );
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Emission = tex2D( _MainTex, uv_MainTex ).rgb;
			float3 start126 = ( _WorldSpaceCameraPos - ( float3(0,1,0) * _Height ) );
			float3 direction126 = -i.viewDir;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float clampDepth11_g3 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float4 appendResult15_g3 = (float4(( clampDepth11_g3 * ( i.data7_g3 * ( _ProjectionParams.z / (i.data7_g3).z ) ) ) , 1.0));
			float3 destination126 = ( mul( unity_CameraToWorld, appendResult15_g3 ) - float4( ( float3(0,1,0) * _Height ) , 0.0 ) ).xyz;
			float localFogDistance126126 = FogDistance126( start126 , direction126 , destination126 );
			o.Alpha = min( saturate( ( localFogDistance126126 * _Density ) ) , _Maximum );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1002;92;918;655;-523.5586;-1336.621;1.784397;True;False
Node;AmplifyShaderEditor.RangedFloatNode;106;-19.58251,2154.832;Float;False;Property;_Height;Height;12;0;Create;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;122;-7.50059,1992.727;Float;False;Constant;_Vector1;Vector 1;13;0;Create;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;163.1841,2104.196;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;118;280.0601,2018.669;Float;False;Reconstruct World Position From Depth;-1;;3;e7094bcbcc80eb140b2a3dbe6a861de8;1;21;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;129;381.0193,1717.475;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;147;590.3325,2122.609;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;127;465.4159,1873.397;Float;False;World;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;128;731.0158,1926.197;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;130;698.1423,1751.968;Float;False;2;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;124;717.1747,2001.563;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;126;903.7328,1934.794;Float;False;float3 surface = start + direction * (start.y / direction.y)@$float startToSurface = length(surface - start)@$float startToDest = length(destination - start)@$$float belowWater = $lerp($//Looking down$startToDest,$//Looking up$min(startToDest, startToSurface),$direction.y >0)@$$$float aboveWater = max(lerp($	startToDest - startToSurface,$	0, direction.y > 0),0)@$$return lerp(belowWater,aboveWater, start.y > 0)@;1;False;3;True;start;FLOAT3;0,0,0;In;True;direction;FLOAT3;0,0,0;In;True;destination;FLOAT3;0,0,0;In;FogDistance;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;912.9064,2082.578;Float;False;Property;_Density;Density;14;0;Create;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;1085.222,1951.779;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;1277.664,2038.526;Float;False;Property;_Maximum;Maximum;13;0;Create;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;114;1248.624,1955.104;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-400.8557,-1168.229;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;419.1194,-1666.13;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;417.3521,-1863.366;Float;True;Property;_TextureSample4;Texture Sample 4;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;19;-121.7806,-1104.435;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;57;747.3762,-1526.2;Float;False;Constant;_Float2;Float 2;8;0;Create;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;42;900.4324,-1013.341;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;53;136.5852,-1820.72;Float;True;Property;_RippleNormals;RippleNormals;9;0;Create;None;130c9934c1a8367418ce5a9389ce7cf9;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;1036.1,-1027.484;Float;False;SurfaceRipples;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;11;114.5514,-275.1329;Float;False;Property;_Bottom;Bottom;7;0;Create;0,0,0,0;0,0.01960784,0.2588234,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;1279.749,969.1902;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;-909.2881,-194.2773;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotatorNode;20;-129.2722,-1222.568;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;778.5356,1019.228;Float;False;-1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;93;715.0454,880.5814;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;1572.827,873.7477;Float;False;WaterSurfacePosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;78;796.6168,1105.433;Float;False;World;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;105;983.5393,975.8578;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;134;1395.374,1765.892;Float;False;Property;_Color;Color;5;0;Create;0,0,0,0;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;21;112.8472,-1213.845;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;17;410.1057,-1045.554;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;1135.706,1088.522;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;36;-348.4728,-1309.513;Float;False;Constant;_Vector0;Vector 0;7;0;Create;2,4;2,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SwizzleNode;39;906.3082,-132.8919;Float;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;3;-1022.068,115.2649;Float;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-623.4611,-1151.285;Float;False;Property;_SurfaceTiling;SurfaceTiling;2;0;Create;512;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;734.1384,65.60616;Float;False;Constant;_Float1;Float 1;8;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;470.4507,-82.9329;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;102.9083,-777.8185;Float;True;Property;_Ripples;Ripples;0;0;Create;None;8719aca685da18547bba4c5efd115203;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;43;738.362,-905.6241;Float;False;Constant;_Float0;Float 0;8;0;Create;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;103;1002.712,1140.968;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;428.7871,-1480.33;Float;True;Property;_TextureSample5;Texture Sample 5;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;40;903.7084,-205.6919;Float;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;5;-758.1094,-7.982532;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;37;106.8272,-1100.213;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;38;109.4272,-989.7127;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;860.8831,-55.85345;Float;False;60;0;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-79.96151,-1357.551;Float;False;Property;_Wavespeed;Wavespeed;4;0;Create;0;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;922.8831,109.1465;Float;False;Property;_Metallioc;Metallioc;10;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;761.8518,-1031.652;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;63;924.8831,181.1465;Float;False;Property;_Smoothness;Smoothness;11;0;Create;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;48;889.8473,37.05949;Float;False;Property;_Opacity;Opacity;8;0;Create;1;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;68;-604.4409,-121.9665;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;59;909.4465,-1633.917;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;610.0027,-432.6663;Float;False;Property;_SurfaceOpacity;SurfaceOpacity;3;0;Create;0.08;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;1437.047,882.4407;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;16;408.3384,-1242.79;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceCameraPos;65;-1277.009,-41.39174;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-1261.948,-209.7427;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;18;419.7735,-859.7538;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;67;-773.2881,-195.2773;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;106.5514,-459.1329;Float;False;Property;_Top;Top;6;0;Create;0,0,0,0;0.1137254,0.5333333,0.6705883,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;1045.114,-1648.06;Float;False;SurfaceRipplesNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1;-1376.371,122.3594;Float;False;Reconstruct World Position From Depth;-1;;4;e7094bcbcc80eb140b2a3dbe6a861de8;1;21;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMinOpNode;148;1417.396,1979.461;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;859.8007,-445.5591;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;770.866,-1652.228;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-894.1094,-6.982532;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;150;1392.56,1504.355;Float;True;Property;_MainTex;MainTex;15;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1793.09,1743.003;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Snail/Shaders/Fog;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Front;2;7;False;0;0;Custom;0.5;True;False;0;True;Opaque;Overlay;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;100;100;100;7;3;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;121;0;122;0
WireConnection;121;1;106;0
WireConnection;147;0;121;0
WireConnection;128;0;127;0
WireConnection;130;0;129;0
WireConnection;130;1;147;0
WireConnection;124;0;118;0
WireConnection;124;1;147;0
WireConnection;126;0;130;0
WireConnection;126;1;128;0
WireConnection;126;2;124;0
WireConnection;141;0;126;0
WireConnection;141;1;142;0
WireConnection;114;0;141;0
WireConnection;30;0;32;0
WireConnection;54;0;53;0
WireConnection;54;1;37;0
WireConnection;55;0;53;0
WireConnection;55;1;21;0
WireConnection;19;0;30;0
WireConnection;19;2;36;2
WireConnection;42;0;26;0
WireConnection;42;1;43;0
WireConnection;50;0;42;0
WireConnection;110;0;78;0
WireConnection;110;1;100;0
WireConnection;66;0;2;0
WireConnection;66;1;65;0
WireConnection;20;0;30;0
WireConnection;20;2;36;1
WireConnection;117;0;102;0
WireConnection;105;0;93;2
WireConnection;105;1;116;0
WireConnection;21;0;20;0
WireConnection;21;2;25;0
WireConnection;17;0;15;0
WireConnection;17;1;37;0
WireConnection;100;0;105;0
WireConnection;100;1;103;0
WireConnection;39;0;28;0
WireConnection;3;0;1;0
WireConnection;7;0;10;0
WireConnection;7;1;11;0
WireConnection;103;0;78;2
WireConnection;56;0;53;0
WireConnection;56;1;38;0
WireConnection;40;0;28;0
WireConnection;5;0;4;0
WireConnection;37;0;19;0
WireConnection;37;2;25;0
WireConnection;38;0;30;0
WireConnection;38;2;25;0
WireConnection;26;0;16;0
WireConnection;26;1;17;0
WireConnection;26;2;18;0
WireConnection;48;0;49;0
WireConnection;48;1;39;0
WireConnection;68;0;67;0
WireConnection;68;1;5;0
WireConnection;59;0;58;0
WireConnection;59;1;57;0
WireConnection;102;0;93;0
WireConnection;102;1;110;0
WireConnection;16;0;15;0
WireConnection;16;1;21;0
WireConnection;18;0;15;0
WireConnection;18;1;38;0
WireConnection;67;0;66;0
WireConnection;60;0;59;0
WireConnection;148;0;114;0
WireConnection;148;1;149;0
WireConnection;28;0;7;0
WireConnection;28;1;42;0
WireConnection;28;2;29;0
WireConnection;58;0;55;0
WireConnection;58;1;54;0
WireConnection;58;2;56;0
WireConnection;4;0;3;0
WireConnection;4;1;65;0
WireConnection;0;2;150;0
WireConnection;0;9;148;0
ASEEND*/
//CHKSM=2456657DCA3C9B13212FDD532A4B24ECAFD09674
