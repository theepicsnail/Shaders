// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Avatar/Wave/ColorWaves"
{
	Properties
	{
		_NoiseScale("Noise Scale", Float) = 0.1
		_UVxyUV2yT("UVxy, UV2y, T", Vector) = (0,0,0,0)
		_OffsetfromUV2yUV1y("Offset from UV2y, UV1y", Vector) = (0,0,0,0)
		_ColorContribution("Color Contribution", Float) = 1
		_TimingOffset("TimingOffset", Float) = 0
		_WaveRampSlopeOffset("WaveRamp(Slope, Offset)", Vector) = (0,0,0,0)
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_MAKEGRAYSCALE_ON)] _MakeGrayscale("Make Grayscale", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _MAKEGRAYSCALE_ON
		#include "Assets/Snail/AmplifyShader/Noise/Noise.cginc"
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv2_texcoord2;
			float2 uv_texcoord;
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

		uniform float2 _OffsetfromUV2yUV1y;
		uniform float4 _UVxyUV2yT;
		uniform float _NoiseScale;
		uniform float _TimingOffset;
		uniform float2 _WaveRampSlopeOffset;
		uniform float _ColorContribution;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;


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


		half3 SH9(  )
		{
			return ShadeSH9(fixed4(0,0,0,1));
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
			float2 temp_cast_1 = (-0.5).xx;
			float2 uv2_TexCoord2_g76 = i.uv2_texcoord2 + temp_cast_1;
			float temp_output_482_10 = uv2_TexCoord2_g76.y;
			float2 appendResult503 = (float2(temp_output_482_10 , i.uv_texcoord.y));
			float dotResult501 = dot( _OffsetfromUV2yUV1y , appendResult503 );
			float4 appendResult488 = (float4(i.uv_texcoord , temp_output_482_10 , _Time.y));
			float4 In07_g77 = ( appendResult488 * _UVxyUV2yT );
			float localsnoise47_g77 = snoise4( In07_g77 );
			float mulTime4_g78 = _Time.y * 0.1;
			float temp_output_7_0_g79 = ( ( dotResult501 + ( (localsnoise47_g77*0.5 + 0.5) * _NoiseScale ) + _TimingOffset ) + mulTime4_g78 );
			float temp_output_2_0_g79 = floor( temp_output_7_0_g79 );
			float WaveNumber7_g78 = temp_output_2_0_g79;
			float temp_output_22_0_g78 = ( 0.0 + ( 1.618 * WaveNumber7_g78 ) );
			float3 hsvTorgb16_g78 = HSVToRGB( float3(temp_output_22_0_g78,1.0,1.0) );
			float3 Color480 = hsvTorgb16_g78;
			float temp_output_2_0_g103 = _ColorContribution;
			float temp_output_3_0_g103 = ( 1.0 - temp_output_2_0_g103 );
			float3 appendResult7_g103 = (float3(temp_output_3_0_g103 , temp_output_3_0_g103 , temp_output_3_0_g103));
			float3 temp_output_505_0 = ( ( Color480 * temp_output_2_0_g103 ) + appendResult7_g103 );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode8_g104 = tex2D( _MainTex, uv_MainTex );
			float3 temp_output_2_0_g104 = (tex2DNode8_g104).rgb;
			float dotResult5_g105 = dot( temp_output_2_0_g104 , float3(0.3,0.59,0.11) );
			float temp_output_10_0_g104 = dotResult5_g105;
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g104 = (temp_output_10_0_g104).xxx;
			#else
				float3 staticSwitch5_g104 = temp_output_2_0_g104;
			#endif
			half3 localSH98_g106 = SH9();
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			c.rgb = ( temp_output_505_0 * staticSwitch5_g104 * ( localSH98_g106 + (( ase_lightColor.rgb * ase_lightAtten )).xyz ) );
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
			float2 temp_cast_0 = (-0.5).xx;
			float2 uv2_TexCoord2_g76 = i.uv2_texcoord2 + temp_cast_0;
			float temp_output_482_10 = uv2_TexCoord2_g76.y;
			float2 appendResult503 = (float2(temp_output_482_10 , i.uv_texcoord.y));
			float dotResult501 = dot( _OffsetfromUV2yUV1y , appendResult503 );
			float4 appendResult488 = (float4(i.uv_texcoord , temp_output_482_10 , _Time.y));
			float4 In07_g77 = ( appendResult488 * _UVxyUV2yT );
			float localsnoise47_g77 = snoise4( In07_g77 );
			float mulTime4_g78 = _Time.y * 0.1;
			float temp_output_7_0_g79 = ( ( dotResult501 + ( (localsnoise47_g77*0.5 + 0.5) * _NoiseScale ) + _TimingOffset ) + mulTime4_g78 );
			float temp_output_1_0_g79 = frac( temp_output_7_0_g79 );
			float WavePercent8_g78 = temp_output_1_0_g79;
			float Emission479 = saturate( (WavePercent8_g78*_WaveRampSlopeOffset.x + _WaveRampSlopeOffset.y) );
			float temp_output_2_0_g79 = floor( temp_output_7_0_g79 );
			float WaveNumber7_g78 = temp_output_2_0_g79;
			float temp_output_22_0_g78 = ( 0.0 + ( 1.618 * WaveNumber7_g78 ) );
			float3 hsvTorgb16_g78 = HSVToRGB( float3(temp_output_22_0_g78,1.0,1.0) );
			float3 Color480 = hsvTorgb16_g78;
			float temp_output_2_0_g103 = _ColorContribution;
			float temp_output_3_0_g103 = ( 1.0 - temp_output_2_0_g103 );
			float3 appendResult7_g103 = (float3(temp_output_3_0_g103 , temp_output_3_0_g103 , temp_output_3_0_g103));
			float3 temp_output_505_0 = ( ( Color480 * temp_output_2_0_g103 ) + appendResult7_g103 );
			o.Emission = ( Emission479 * temp_output_505_0 );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1075;92;845;926;2424.421;-1992.309;1.3;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;497;-2495.433,2180.899;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;482;-2473.795,2307.423;Float;False;UVObjectSpace;-1;;76;9616a67f3c171a94da24dc8433ee10ec;0;0;4;FLOAT3;0;FLOAT;9;FLOAT;10;FLOAT;11
Node;AmplifyShaderEditor.SimpleTimeNode;487;-2419.941,2604.201;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;490;-2298.625,2725.42;Float;False;Property;_UVxyUV2yT;UVxy, UV2y, T;4;0;Create;True;0;0;False;0;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;488;-2201.804,2472.869;Float;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;489;-1992.224,2691.917;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;496;-1813.6,2759.369;Float;False;Property;_NoiseScale;Noise Scale;3;0;Create;True;0;0;False;0;0.1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;502;-2044.023,2147.78;Float;False;Property;_OffsetfromUV2yUV1y;Offset from UV2y, UV1y;5;0;Create;True;0;0;False;0;0,0;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;491;-1844.874,2603.476;Float;False;Noise;-1;;77;34284a2bf01a18b409ebe6db69d3e268;2,2,2,10,1;3;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;503;-2057.023,2338.88;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;-1647.096,2632.969;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;501;-1889.323,2333.68;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;508;-1673.633,2846.95;Float;False;Property;_TimingOffset;TimingOffset;7;0;Create;True;0;0;False;0;0;-0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;493;-1489.797,2560.167;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;499;-1258.576,2304.512;Float;False;Property;_WaveRampSlopeOffset;WaveRamp(Slope, Offset);8;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;481;-1291.207,2582.931;Float;False;PolyColorWave;-1;;78;935e4bdb3e312ab41b195abf4de01678;0;4;19;FLOAT;0;False;21;FLOAT;0;False;15;FLOAT;1;False;13;FLOAT;1;False;4;FLOAT;26;FLOAT;1;FLOAT;2;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;498;-947.576,2308.512;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;483;-754.569,2307.902;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;480;-983.9136,2646.832;Float;False;Color;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;507;-122.4174,2377.71;Float;False;Property;_ColorContribution;Color Contribution;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;478;-85.42095,2300.637;Float;False;480;Color;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;479;-623.3134,2304.633;Float;False;Emission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;477;161.3461,2158.525;Float;False;479;Emission;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;518;17.33398,2610.657;Float;False;FlatLighting;0;;106;fc517e88685f04d45a66f4bd14b48aba;1,27,1;4;30;FLOAT;1;False;25;FLOAT3;0,0,0;False;22;FLOAT;0;False;20;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;505;146.1913,2380.138;Float;False;Lerp White To;-1;;103;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;473;-7.447937,2485.213;Float;False;MainTex;9;;104;45db3e40c3069804caaf81bcab512992;0;0;3;FLOAT;11;FLOAT;9;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;475;358.884,2526.843;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;476;347.576,2343.869;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;34;568.4861,2300.892;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Waves;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;False;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;488;0;497;0
WireConnection;488;2;482;10
WireConnection;488;3;487;0
WireConnection;489;0;488;0
WireConnection;489;1;490;0
WireConnection;491;5;489;0
WireConnection;503;0;482;10
WireConnection;503;1;497;2
WireConnection;495;0;491;0
WireConnection;495;1;496;0
WireConnection;501;0;502;0
WireConnection;501;1;503;0
WireConnection;493;0;501;0
WireConnection;493;1;495;0
WireConnection;493;2;508;0
WireConnection;481;19;493;0
WireConnection;498;0;481;2
WireConnection;498;1;499;1
WireConnection;498;2;499;2
WireConnection;483;0;498;0
WireConnection;480;0;481;0
WireConnection;479;0;483;0
WireConnection;505;1;478;0
WireConnection;505;2;507;0
WireConnection;475;0;505;0
WireConnection;475;1;473;0
WireConnection;475;2;518;0
WireConnection;476;0;477;0
WireConnection;476;1;505;0
WireConnection;34;2;476;0
WireConnection;34;13;475;0
ASEEND*/
//CHKSM=F6E3D2F40DC59665664FE8FA389FB0D6692D47CD
