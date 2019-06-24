// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Effects/Blindless"
{
	Properties
	{
		_Distance("Distance", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_Sharpness("Sharpness", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
		ZTest Always
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float3 data7_g1;
		};

		uniform sampler2D _Texture0;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Sharpness;
		uniform sampler2D _GrabTexture;
		uniform float _Distance;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


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
			float4 temp_output_21_0 = mul( unity_CameraToWorld, appendResult15_g1 );
			float4 Pos58 = temp_output_21_0;
			float3 normalizeResult35 = normalize( cross( ddy( temp_output_21_0 ).xyz , ddx( temp_output_21_0 ).xyz ) );
			float3 Normal59 = normalizeResult35;
			float3 temp_cast_2 = (_Sharpness).xxx;
			float3 temp_output_46_0 = pow( abs( Normal59 ) , temp_cast_2 );
			float4 Texture61 = ( ( tex2D( _Texture0, (Pos58).yz ) * ( temp_output_46_0 / ( temp_output_46_0.x + temp_output_46_0.y + temp_output_46_0.z ) ).x ) + ( tex2D( _Texture0, (Pos58).zx ) * ( temp_output_46_0 / ( temp_output_46_0.x + temp_output_46_0.y + temp_output_46_0.z ) ).y ) + ( tex2D( _Texture0, (Pos58).xy ) * ( temp_output_46_0 / ( temp_output_46_0.x + temp_output_46_0.y + temp_output_46_0.z ) ).z ) );
			float3 _Vector0 = float3(0.5,0.5,0.5);
			float3 normalizeResult66 = normalize( _Vector0 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor30 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float3 rotatedValue63 = RotateAroundAxis( screenColor30.rgb, _Vector0, normalizeResult66, _Time.y );
			float4 transform22 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_output_23_0 = ( temp_output_21_0 - transform22 );
			float4 lerpResult28 = lerp( Texture61 , float4( rotatedValue63 , 0.0 ) , ( min( length( temp_output_23_0 ) , _Distance ) / _Distance ));
			o.Emission = lerpResult28.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1095;92;825;926;1098.561;834.7275;1.3;True;False
Node;AmplifyShaderEditor.FunctionNode;21;-1733.877,-178.8864;Float;False;Reconstruct World Position From Depth;-1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;1;21;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RelayNode;36;-1371.484,-428.4368;Float;False;1;0;FLOAT4;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DdyOpNode;32;-1227.789,-453.2731;Float;False;1;0;FLOAT4;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DdxOpNode;33;-1229.564,-384.0864;Float;False;1;0;FLOAT4;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CrossProductOpNode;34;-1094.739,-435.5329;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;35;-929.755,-435.5329;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-866.7848,-1164.259;Float;False;59;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-780.6523,-434.2848;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;45;-684.1888,-1155.098;Float;False;1;0;FLOAT3;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-694.7994,-1077.288;Float;False;Property;_Sharpness;Sharpness;2;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;46;-517.9592,-1140.951;Float;False;2;0;FLOAT3;0.0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;48;-369.4138,-1045.457;Float;False;FLOAT3;1;0;FLOAT3;0.0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-134.2164,-1048.994;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-952.1732,-1596.372;Float;False;58;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1329.858,-197.6411;Float;False;Pos;-1;True;1;0;FLOAT4;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;40;-770.2644,-1899.411;Float;True;Property;_Texture0;Texture 0;1;0;Create;None;None;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;50;-282.5156,-1174.956;Float;False;2;0;FLOAT3;0.0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;22;-1021.583,46.08291;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;37;-709.1642,-1478.459;Float;False;FLOAT2;0;1;2;2;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;39;-714.0678,-1559.571;Float;False;FLOAT2;2;0;2;2;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;38;-715.842,-1639.402;Float;False;FLOAT2;1;2;2;2;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;52;-134.706,-1203.14;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-795.7366,-3.231571;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;43;-501.4655,-1389.351;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-508.5174,-1768.236;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-506.9663,-1578.571;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;121.8419,-1674.781;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LengthOpNode;26;-625.7726,92.31146;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;64;-490.1609,-351.1277;Float;False;Constant;_Vector0;Vector 0;3;0;Create;0.5,0.5,0.5;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;123.8203,-1579.287;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-647.7612,180.2618;Float;False;Property;_Distance;Distance;0;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;130.8939,-1483.793;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;65;-549.9609,-559.1277;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;30;-651.9863,-207.8006;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;318.6391,-1550.992;Float;False;3;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMinOpNode;31;-452.5462,103.7672;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;66;-527.861,-443.4276;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;63;-294.9398,-413.8007;Float;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-310.2041,165.5135;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-356.4236,-7.100037;Float;False;61;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;479.7787,-1555.229;Float;False;Texture;-1;True;1;0;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;24;-608.3109,-9.350149;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;-167.1757,95.54671;Float;False;3;0;COLOR;0.0;False;1;COLOR;0.0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-18.38379,50.58108;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Custom/Blindless;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;7;False;0;0;Opaque;0.5;True;False;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;21;0
WireConnection;32;0;36;0
WireConnection;33;0;36;0
WireConnection;34;0;32;0
WireConnection;34;1;33;0
WireConnection;35;0;34;0
WireConnection;59;0;35;0
WireConnection;45;0;60;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;48;0;46;0
WireConnection;49;0;48;0
WireConnection;49;1;48;1
WireConnection;49;2;48;2
WireConnection;58;0;21;0
WireConnection;50;0;46;0
WireConnection;50;1;49;0
WireConnection;37;0;57;0
WireConnection;39;0;57;0
WireConnection;38;0;57;0
WireConnection;52;0;50;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;43;0;40;0
WireConnection;43;1;37;0
WireConnection;41;0;40;0
WireConnection;41;1;38;0
WireConnection;42;0;40;0
WireConnection;42;1;39;0
WireConnection;53;0;41;0
WireConnection;53;1;52;0
WireConnection;26;0;23;0
WireConnection;54;0;42;0
WireConnection;54;1;52;1
WireConnection;55;0;43;0
WireConnection;55;1;52;2
WireConnection;56;0;53;0
WireConnection;56;1;54;0
WireConnection;56;2;55;0
WireConnection;31;0;26;0
WireConnection;31;1;27;0
WireConnection;66;0;64;0
WireConnection;63;0;66;0
WireConnection;63;1;65;0
WireConnection;63;2;30;0
WireConnection;63;3;64;0
WireConnection;29;0;31;0
WireConnection;29;1;27;0
WireConnection;61;0;56;0
WireConnection;24;0;23;0
WireConnection;28;0;62;0
WireConnection;28;1;63;0
WireConnection;28;2;29;0
WireConnection;0;2;28;0
ASEEND*/
//CHKSM=282A0E506E3061E3F1BA837A4D7544F16773852E
