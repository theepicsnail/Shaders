// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Avatar/Rainbow/Skirt"
{
	Properties
	{
		_LightRamp("LightRamp", 2D) = "white" {}
		[Toggle(_FLIPLIGHTRAMP_ON)] _FlipLightRamp("Flip Light Ramp", Float) = 0
		_Vector1("Vector 1", Vector) = (5,5,0.1,0)
		_Float2("Float 2", Float) = 0.05
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_MAKEGRAYSCALE_ON)] _MakeGrayscale("Make Grayscale", Float) = 0
		_Vector0("Vector 0", Vector) = (0.4,0.6,0,0)
		_Float3("Float 3", Float) = -1
		_BaseEmission("Base Emission", Float) = 0
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
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _MAKEGRAYSCALE_ON
		#pragma shader_feature _FLIPLIGHTRAMP_ON
		struct Input
		{
			float2 uv_texcoord;
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
		uniform float3 _Vector1;
		uniform float _Float2;
		uniform float _Float3;
		uniform float2 _Vector0;
		uniform sampler2D _LightRamp;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
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
			float2 uv_TexCoord13 = i.uv_texcoord + temp_cast_2;
			float2 temp_cast_3 = (-0.5).xx;
			float2 uv_TexCoord15 = i.uv_texcoord + temp_cast_3;
			float3 appendResult17 = (float3(uv_TexCoord13.x , uv_TexCoord15.x , _Time.y));
			float simplePerlin3D12 = snoise( ( appendResult17 * _Vector1 ) );
			float mulTime4_g50 = _Time.y * 0.1;
			float temp_output_7_0_g51 = ( ( simplePerlin3D12 * _Float2 ) + mulTime4_g50 );
			float temp_output_2_0_g51 = floor( temp_output_7_0_g51 );
			float WaveNumber7_g50 = temp_output_2_0_g51;
			float temp_output_22_0_g50 = ( 0.0 + ( 1.618 * WaveNumber7_g50 ) );
			float3 hsvTorgb16_g50 = HSVToRGB( float3(temp_output_22_0_g50,1.0,1.0) );
			float mulTime4_g52 = _Time.y * 0.1;
			float temp_output_7_0_g53 = ( ( ( simplePerlin3D12 * _Float2 ) + _Float3 ) + mulTime4_g52 );
			float temp_output_2_0_g53 = floor( temp_output_7_0_g53 );
			float WaveNumber7_g52 = temp_output_2_0_g53;
			float temp_output_22_0_g52 = ( 0.0 + ( 1.618 * WaveNumber7_g52 ) );
			float3 hsvTorgb16_g52 = HSVToRGB( float3(temp_output_22_0_g52,1.0,1.0) );
			float temp_output_1_0_g51 = frac( temp_output_7_0_g51 );
			float WavePercent8_g50 = temp_output_1_0_g51;
			float smoothstepResult38 = smoothstep( _Vector0.x , _Vector0.y , WavePercent8_g50);
			float3 lerpResult39 = lerp( hsvTorgb16_g50 , hsvTorgb16_g52 , saturate( smoothstepResult38 ));
			float3 Color34 = lerpResult39;
			float3 temp_output_30_0 = ( staticSwitch5_g6 * Color34 );
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
			c.rgb = ( temp_output_30_0 * ( localSH98_g49 + (( ase_lightColor * tex2D( _LightRamp, temp_cast_4 ) * ase_lightAtten )).rgb ) );
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
			float Emission33 = 0.0;
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g6 = (temp_output_10_0_g6).xxx;
			#else
				float3 staticSwitch5_g6 = temp_output_2_0_g6;
			#endif
			float2 temp_cast_0 = (-0.5).xx;
			float2 uv_TexCoord13 = i.uv_texcoord + temp_cast_0;
			float2 temp_cast_1 = (-0.5).xx;
			float2 uv_TexCoord15 = i.uv_texcoord + temp_cast_1;
			float3 appendResult17 = (float3(uv_TexCoord13.x , uv_TexCoord15.x , _Time.y));
			float simplePerlin3D12 = snoise( ( appendResult17 * _Vector1 ) );
			float mulTime4_g50 = _Time.y * 0.1;
			float temp_output_7_0_g51 = ( ( simplePerlin3D12 * _Float2 ) + mulTime4_g50 );
			float temp_output_2_0_g51 = floor( temp_output_7_0_g51 );
			float WaveNumber7_g50 = temp_output_2_0_g51;
			float temp_output_22_0_g50 = ( 0.0 + ( 1.618 * WaveNumber7_g50 ) );
			float3 hsvTorgb16_g50 = HSVToRGB( float3(temp_output_22_0_g50,1.0,1.0) );
			float mulTime4_g52 = _Time.y * 0.1;
			float temp_output_7_0_g53 = ( ( ( simplePerlin3D12 * _Float2 ) + _Float3 ) + mulTime4_g52 );
			float temp_output_2_0_g53 = floor( temp_output_7_0_g53 );
			float WaveNumber7_g52 = temp_output_2_0_g53;
			float temp_output_22_0_g52 = ( 0.0 + ( 1.618 * WaveNumber7_g52 ) );
			float3 hsvTorgb16_g52 = HSVToRGB( float3(temp_output_22_0_g52,1.0,1.0) );
			float temp_output_1_0_g51 = frac( temp_output_7_0_g51 );
			float WavePercent8_g50 = temp_output_1_0_g51;
			float smoothstepResult38 = smoothstep( _Vector0.x , _Vector0.y , WavePercent8_g50);
			float3 lerpResult39 = lerp( hsvTorgb16_g50 , hsvTorgb16_g52 , saturate( smoothstepResult38 ));
			float3 Color34 = lerpResult39;
			float3 temp_output_30_0 = ( staticSwitch5_g6 * Color34 );
			o.Emission = ( (temp_output_10_0_g6*_BaseEmission + Emission33) * temp_output_30_0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
733;92;1187;926;1487.007;342.315;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;20;-2216.096,-151.6834;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1942.093,-186.6834;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;16;-1890.093,-68.68346;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1939.093,-304.6834;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;19;-1695.093,-26.68346;Float;False;Property;_Vector1;Vector 1;3;0;Create;True;0;0;False;0;5,5,0.1;3,3,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1689.093,-186.6834;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1555.093,-191.6834;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1407.393,-47.68345;Float;False;Property;_Float2;Float 2;4;0;Create;True;0;0;False;0;0.05;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;12;-1425.093,-217.6834;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1218.093,-207.6834;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;43;-913.5706,-177.0161;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-924.9208,-45.24429;Float;False;Property;_Float3;Float 3;9;0;Create;True;0;0;False;0;-1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;41;-578.2184,-383.6334;Float;False;Property;_Vector0;Vector 0;8;0;Create;True;0;0;False;0;0.4,0.6;0.8,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;35;-614.155,-232.604;Float;False;PolyColorWave;-1;;50;935e4bdb3e312ab41b195abf4de01678;0;4;19;FLOAT;0;False;21;FLOAT;0;False;15;FLOAT;1;False;13;FLOAT;1;False;4;FLOAT;26;FLOAT;1;FLOAT;2;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-748.9267,-89.7218;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-273.9164,-363.843;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;40;-109.2184,-343.6335;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;36;-617.914,-94.66367;Float;False;PolyColorWave;-1;;52;935e4bdb3e312ab41b195abf4de01678;0;4;19;FLOAT;0;False;21;FLOAT;0;False;15;FLOAT;1;False;13;FLOAT;1;False;4;FLOAT;26;FLOAT;1;FLOAT;2;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;39;68.76489,-244.5458;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-228.5462,570.3923;Float;False;Emission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;231.9394,-227.1891;Float;False;Color;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;14.00238,771.5879;Float;False;34;Color;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-13.84802,559.0967;Float;False;33;Emission;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;27;10.06708,645.7737;Float;False;MainTex;5;;6;45db3e40c3069804caaf81bcab512992;0;0;3;FLOAT;11;FLOAT;9;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;0.5560608,478.8097;Float;False;Property;_BaseEmission;Base Emission;10;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;225.8276,701.7383;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;29;219.5558,470.1097;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;28;179.034,900.8002;Float;False;FlatLighting;0;;49;fc517e88685f04d45a66f4bd14b48aba;1,27,0;4;30;FLOAT;1;False;25;FLOAT3;0,0,0;False;22;FLOAT;0;False;20;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;455.6996,556.3617;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;456.6754,876.6049;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;644.1785,581.3341;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Custom/Skirt;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;1;20;0
WireConnection;13;1;20;0
WireConnection;17;0;13;1
WireConnection;17;1;15;1
WireConnection;17;2;16;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;12;0;18;0
WireConnection;11;0;12;0
WireConnection;11;1;6;0
WireConnection;43;0;11;0
WireConnection;35;19;43;0
WireConnection;42;0;43;0
WireConnection;42;1;37;0
WireConnection;38;0;35;2
WireConnection;38;1;41;1
WireConnection;38;2;41;2
WireConnection;40;0;38;0
WireConnection;36;19;42;0
WireConnection;39;0;35;0
WireConnection;39;1;36;0
WireConnection;39;2;40;0
WireConnection;34;0;39;0
WireConnection;30;0;27;0
WireConnection;30;1;26;0
WireConnection;29;0;27;11
WireConnection;29;1;24;0
WireConnection;29;2;25;0
WireConnection;31;0;29;0
WireConnection;31;1;30;0
WireConnection;32;0;30;0
WireConnection;32;1;28;0
WireConnection;0;2;31;0
WireConnection;0;13;32;0
ASEEND*/
//CHKSM=3BD75E90E0DF6D0304AE4AD271FB1DB3ED085FCD
