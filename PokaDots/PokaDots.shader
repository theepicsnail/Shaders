// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/PokaDots/PokaDots"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows 
		struct Input
		{
			fixed filler;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = float3(0,0,0);
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
			o.Albedo = float3(1,0,0);
			o.Emission = float3(0,0,0);
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1015;92;905;926;-1305.111;431.9294;1.249482;True;False
Node;AmplifyShaderEditor.CommentaryNode;75;-236.3498,-678.8059;Float;False;1770.127;410.4276;Hue Per Voxel;4;74;71;70;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;66;-2152.987,-139.4777;Float;False;802.1416;479.1716;Object space scaling (done in world space);6;27;32;34;65;63;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;74;553.2379,-620.1178;Float;False;751.5479;308.7677;Compute a controllable hue value;4;37;40;73;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;69;-187.9089,-151.2996;Float;False;743.4688;257;Spheres that are 1 in the center and go down as they go out;4;5;7;6;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;64;-1819.321,-484.047;Float;False;469.968;306.6848;World space Scaling;3;31;30;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;70;-176.9581,-433.3781;Float;False;283;165;Unique voxel value;1;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;71;-186.3498,-628.8059;Float;False;724.6002;187.0997;Unique voxel noise (over time);4;21;25;23;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;68;-637.7368,-293.115;Float;False;326.0365;243.115;ID(floor) and Position(fract);3;41;15;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-1135.33,-264.2463;Float;False;405.0721;267.6144;Mix for final space;3;33;3;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-126.9581,-383.3781;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;-1859.976,52.52234;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;175.4506,-574.7062;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-136.3498,-578.8058;Float;False;Property;_Speed;Speed;3;0;Create;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;63;-1912.976,-89.47766;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-1695.519,30.84457;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1748.359,-356.3622;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;26;-2102.987,28.55409;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;21;4.650858,-575.3062;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;78;2050.03,-127.5518;Float;False;Constant;_Vector1;Vector 1;6;0;Create;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RelayNode;41;-587.7368,-203.8936;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;80;2052.03,128.4482;Float;False;Constant;_Vector3;Vector 3;6;0;Create;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;79;2050.03,1.448242;Float;False;Constant;_Vector2;Vector 2;6;0;Create;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-1085.33,-111.6319;Float;False;Property;_OverallScale;OverallScale;2;0;Create;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;15;-469.3843,-243.115;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-899.2581,-209.7516;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1040.005,-214.2463;Float;False;2;2;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1519.846,41.32976;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FractNode;2;-465.7002,-160;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;305.2503,-575.5062;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;1675.951,-127.9231;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;1828.03,-37.55176;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;5;54.04544,-98.0649;Float;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;977.3327,-570.1178;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;37;603.2379,-495.3495;Float;False;Property;_HueVarianceOffsetCycleSpeed_;Hue <Variance, Offset, CycleSpeed,_>;4;0;Create;0,0,0;0.2,0,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;6;-137.909,-101.2996;Float;False;Constant;_Vector0;Vector 0;1;0;Create;0,1,-1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;7;234.0455,-97.0649;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1769.321,-434.047;Float;False;Property;_WorldSpaceScale;WorldSpaceScale;0;0;Create;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;368.5599,-97.1783;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1518.353,-396.5945;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1780.603,224.6939;Float;False;Property;_Objectspacescale;Object space scale;1;0;Create;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;40;972.8631,-421.7009;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;1681.03,-22.55176;Float;False;Property;_Emission;Emission;5;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;17;1329.777,-471.343;Float;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.SimpleAddOpNode;72;1150.786,-468.4382;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2307.443,-128.122;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Custom/PokaDots;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0,0,0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;15;0
WireConnection;65;0;26;1
WireConnection;65;1;26;2
WireConnection;65;2;26;3
WireConnection;23;0;21;0
WireConnection;23;1;16;0
WireConnection;27;0;63;0
WireConnection;27;1;65;0
WireConnection;21;0;25;0
WireConnection;41;0;3;0
WireConnection;15;0;41;0
WireConnection;3;0;33;0
WireConnection;3;1;4;0
WireConnection;33;0;30;0
WireConnection;33;1;32;0
WireConnection;32;0;27;0
WireConnection;32;1;34;0
WireConnection;2;0;41;0
WireConnection;20;0;23;0
WireConnection;13;0;17;6
WireConnection;13;1;19;0
WireConnection;77;0;13;0
WireConnection;77;1;76;0
WireConnection;5;0;2;0
WireConnection;5;1;6;1
WireConnection;5;2;6;2
WireConnection;5;3;6;3
WireConnection;5;4;6;4
WireConnection;73;0;20;0
WireConnection;73;1;37;1
WireConnection;7;0;5;0
WireConnection;19;0;7;0
WireConnection;30;0;31;0
WireConnection;30;1;1;0
WireConnection;40;0;37;3
WireConnection;17;1;72;0
WireConnection;72;0;73;0
WireConnection;72;1;37;2
WireConnection;72;2;40;0
WireConnection;0;0;78;0
WireConnection;0;2;79;0
WireConnection;0;13;80;0
ASEEND*/
//CHKSM=302F0B6692D71AE5793256E755DA2C0C08CADE0E
