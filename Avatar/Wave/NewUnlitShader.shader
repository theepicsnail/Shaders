// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Avatar/Wave/NewUnlitShader"
{
	Properties
	{
		_Float6("Float 6", Float) = 0.5
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_MAKEGRAYSCALE_ON)] _MakeGrayscale("Make Grayscale", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv3_texcoord3;
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

		uniform float4 _Vector0;
		uniform float _Float6;
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


		inline float snoise2( float2 In0 )
		{
			return snoise(In0);
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
			float mulTime4_g58 = _Time.y * 0.1;
			float temp_output_7_0_g59 = ( 0.0 + mulTime4_g58 );
			float temp_output_2_0_g59 = floor( temp_output_7_0_g59 );
			float WaveNumber7_g58 = temp_output_2_0_g59;
			float waveNumber317 = WaveNumber7_g58;
			float2 appendResult271 = (float2(0.0 , waveNumber317));
			float2 In01_g52 = appendResult271;
			float localsnoise21_g52 = snoise2( In01_g52 );
			float2 appendResult300 = (float2(100.0 , waveNumber317));
			float2 In01_g54 = appendResult300;
			float localsnoise21_g54 = snoise2( In01_g54 );
			float2 appendResult298 = (float2(pow( 10.0 , ( 2.0 * localsnoise21_g52 ) ) , pow( 10.0 , ( 2.0 * localsnoise21_g54 ) )));
			float2 uvScale319 = appendResult298;
			float2 In01_g55 = ( i.uv_texcoord * uvScale319 );
			float localsnoise21_g55 = snoise2( In01_g55 );
			float mulTime4_g60 = _Time.y * 0.1;
			float temp_output_7_0_g61 = ( ( (localsnoise21_g55*0.5 + 0.5) * _Float6 ) + mulTime4_g60 );
			float temp_output_2_0_g61 = floor( temp_output_7_0_g61 );
			float WaveNumber7_g60 = temp_output_2_0_g61;
			float3 hsvTorgb16_g60 = HSVToRGB( float3(( 0.0 + ( 1.618 * WaveNumber7_g60 ) ),1.0,1.0) );
			float3 PreviousWave321 = hsvTorgb16_g60;
			float3 hsvTorgb16_g58 = HSVToRGB( float3(( 0.0 + ( 1.618 * WaveNumber7_g58 ) ),1.0,1.0) );
			float temp_output_1_0_g59 = frac( temp_output_7_0_g59 );
			float WavePercent8_g58 = temp_output_1_0_g59;
			float3 lerpResult282 = lerp( PreviousWave321 , hsvTorgb16_g58 , WavePercent8_g58);
			float3 Color186 = lerpResult282;
			half3 localSH98_g51 = SH9();
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode8_g49 = tex2D( _MainTex, uv_MainTex );
			float3 temp_output_2_0_g49 = (tex2DNode8_g49).rgb;
			float dotResult5_g50 = dot( temp_output_2_0_g49 , float3(0.3,0.59,0.11) );
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g49 = (dotResult5_g50).xxx;
			#else
				float3 staticSwitch5_g49 = temp_output_2_0_g49;
			#endif
			c.rgb = ( Color186 * ( localSH98_g51 + (( ase_lightColor * float4( ( float3(1,1,1) * 1.0 ) , 0.0 ) * ase_lightAtten )).rgb ) * staticSwitch5_g49 );
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
			float2 uv2_TexCoord2_g45 = i.uv2_texcoord2 + temp_cast_0;
			float2 temp_cast_1 = (-0.5).xx;
			float2 uv3_TexCoord1_g45 = i.uv3_texcoord3 + temp_cast_1;
			float3 appendResult3_g45 = (float3(uv2_TexCoord2_g45 , uv3_TexCoord1_g45.x));
			float4 appendResult177 = (float4(appendResult3_g45 , _Time.y));
			float4 In07_g46 = ( appendResult177 * _Vector0 );
			float localsnoise47_g46 = snoise4( In07_g46 );
			float Noise182 = localsnoise47_g46;
			float2 _SparkleSharpBrightness = float2(50,0.25);
			float Sparkle184 = ( pow( abs( Noise182 ) , _SparkleSharpBrightness.x ) * _SparkleSharpBrightness.y );
			float mulTime4_g58 = _Time.y * 0.1;
			float temp_output_7_0_g59 = ( 0.0 + mulTime4_g58 );
			float temp_output_2_0_g59 = floor( temp_output_7_0_g59 );
			float WaveNumber7_g58 = temp_output_2_0_g59;
			float waveNumber317 = WaveNumber7_g58;
			float2 appendResult271 = (float2(0.0 , waveNumber317));
			float2 In01_g52 = appendResult271;
			float localsnoise21_g52 = snoise2( In01_g52 );
			float2 appendResult300 = (float2(100.0 , waveNumber317));
			float2 In01_g54 = appendResult300;
			float localsnoise21_g54 = snoise2( In01_g54 );
			float2 appendResult298 = (float2(pow( 10.0 , ( 2.0 * localsnoise21_g52 ) ) , pow( 10.0 , ( 2.0 * localsnoise21_g54 ) )));
			float2 uvScale319 = appendResult298;
			float2 In01_g55 = ( i.uv_texcoord * uvScale319 );
			float localsnoise21_g55 = snoise2( In01_g55 );
			float mulTime4_g60 = _Time.y * 0.1;
			float temp_output_7_0_g61 = ( ( (localsnoise21_g55*0.5 + 0.5) * _Float6 ) + mulTime4_g60 );
			float temp_output_2_0_g61 = floor( temp_output_7_0_g61 );
			float WaveNumber7_g60 = temp_output_2_0_g61;
			float3 hsvTorgb16_g60 = HSVToRGB( float3(( 0.0 + ( 1.618 * WaveNumber7_g60 ) ),1.0,1.0) );
			float3 PreviousWave321 = hsvTorgb16_g60;
			float3 hsvTorgb16_g58 = HSVToRGB( float3(( 0.0 + ( 1.618 * WaveNumber7_g58 ) ),1.0,1.0) );
			float temp_output_1_0_g59 = frac( temp_output_7_0_g59 );
			float WavePercent8_g58 = temp_output_1_0_g59;
			float3 lerpResult282 = lerp( PreviousWave321 , hsvTorgb16_g58 , WavePercent8_g58);
			float3 Color186 = lerpResult282;
			o.Emission = ( Sparkle184 * Color186 );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
7;29;1906;1004;3394.499;-615.2343;1;True;False
Node;AmplifyShaderEditor.FunctionNode;323;-2974.711,1384.398;Float;False;PolyColorWave;-1;;58;935e4bdb3e312ab41b195abf4de01678;0;4;19;FLOAT;0;False;21;FLOAT;0;False;15;FLOAT;1;False;13;FLOAT;1;False;3;FLOAT;1;FLOAT;2;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;317;-2656.906,1286.318;Float;False;waveNumber;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;318;-3146.963,563.5168;Float;False;317;waveNumber;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;302;-3087.27,490.1025;Float;False;Constant;_Float5;Float 5;7;0;Create;True;0;0;False;0;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-3078.513,404.5239;Float;False;Constant;_Float8;Float 8;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;300;-2931.912,536.4064;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;271;-2923.155,450.8286;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;270;-2782.623,451.5744;Float;False;Noise;-1;;52;34284a2bf01a18b409ebe6db69d3e268;2,2,0,10,0;3;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;293;-2722.705,362.8885;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;301;-2791.379,537.1523;Float;False;Noise;-1;;54;34284a2bf01a18b409ebe6db69d3e268;2,2,0,10,0;3;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;295;-2556.705,333.6002;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-2537.126,508.0441;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-2535.84,414.0114;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;304;-2375.696,468.5102;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;294;-2378.447,339.5997;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;298;-2216.792,394.2763;Float;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;176;-4432.626,732.1107;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;100;-4458.192,582.4727;Float;False;UVObjectSpace;-1;;45;9616a67f3c171a94da24dc8433ee10ec;0;0;4;FLOAT3;0;FLOAT;9;FLOAT;10;FLOAT;11
Node;AmplifyShaderEditor.RegisterLocalVarNode;319;-2069.266,428.3173;Float;False;uvScale;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;177;-4227.224,637.2106;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;320;-3051.356,956.5524;Float;False;319;uvScale;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;242;-3109.722,837.6503;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;178;-4329.925,819.2106;Float;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;0,0,0,0;100,100,100,0.1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;-2871.698,877.6637;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-4068.287,708.2057;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;307;-2735.835,874.2189;Float;False;Noise;-1;;55;34284a2bf01a18b409ebe6db69d3e268;2,2,0,10,1;3;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;224;-3927.912,708.3328;Float;False;Noise;-1;;46;34284a2bf01a18b409ebe6db69d3e268;2,2,2,10,0;3;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;309;-2716.259,956.7744;Float;False;Property;_Float6;Float 6;3;0;Create;True;0;0;False;0;0.5;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;-2536.891,912.0167;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;182;-3736.032,696.6696;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;324;-2394.806,910.2325;Float;False;PolyColorWave;-1;;60;935e4bdb3e312ab41b195abf4de01678;0;4;19;FLOAT;0;False;21;FLOAT;0;False;15;FLOAT;1;False;13;FLOAT;1;False;3;FLOAT;1;FLOAT;2;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-4443.735,1116.141;Float;False;182;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;180;-4269.327,1126.883;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;263;-4420.481,1212.946;Float;False;Constant;_SparkleSharpBrightness;Sparkle(Sharp,Brightness);7;0;Create;True;0;0;False;0;50,0.25;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;321;-2105.702,952.7328;Float;False;PreviousWave;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;179;-4138.025,1126.884;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;-2671.128,1374.679;Float;False;321;PreviousWave;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;-3988.636,1157.652;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;282;-2457.965,1380.598;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;-3824.733,1129.541;Float;False;Sparkle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;-2297.466,1372.556;Float;False;Color;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;203;-1318.569,935.8109;Float;False;MainTex;5;;49;45db3e40c3069804caaf81bcab512992;0;0;2;FLOAT;9;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;116;-1431.987,860.7542;Float;False;FlatLighting;0;;51;fc517e88685f04d45a66f4bd14b48aba;1,27,1;4;30;FLOAT;1;False;25;FLOAT3;0,0,0;False;22;FLOAT;0;False;20;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-1352.975,650.6226;Float;False;184;Sparkle;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-1349.942,751.4321;Float;False;186;Color;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1149.437,836.9401;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-1160.745,653.9665;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;232;-991.4911,607.5772;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Hair;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;317;0;323;1
WireConnection;300;0;302;0
WireConnection;300;1;318;0
WireConnection;271;0;285;0
WireConnection;271;1;318;0
WireConnection;270;3;271;0
WireConnection;301;3;300;0
WireConnection;306;0;293;0
WireConnection;306;1;301;0
WireConnection;292;0;293;0
WireConnection;292;1;270;0
WireConnection;304;0;295;0
WireConnection;304;1;306;0
WireConnection;294;0;295;0
WireConnection;294;1;292;0
WireConnection;298;0;294;0
WireConnection;298;1;304;0
WireConnection;319;0;298;0
WireConnection;177;0;100;0
WireConnection;177;3;176;0
WireConnection;299;0;242;0
WireConnection;299;1;320;0
WireConnection;172;0;177;0
WireConnection;172;1;178;0
WireConnection;307;3;299;0
WireConnection;224;5;172;0
WireConnection;308;0;307;0
WireConnection;308;1;309;0
WireConnection;182;0;224;0
WireConnection;324;19;308;0
WireConnection;180;0;183;0
WireConnection;321;0;324;0
WireConnection;179;0;180;0
WireConnection;179;1;263;1
WireConnection;201;0;179;0
WireConnection;201;1;263;2
WireConnection;282;0;322;0
WireConnection;282;1;323;0
WireConnection;282;2;323;2
WireConnection;184;0;201;0
WireConnection;186;0;282;0
WireConnection;70;0;187;0
WireConnection;70;1;116;0
WireConnection;70;2;203;0
WireConnection;175;0;185;0
WireConnection;175;1;187;0
WireConnection;232;2;175;0
WireConnection;232;13;70;0
ASEEND*/
//CHKSM=C51C8678652A86EE2C7521B0B4C615454E980844
