// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Avatar/Wave/ColorWavesAlpha"
{
	Properties
	{
		_LightRamp("LightRamp", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_FLIPLIGHTRAMP_ON)] _FlipLightRamp("Flip Light Ramp", Float) = 0
		_Noise("Noise", Float) = 0
		[Toggle(_MAKEGRAYSCALE_ON)] _MakeGrayscale("Make Grayscale", Float) = 0
		_VerticalBanding("Vertical Banding", Float) = 0
		_Slope("Slope", Float) = 0
		_WaveOpacity("WaveOpacity", Range( 0 , 10)) = 0
		_WaveEmission("WaveEmission", Range( 0 , 10)) = 0
		_StandingEmission("StandingEmission", Range( 0 , 10)) = 0
		_StandingOpacity("StandingOpacity", Range( 0 , 10)) = 0
		_Value("Value", Float) = 0
		_Saturation("Saturation", Float) = 0
		[KeywordEnum(X_Y_Z,U_V_Time)] _NoiseSpace("Noise Space", Float) = 0
		[KeywordEnum(PerPixel,PerVertex)] _NoiseType("Noise Type", Float) = 0
		_NoiseScalexyzw("Noise Scale (x,y,z)*w", Vector) = (1,1,1,1)
		[Toggle(_USEPOLYCOLORWAVESETTINGS_ON)] _UsePolyColorWaveSettings("Use PolyColorWave Settings", Float) = 0
		_WaveSpeedHueStepHueOffsetTimeOffset("Wave(Speed, HueStep, HueOffset, TimeOffset)", Vector) = (0,0,0,0)
		[Toggle(_USEPALETTE_ON)] _UsePalette("Use Palette", Float) = 0
		_Palette("Palette", 2D) = "white" {}
		_Space0world1object("Space(0-world 1-object)", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _USEPALETTE_ON
		#pragma multi_compile __ _USEPOLYCOLORWAVESETTINGS_ON
		#pragma multi_compile _NOISETYPE_PERPIXEL _NOISETYPE_PERVERTEX
		#pragma multi_compile _NOISESPACE_X_Y_Z _NOISESPACE_U_V_TIME
		#pragma shader_feature _FLIPLIGHTRAMP_ON
		#pragma shader_feature _MAKEGRAYSCALE_ON
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float vertexToFrag17_g13;
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

		uniform float4 _WaveSpeedHueStepHueOffsetTimeOffset;
		uniform float _Noise;
		uniform float _Space0world1object;
		uniform float4 _NoiseScalexyzw;
		uniform float _VerticalBanding;
		uniform float _Saturation;
		uniform float _Value;
		uniform sampler2D _Palette;
		uniform float _WaveEmission;
		uniform float _StandingEmission;
		uniform float _Slope;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _LightRamp;
		uniform float _WaveOpacity;
		uniform float _StandingOpacity;


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


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		half3 SH9(  )
		{
			return ShadeSH9(fixed4(0,0,0,1));
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult7_g13 = (float4(ase_worldPos , _Space0world1object));
			float4 transform10_g13 = mul(unity_WorldToObject,appendResult7_g13);
			float3 appendResult8_g13 = (float3(v.texcoord.xy , _Time.y));
			#if defined(_NOISESPACE_X_Y_Z)
				float4 staticSwitch11_g13 = transform10_g13;
			#elif defined(_NOISESPACE_U_V_TIME)
				float4 staticSwitch11_g13 = float4( appendResult8_g13 , 0.0 );
			#else
				float4 staticSwitch11_g13 = transform10_g13;
			#endif
			float3 appendResult12_g13 = (float3(_NoiseScalexyzw.xyz));
			float simplePerlin3D15_g13 = snoise( ( staticSwitch11_g13 * float4( appendResult12_g13 , 0.0 ) * _NoiseScalexyzw.w ).xyz );
			o.vertexToFrag17_g13 = simplePerlin3D15_g13;
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
			float4 tex2DNode8_g14 = tex2D( _MainTex, uv_MainTex );
			half3 localSH98_g15 = SH9();
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
			float dotResult2_g15 = dot( ase_worldlightDir , ase_worldNormal );
			float lerpResult7_g15 = lerp( saturate( dotResult2_g15 ) , sqrt( ase_lightAtten ) , _WorldSpaceLightPos0.w);
			float2 _Vector0 = float2(0,1);
			#ifdef _FLIPLIGHTRAMP_ON
				float staticSwitch12_g15 = _Vector0.y;
			#else
				float staticSwitch12_g15 = _Vector0.x;
			#endif
			float lerpResult23_g15 = lerp( lerpResult7_g15 , ( 1.0 - lerpResult7_g15 ) , staticSwitch12_g15);
			float2 temp_cast_5 = (lerpResult23_g15).xx;
			float3 temp_output_2_0_g14 = (tex2DNode8_g14).rgb;
			float dotResult3_g14 = dot( temp_output_2_0_g14 , float3(0.3,0.59,0.11) );
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g14 = (dotResult3_g14).xxx;
			#else
				float3 staticSwitch5_g14 = temp_output_2_0_g14;
			#endif
			float3 TextureColor2_g13 = staticSwitch5_g14;
			#ifdef _USEPOLYCOLORWAVESETTINGS_ON
				float4 staticSwitch23_g13 = float4(0.1,1.618,0,0);
			#else
				float4 staticSwitch23_g13 = _WaveSpeedHueStepHueOffsetTimeOffset;
			#endif
			float4 break28_g13 = staticSwitch23_g13;
			float mulTime31_g13 = _Time.y * break28_g13.x;
			float4 appendResult7_g13 = (float4(ase_worldPos , _Space0world1object));
			float4 transform10_g13 = mul(unity_WorldToObject,appendResult7_g13);
			float3 appendResult8_g13 = (float3(i.uv_texcoord , _Time.y));
			#if defined(_NOISESPACE_X_Y_Z)
				float4 staticSwitch11_g13 = transform10_g13;
			#elif defined(_NOISESPACE_U_V_TIME)
				float4 staticSwitch11_g13 = float4( appendResult8_g13 , 0.0 );
			#else
				float4 staticSwitch11_g13 = transform10_g13;
			#endif
			float3 appendResult12_g13 = (float3(_NoiseScalexyzw.xyz));
			float simplePerlin3D15_g13 = snoise( ( staticSwitch11_g13 * float4( appendResult12_g13 , 0.0 ) * _NoiseScalexyzw.w ).xyz );
			#if defined(_NOISETYPE_PERPIXEL)
				float staticSwitch18_g13 = simplePerlin3D15_g13;
			#elif defined(_NOISETYPE_PERVERTEX)
				float staticSwitch18_g13 = i.vertexToFrag17_g13;
			#else
				float staticSwitch18_g13 = simplePerlin3D15_g13;
			#endif
			float Noise26_g13 = ( _Noise * staticSwitch18_g13 );
			float4 transform16_g13 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float Vertical27_g13 = ( _VerticalBanding * (transform16_g13).y );
			float temp_output_32_0_g13 = ( mulTime31_g13 + Noise26_g13 + Vertical27_g13 + break28_g13.w );
			float WaveNumber34_g13 = floor( temp_output_32_0_g13 );
			float temp_output_35_0_g13 = (WaveNumber34_g13*break28_g13.y + break28_g13.z);
			float3 hsvTorgb48_g13 = HSVToRGB( float3(temp_output_35_0_g13,_Saturation,_Value) );
			float2 appendResult37_g13 = (float2(temp_output_35_0_g13 , 0.5));
			float simplePerlin2D40_g13 = snoise( appendResult37_g13 );
			float2 appendResult38_g13 = (float2(0.5 , temp_output_35_0_g13));
			float simplePerlin2D39_g13 = snoise( appendResult38_g13 );
			float2 appendResult42_g13 = (float2(simplePerlin2D40_g13 , simplePerlin2D39_g13));
			#ifdef _USEPALETTE_ON
				float3 staticSwitch51_g13 = (tex2D( _Palette, appendResult42_g13 )).rgb;
			#else
				float3 staticSwitch51_g13 = hsvTorgb48_g13;
			#endif
			float3 WaveColor53_g13 = staticSwitch51_g13;
			float WavePercent43_g13 = frac( temp_output_32_0_g13 );
			float temp_output_54_0_g13 = saturate( ( WavePercent43_g13 * _Slope ) );
			float lerpResult70_g13 = lerp( _WaveOpacity , _StandingOpacity , temp_output_54_0_g13);
			float3 lerpResult60_g13 = lerp( TextureColor2_g13 , WaveColor53_g13 , lerpResult70_g13);
			float3 ResultingColor61_g13 = lerpResult60_g13;
			c.rgb = ( ( localSH98_g15 + (( ase_lightColor * tex2D( _LightRamp, temp_cast_5 ) * ase_lightAtten )).rgb ) * ResultingColor61_g13 );
			c.a = tex2DNode8_g14.a;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			#ifdef _USEPOLYCOLORWAVESETTINGS_ON
				float4 staticSwitch23_g13 = float4(0.1,1.618,0,0);
			#else
				float4 staticSwitch23_g13 = _WaveSpeedHueStepHueOffsetTimeOffset;
			#endif
			float4 break28_g13 = staticSwitch23_g13;
			float mulTime31_g13 = _Time.y * break28_g13.x;
			float3 ase_worldPos = i.worldPos;
			float4 appendResult7_g13 = (float4(ase_worldPos , _Space0world1object));
			float4 transform10_g13 = mul(unity_WorldToObject,appendResult7_g13);
			float3 appendResult8_g13 = (float3(i.uv_texcoord , _Time.y));
			#if defined(_NOISESPACE_X_Y_Z)
				float4 staticSwitch11_g13 = transform10_g13;
			#elif defined(_NOISESPACE_U_V_TIME)
				float4 staticSwitch11_g13 = float4( appendResult8_g13 , 0.0 );
			#else
				float4 staticSwitch11_g13 = transform10_g13;
			#endif
			float3 appendResult12_g13 = (float3(_NoiseScalexyzw.xyz));
			float simplePerlin3D15_g13 = snoise( ( staticSwitch11_g13 * float4( appendResult12_g13 , 0.0 ) * _NoiseScalexyzw.w ).xyz );
			#if defined(_NOISETYPE_PERPIXEL)
				float staticSwitch18_g13 = simplePerlin3D15_g13;
			#elif defined(_NOISETYPE_PERVERTEX)
				float staticSwitch18_g13 = i.vertexToFrag17_g13;
			#else
				float staticSwitch18_g13 = simplePerlin3D15_g13;
			#endif
			float Noise26_g13 = ( _Noise * staticSwitch18_g13 );
			float4 transform16_g13 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float Vertical27_g13 = ( _VerticalBanding * (transform16_g13).y );
			float temp_output_32_0_g13 = ( mulTime31_g13 + Noise26_g13 + Vertical27_g13 + break28_g13.w );
			float WaveNumber34_g13 = floor( temp_output_32_0_g13 );
			float temp_output_35_0_g13 = (WaveNumber34_g13*break28_g13.y + break28_g13.z);
			float3 hsvTorgb48_g13 = HSVToRGB( float3(temp_output_35_0_g13,_Saturation,_Value) );
			float2 appendResult37_g13 = (float2(temp_output_35_0_g13 , 0.5));
			float simplePerlin2D40_g13 = snoise( appendResult37_g13 );
			float2 appendResult38_g13 = (float2(0.5 , temp_output_35_0_g13));
			float simplePerlin2D39_g13 = snoise( appendResult38_g13 );
			float2 appendResult42_g13 = (float2(simplePerlin2D40_g13 , simplePerlin2D39_g13));
			#ifdef _USEPALETTE_ON
				float3 staticSwitch51_g13 = (tex2D( _Palette, appendResult42_g13 )).rgb;
			#else
				float3 staticSwitch51_g13 = hsvTorgb48_g13;
			#endif
			float3 WaveColor53_g13 = staticSwitch51_g13;
			float WavePercent43_g13 = frac( temp_output_32_0_g13 );
			float temp_output_54_0_g13 = saturate( ( WavePercent43_g13 * _Slope ) );
			float lerpResult64_g13 = lerp( _WaveEmission , _StandingEmission , temp_output_54_0_g13);
			o.Emission = ( WaveColor53_g13 * lerpResult64_g13 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.vertexToFrag17_g13;
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
				surfIN.vertexToFrag17_g13 = IN.customPack1.z;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
807;92;1113;641;1653.417;522.6149;1.105834;True;False
Node;AmplifyShaderEditor.FunctionNode;263;-1032.767,-197.7027;Float;False;ColorWaves;0;;13;77a960a8602ca4a46914f2b0fa1d0ba6;0;0;3;FLOAT3;74;FLOAT;73;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;34;-760.3556,-356.5588;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;snail/shaders/Color Waves Alpha;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;2;263;74
WireConnection;34;9;263;73
WireConnection;34;13;263;0
ASEEND*/
//CHKSM=91BF6A2ACCC902CF990D24D499C4E297A30C83F4
