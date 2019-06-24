// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Avatar/Wave/heterochromia"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Float3("Float 3", Float) = 0
		_Float4("Float 4", Float) = 41.84
		_BaseEmission("Base Emission", Float) = 0
		_Float5("Float 5", Float) = 0
		_Float8("Float 8", Float) = 0.1
		_Float6("Float 6", Float) = 0.1
		_Float7("Float 7", Float) = 40
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_MAKEGRAYSCALE_ON)] _MakeGrayscale("Make Grayscale", Float) = 0
		_LightRamp("LightRamp", 2D) = "white" {}
		[Toggle(_FLIPLIGHTRAMP_ON)] _FlipLightRamp("Flip Light Ramp", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _MAKEGRAYSCALE_ON
		#pragma shader_feature _FLIPLIGHTRAMP_ON
		#include "Assets/Snail/AmplifyShader/Noise/Noise.cginc"
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			float2 uv2_texcoord2;
			float2 uv3_texcoord3;
			float3 worldPos;
			float3 worldNormal;
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

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _BaseEmission;
		uniform float _Float3;
		uniform float _Float5;
		uniform float _Float4;
		uniform float _Float7;
		uniform float _Float6;
		uniform float _Float8;
		uniform sampler2D _LightRamp;
		uniform float _EdgeLength;


		inline float snoise4( float4 In0 )
		{
			return snoise(In0);
		}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		inline float snoise3( float3 In0 )
		{
			return snoise(In0);
		}


		half3 SH9(  )
		{
			return ShadeSH9(fixed4(0,0,0,1));
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode8_g6 = tex2D( _MainTex, uv_MainTex );
			float3 temp_output_2_0_g6 = (tex2DNode8_g6).rgb;
			float dotResult5_g7 = dot( temp_output_2_0_g6 , float3(0.3,0.59,0.11) );
			float temp_output_10_0_g6 = dotResult5_g7;
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g6 = (temp_output_10_0_g6).xxx;
			#else
				float3 staticSwitch5_g6 = temp_output_2_0_g6;
			#endif
			float2 temp_cast_2 = (-0.5).xx;
			float2 uv2_TexCoord2_g51 = i.uv2_texcoord2 + temp_cast_2;
			float2 temp_cast_3 = (-0.5).xx;
			float2 uv3_TexCoord1_g51 = i.uv3_texcoord3 + temp_cast_3;
			float3 appendResult3_g51 = (float3(uv2_TexCoord2_g51 , uv3_TexCoord1_g51.x));
			float3 In06_g52 = ( appendResult3_g51 * _Float7 );
			float localsnoise36_g52 = snoise3( In06_g52 );
			float mulTime4_g4 = _Time.y * 0.1;
			float temp_output_7_0_g5 = ( ( ( localsnoise36_g52 * _Float6 ) + ( uv2_TexCoord2_g51.y * _Float8 ) ) + mulTime4_g4 );
			float temp_output_2_0_g5 = floor( temp_output_7_0_g5 );
			float WaveNumber7_g4 = temp_output_2_0_g5;
			float temp_output_22_0_g4 = ( 0.0 + ( 1.618 * WaveNumber7_g4 ) );
			float3 hsvTorgb16_g4 = HSVToRGB( float3(temp_output_22_0_g4,1.0,1.0) );
			float3 Color221 = hsvTorgb16_g4;
			float3 temp_output_76_0 = ( staticSwitch5_g6 * Color221 );
			half3 localSH98_g49 = SH9();
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult2_g49 = dot( ase_worldlightDir , ase_normWorldNormal );
			float lerpResult7_g49 = lerp( saturate( dotResult2_g49 ) , sqrt( ase_lightAtten ) , _WorldSpaceLightPos0.w);
			float2 _Vector0 = float2(0,1);
			#ifdef _FLIPLIGHTRAMP_ON
				float staticSwitch12_g49 = _Vector0.y;
			#else
				float staticSwitch12_g49 = _Vector0.x;
			#endif
			float lerpResult23_g49 = lerp( lerpResult7_g49 , ( 1.0 - lerpResult7_g49 ) , staticSwitch12_g49);
			float2 temp_cast_4 = (lerpResult23_g49).xx;
			c.rgb = ( temp_output_76_0 * ( localSH98_g49 + (( ase_lightColor * tex2D( _LightRamp, temp_cast_4 ) * ase_lightAtten )).rgb ) );
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
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode8_g6 = tex2D( _MainTex, uv_MainTex );
			float3 temp_output_2_0_g6 = (tex2DNode8_g6).rgb;
			float dotResult5_g7 = dot( temp_output_2_0_g6 , float3(0.3,0.59,0.11) );
			float temp_output_10_0_g6 = dotResult5_g7;
			float3 temp_output_227_0 = ( i.viewDir * _Float3 );
			float mulTime234 = _Time.y * _Float5;
			float4 appendResult233 = (float4(temp_output_227_0 , mulTime234));
			float4 In07_g3 = appendResult233;
			float localsnoise47_g3 = snoise4( In07_g3 );
			float Emission222 = pow( (localsnoise47_g3*0.5 + 0.5) , _Float4 );
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g6 = (temp_output_10_0_g6).xxx;
			#else
				float3 staticSwitch5_g6 = temp_output_2_0_g6;
			#endif
			float2 temp_cast_0 = (-0.5).xx;
			float2 uv2_TexCoord2_g51 = i.uv2_texcoord2 + temp_cast_0;
			float2 temp_cast_1 = (-0.5).xx;
			float2 uv3_TexCoord1_g51 = i.uv3_texcoord3 + temp_cast_1;
			float3 appendResult3_g51 = (float3(uv2_TexCoord2_g51 , uv3_TexCoord1_g51.x));
			float3 In06_g52 = ( appendResult3_g51 * _Float7 );
			float localsnoise36_g52 = snoise3( In06_g52 );
			float mulTime4_g4 = _Time.y * 0.1;
			float temp_output_7_0_g5 = ( ( ( localsnoise36_g52 * _Float6 ) + ( uv2_TexCoord2_g51.y * _Float8 ) ) + mulTime4_g4 );
			float temp_output_2_0_g5 = floor( temp_output_7_0_g5 );
			float WaveNumber7_g4 = temp_output_2_0_g5;
			float temp_output_22_0_g4 = ( 0.0 + ( 1.618 * WaveNumber7_g4 ) );
			float3 hsvTorgb16_g4 = HSVToRGB( float3(temp_output_22_0_g4,1.0,1.0) );
			float3 Color221 = hsvTorgb16_g4;
			float3 temp_output_76_0 = ( staticSwitch5_g6 * Color221 );
			o.Emission = ( (temp_output_10_0_g6*_BaseEmission + Emission222) * temp_output_76_0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.customPack2.xy = customInputData.uv3_texcoord3;
				o.customPack2.xy = v.texcoord2;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				surfIN.uv3_texcoord3 = IN.customPack2.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
733;92;1187;926;2192.589;1023.355;1.703651;True;False
Node;AmplifyShaderEditor.RangedFloatNode;258;-1260.991,-340.4611;Float;False;Property;_Float7;Float 7;11;0;Create;True;0;0;False;0;40;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;245;-1324.397,-486.2066;Float;False;UVObjectSpace;-1;;51;9616a67f3c171a94da24dc8433ee10ec;0;0;4;FLOAT3;0;FLOAT;9;FLOAT;10;FLOAT;11
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;-1108.263,-476.0693;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-1673.461,-684.1885;Float;False;Property;_Float5;Float 5;8;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;238;-1884.72,-1253.381;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;228;-1863.567,-815.8998;Float;False;Property;_Float3;Float 3;5;0;Create;True;0;0;False;0;0;90;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;254;-980.6621,-476.7691;Float;False;Noise;-1;;52;34284a2bf01a18b409ebe6db69d3e268;2,2,1,10,0;3;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-1210.733,-193.6002;Float;False;Property;_Float8;Float 8;9;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-958.8908,-363.161;Float;False;Property;_Float6;Float 6;10;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;-1676.567,-880.8998;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;234;-1487.461,-704.1885;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;233;-1313.461,-786.1885;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;-782.6586,-472.0545;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-975.0907,-265.1613;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;263;-575.3323,-453.9002;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;232;-1109.461,-749.2883;Float;False;Property;_Float4;Float 4;6;0;Create;True;0;0;False;0;41.84;105.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;230;-1168.867,-847.1999;Float;False;Noise;-1;;3;34284a2bf01a18b409ebe6db69d3e268;2,2,2,10,1;3;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;239;-918.8206,-791.881;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;225;-396.4973,-496.7787;Float;False;PolyColorWave;-1;;4;935e4bdb3e312ab41b195abf4de01678;0;4;19;FLOAT;0;False;21;FLOAT;0;False;15;FLOAT;1;False;13;FLOAT;1;False;4;FLOAT;26;FLOAT;1;FLOAT;2;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-315.5004,-882.7661;Float;False;Emission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;221;-97.58411,-430.0099;Float;False;Color;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;244;429.9708,-1192.713;Float;False;Property;_BaseEmission;Base Emission;7;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;415.5667,-1112.426;Float;False;222;Emission;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;443.4171,-899.9348;Float;False;221;Color;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;241;439.4818,-1025.749;Float;False;MainTex;13;;6;45db3e40c3069804caaf81bcab512992;0;0;3;FLOAT;11;FLOAT;9;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;72;608.4487,-770.7225;Float;False;FlatLighting;16;;49;fc517e88685f04d45a66f4bd14b48aba;1,27,0;4;30;FLOAT;1;False;25;FLOAT3;0,0,0;False;22;FLOAT;0;False;20;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;243;648.9706,-1201.413;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;655.2424,-969.7844;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;86;685.7256,-1467.582;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;26;554.9877,-1462.41;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;224;-609.9863,-1177.405;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;237;-1499.921,-868.5804;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;885.1143,-1115.161;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;16;347.9336,-1392.482;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;223;-577.9863,-989.4049;Float;False;Property;_Float0;Float 0;12;0;Create;True;0;0;False;0;0;-0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;886.0901,-794.9178;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;34;360.9106,-1491.802;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;236;-1905.52,-986.8798;Float;False;UVObjectSpace;-1;;50;9616a67f3c171a94da24dc8433ee10ec;0;0;4;FLOAT3;0;FLOAT;9;FLOAT;10;FLOAT;11
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;75;1164.786,-1031.525;Float;False;True;6;Float;ASEMaterialInspector;0;0;CustomLighting;heterochromia;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;251;0;245;0
WireConnection;251;1;258;0
WireConnection;254;4;251;0
WireConnection;227;0;238;0
WireConnection;227;1;228;0
WireConnection;234;0;235;0
WireConnection;233;0;227;0
WireConnection;233;3;234;0
WireConnection;255;0;254;0
WireConnection;255;1;256;0
WireConnection;261;0;245;10
WireConnection;261;1;262;0
WireConnection;263;0;255;0
WireConnection;263;1;261;0
WireConnection;230;5;233;0
WireConnection;239;0;230;0
WireConnection;239;1;232;0
WireConnection;225;19;263;0
WireConnection;222;0;239;0
WireConnection;221;0;225;0
WireConnection;243;0;241;11
WireConnection;243;1;244;0
WireConnection;243;2;209;0
WireConnection;76;0;241;0
WireConnection;76;1;162;0
WireConnection;86;0;26;0
WireConnection;26;0;34;0
WireConnection;26;1;16;0
WireConnection;237;0;227;0
WireConnection;77;0;243;0
WireConnection;77;1;76;0
WireConnection;10;0;76;0
WireConnection;10;1;72;0
WireConnection;75;2;77;0
WireConnection;75;13;10;0
ASEEND*/
//CHKSM=74BA42124861BD0EBCDF2030F8EAE9EF5F8C872D
