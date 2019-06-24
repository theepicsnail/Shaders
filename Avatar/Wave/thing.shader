// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Avatar/Wave/thing"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_MAKEGRAYSCALE_ON)] _MakeGrayscale("Make Grayscale", Float) = 0
		_KnobsAndButtons("KnobsAndButtons", Vector) = (100,1,0.1,0)
		_WavefrontColor("Wavefront Color", Color) = (1,1,1,0)
		_TransitionWidth("TransitionWidth", Float) = 0
		_MiddleDuration("MiddleDuration", Float) = 0
		_Center("Center", Float) = 0.5
		_Float0("Float 0", Float) = 0
		_Vector3("Vector 3", Vector) = (0,0,0,0)
		_Float1("Float 1", Range( 0 , 0.5)) = 0.1
		_Ganularity("Ganularity", Float) = 20
		_LightRamp("LightRamp", 2D) = "white" {}
		[Toggle(_FLIPLIGHTRAMP_ON)] _FlipLightRamp("Flip Light Ramp", Float) = 0
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
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
			float2 uv2_texcoord2;
			float2 uv3_texcoord3;
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

		uniform float _Ganularity;
		uniform float3 _Vector3;
		uniform float3 _KnobsAndButtons;
		uniform float _Float0;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Center;
		uniform float _Float1;
		uniform float4 _WavefrontColor;
		uniform float _MiddleDuration;
		uniform float _TransitionWidth;
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
			float4 tex2DNode8_g47 = tex2D( _MainTex, uv_MainTex );
			float3 temp_output_2_0_g47 = (tex2DNode8_g47).rgb;
			float dotResult5_g48 = dot( temp_output_2_0_g47 , float3(0.3,0.59,0.11) );
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g47 = (dotResult5_g48).xxx;
			#else
				float3 staticSwitch5_g47 = temp_output_2_0_g47;
			#endif
			float mulTime4_g41 = _Time.y * 0.1;
			float temp_output_7_0_g42 = ( -1.0 + mulTime4_g41 );
			float temp_output_1_0_g42 = frac( temp_output_7_0_g42 );
			float WavePercent8_g41 = temp_output_1_0_g42;
			float Percent161 = WavePercent8_g41;
			float2 temp_cast_7 = (-0.5).xx;
			float2 uv2_TexCoord2_g40 = i.uv2_texcoord2 + temp_cast_7;
			float2 temp_cast_8 = (-0.5).xx;
			float2 uv3_TexCoord1_g40 = i.uv3_texcoord3 + temp_cast_8;
			float3 appendResult3_g40 = (float3(uv2_TexCoord2_g40 , uv3_TexCoord1_g40.x));
			float mulTime131 = _Time.y * _KnobsAndButtons.x;
			float mulTime136 = _Time.y * _KnobsAndButtons.z;
			float4 appendResult129 = (float4(( ( appendResult3_g40 * _Ganularity ) + ( _Time.y * _Vector3 ) ) , ( ( cos( mulTime131 ) * _KnobsAndButtons.y ) + mulTime136 )));
			float4 In07_g43 = appendResult129;
			float localsnoise47_g43 = snoise4( In07_g43 );
			float temp_output_109_0 = localsnoise47_g43;
			float temp_output_124_0 = ( Percent161 + ( temp_output_109_0 * _Float1 ) );
			float Wooble189 = temp_output_124_0;
			float temp_output_2_0_g42 = floor( temp_output_7_0_g42 );
			float WaveNumber7_g41 = temp_output_2_0_g42;
			float temp_output_22_0_g41 = ( 0.0 + ( 1.618 * WaveNumber7_g41 ) );
			float3 hsvTorgb16_g41 = HSVToRGB( float3(temp_output_22_0_g41,1.0,1.0) );
			float3 temp_output_104_0 = hsvTorgb16_g41;
			float3 Start158 = temp_output_104_0;
			float4 Middle160 = _WavefrontColor;
			float temp_output_176_0 = ( _Center - _MiddleDuration );
			float smoothstepResult178 = smoothstep( ( temp_output_176_0 - _TransitionWidth ) , ( temp_output_176_0 + _TransitionWidth ) , Wooble189);
			float4 lerpResult182 = lerp( float4( Start158 , 0.0 ) , Middle160 , saturate( smoothstepResult178 ));
			float mulTime4_g44 = _Time.y * 0.1;
			float temp_output_7_0_g45 = ( 0.0 + mulTime4_g44 );
			float temp_output_2_0_g45 = floor( temp_output_7_0_g45 );
			float WaveNumber7_g44 = temp_output_2_0_g45;
			float temp_output_22_0_g44 = ( 0.0 + ( 1.618 * WaveNumber7_g44 ) );
			float3 hsvTorgb16_g44 = HSVToRGB( float3(temp_output_22_0_g44,1.0,1.0) );
			float3 temp_output_93_0 = hsvTorgb16_g44;
			float3 End159 = temp_output_93_0;
			float temp_output_175_0 = ( _Center + _MiddleDuration );
			float smoothstepResult181 = smoothstep( ( temp_output_175_0 - _TransitionWidth ) , ( temp_output_175_0 + _TransitionWidth ) , Wooble189);
			float4 lerpResult183 = lerp( Middle160 , float4( End159 , 0.0 ) , saturate( smoothstepResult181 ));
			float4 ifLocalVar184 = 0;
			if( _Center <= Wooble189 )
				ifLocalVar184 = lerpResult183;
			else
				ifLocalVar184 = lerpResult182;
			float4 Result163 = ifLocalVar184;
			float4 temp_output_76_0 = ( float4( staticSwitch5_g47 , 0.0 ) * Result163 );
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
			float2 temp_cast_11 = (lerpResult23_g49).xx;
			c.rgb = ( temp_output_76_0 * float4( ( localSH98_g49 + (( ase_lightColor * tex2D( _LightRamp, temp_cast_11 ) * ase_lightAtten )).rgb ) , 0.0 ) ).rgb;
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
			float2 uv2_TexCoord2_g40 = i.uv2_texcoord2 + temp_cast_0;
			float2 temp_cast_1 = (-0.5).xx;
			float2 uv3_TexCoord1_g40 = i.uv3_texcoord3 + temp_cast_1;
			float3 appendResult3_g40 = (float3(uv2_TexCoord2_g40 , uv3_TexCoord1_g40.x));
			float mulTime131 = _Time.y * _KnobsAndButtons.x;
			float mulTime136 = _Time.y * _KnobsAndButtons.z;
			float4 appendResult129 = (float4(( ( appendResult3_g40 * _Ganularity ) + ( _Time.y * _Vector3 ) ) , ( ( cos( mulTime131 ) * _KnobsAndButtons.y ) + mulTime136 )));
			float4 In07_g43 = appendResult129;
			float localsnoise47_g43 = snoise4( In07_g43 );
			float temp_output_109_0 = localsnoise47_g43;
			float Emission210 = pow( abs( temp_output_109_0 ) , _Float0 );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode8_g47 = tex2D( _MainTex, uv_MainTex );
			float3 temp_output_2_0_g47 = (tex2DNode8_g47).rgb;
			float dotResult5_g48 = dot( temp_output_2_0_g47 , float3(0.3,0.59,0.11) );
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g47 = (dotResult5_g48).xxx;
			#else
				float3 staticSwitch5_g47 = temp_output_2_0_g47;
			#endif
			float mulTime4_g41 = _Time.y * 0.1;
			float temp_output_7_0_g42 = ( -1.0 + mulTime4_g41 );
			float temp_output_1_0_g42 = frac( temp_output_7_0_g42 );
			float WavePercent8_g41 = temp_output_1_0_g42;
			float Percent161 = WavePercent8_g41;
			float temp_output_124_0 = ( Percent161 + ( temp_output_109_0 * _Float1 ) );
			float Wooble189 = temp_output_124_0;
			float temp_output_2_0_g42 = floor( temp_output_7_0_g42 );
			float WaveNumber7_g41 = temp_output_2_0_g42;
			float temp_output_22_0_g41 = ( 0.0 + ( 1.618 * WaveNumber7_g41 ) );
			float3 hsvTorgb16_g41 = HSVToRGB( float3(temp_output_22_0_g41,1.0,1.0) );
			float3 temp_output_104_0 = hsvTorgb16_g41;
			float3 Start158 = temp_output_104_0;
			float4 Middle160 = _WavefrontColor;
			float temp_output_176_0 = ( _Center - _MiddleDuration );
			float smoothstepResult178 = smoothstep( ( temp_output_176_0 - _TransitionWidth ) , ( temp_output_176_0 + _TransitionWidth ) , Wooble189);
			float4 lerpResult182 = lerp( float4( Start158 , 0.0 ) , Middle160 , saturate( smoothstepResult178 ));
			float mulTime4_g44 = _Time.y * 0.1;
			float temp_output_7_0_g45 = ( 0.0 + mulTime4_g44 );
			float temp_output_2_0_g45 = floor( temp_output_7_0_g45 );
			float WaveNumber7_g44 = temp_output_2_0_g45;
			float temp_output_22_0_g44 = ( 0.0 + ( 1.618 * WaveNumber7_g44 ) );
			float3 hsvTorgb16_g44 = HSVToRGB( float3(temp_output_22_0_g44,1.0,1.0) );
			float3 temp_output_93_0 = hsvTorgb16_g44;
			float3 End159 = temp_output_93_0;
			float temp_output_175_0 = ( _Center + _MiddleDuration );
			float smoothstepResult181 = smoothstep( ( temp_output_175_0 - _TransitionWidth ) , ( temp_output_175_0 + _TransitionWidth ) , Wooble189);
			float4 lerpResult183 = lerp( Middle160 , float4( End159 , 0.0 ) , saturate( smoothstepResult181 ));
			float4 ifLocalVar184 = 0;
			if( _Center <= Wooble189 )
				ifLocalVar184 = lerpResult183;
			else
				ifLocalVar184 = lerpResult182;
			float4 Result163 = ifLocalVar184;
			float4 temp_output_76_0 = ( float4( staticSwitch5_g47 , 0.0 ) * Result163 );
			o.Emission = ( Emission210 * temp_output_76_0 ).rgb;
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
				o.customPack1.xy = customInputData.uv2_texcoord2;
				o.customPack1.xy = v.texcoord1;
				o.customPack1.zw = customInputData.uv3_texcoord3;
				o.customPack1.zw = v.texcoord2;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
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
				surfIN.uv2_texcoord2 = IN.customPack1.xy;
				surfIN.uv3_texcoord3 = IN.customPack1.zw;
				surfIN.uv_texcoord = IN.customPack2.xy;
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
733;92;1187;926;922.3809;274.9318;1.3;True;False
Node;AmplifyShaderEditor.Vector3Node;132;-1446.188,-146.0283;Float;False;Property;_KnobsAndButtons;KnobsAndButtons;8;0;Create;True;0;0;False;0;100,1,0.1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;131;-1242.188,-122.0283;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;198;-1288.377,57.53792;Float;False;UVObjectSpace;-1;;40;9616a67f3c171a94da24dc8433ee10ec;0;0;4;FLOAT3;0;FLOAT;9;FLOAT;10;FLOAT;11
Node;AmplifyShaderEditor.RangedFloatNode;108;-1218.386,281.4981;Float;False;Property;_Ganularity;Ganularity;18;0;Create;True;0;0;False;0;20;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;201;-1189.577,396.8381;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;133;-1073.188,-119.0283;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;203;-1176.177,473.938;Float;False;Property;_Vector3;Vector 3;14;0;Create;True;0;0;False;0;0,0,0;0,-1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;136;-1118.188,-38.02826;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-952.1877,-121.0283;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-994.5771,291.538;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1069.977,69.23806;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-806.1877,-75.02826;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1462.536,-1436.734;Float;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;200;-882.7772,113.438;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;104;-1289.809,-1424.387;Float;False;PolyColorWave;-1;;41;935e4bdb3e312ab41b195abf4de01678;0;4;19;FLOAT;0;False;21;FLOAT;0;False;15;FLOAT;1;False;13;FLOAT;1;False;4;FLOAT;26;FLOAT;1;FLOAT;2;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;129;-659.033,-243.7803;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;109;-503.1848,-243.1019;Float;False;Noise;-1;;43;34284a2bf01a18b409ebe6db69d3e268;2,2,2,10,0;3;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-562.7761,-131.5688;Float;False;Property;_Float1;Float 1;16;0;Create;True;0;0;False;0;0.1;0.3411765;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-953.7499,-1424.789;Float;False;Percent;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-214.4507,-194.2125;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-254.7507,-349.6052;Float;False;161;Percent;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-38.69611,-183.8749;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-1709.88,-2630.552;Float;False;Property;_MiddleDuration;MiddleDuration;11;0;Create;True;0;0;False;0;0;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;189;97.90302,-185.6494;Float;False;Wooble;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-1676.78,-2796.155;Float;False;Property;_Center;Center;12;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-1670.116,-2392.786;Float;False;Property;_TransitionWidth;TransitionWidth;10;0;Create;True;0;0;False;0;0;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;176;-1466.88,-2647.552;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;191;-1365.73,-2892.389;Float;False;189;Wooble;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;175;-1459.88,-2553.552;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;-1272.357,-2614.095;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;195;-1279.357,-2708.095;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;93;-1270.809,-1221.465;Float;False;PolyColorWave;-1;;44;935e4bdb3e312ab41b195abf4de01678;0;4;19;FLOAT;0;False;21;FLOAT;0;False;15;FLOAT;1;False;13;FLOAT;1;False;4;FLOAT;26;FLOAT;1;FLOAT;2;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;188;-1277.616,-2514.786;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;187;-1270.616,-2420.786;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;192;-1166.428,-2893.947;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;121;-1370.089,-960.0914;Float;False;Property;_WavefrontColor;Wavefront Color;9;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;181;-1076.38,-2542.052;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;-935.7589,-1212.855;Float;False;End;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-931.1589,-1038.955;Float;False;Middle;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-942.2591,-1311.854;Float;False;Start;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;178;-1077.88,-2662.552;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-908.5734,-2438.795;Float;False;159;End;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-929.6738,-2748.823;Float;False;158;Start;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;180;-910.3795,-2514.052;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;179;-903.8796,-2670.052;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-911.6738,-2599.909;Float;False;160;Middle;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;183;-704.8795,-2532.552;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;182;-693.8795,-2714.552;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-386.7809,527.1682;Float;True;Property;_Float0;Float 0;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;218;-304.36,408.7785;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;184;-502.2705,-2808.944;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;219;-145.7659,451.2882;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-335.477,-2805.238;Float;False;Result;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;35.42507,447.9176;Float;False;Emission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;462.1519,-940.0806;Float;False;163;Result;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;57;475.4964,-1102.818;Float;False;MainTex;5;;47;45db3e40c3069804caaf81bcab512992;0;0;2;FLOAT;9;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;701.5858,-1074.232;Float;False;210;Emission;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;655.2424,-969.7844;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;72;549.5681,-764.0315;Float;False;FlatLighting;19;;49;fc517e88685f04d45a66f4bd14b48aba;1,27,0;4;30;FLOAT;1;False;25;FLOAT3;0,0,0;False;22;FLOAT;0;False;20;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;139;705.6256,179.7609;Float;True;Property;_GlintRamplol;GlintRamplol;15;0;Create;True;0;0;False;0;cc69c89704302b64dbcd2a5df5addecd;cc69c89704302b64dbcd2a5df5addecd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;16;347.9336,-1392.482;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;29;34.46778,-1545.113;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;886.0901,-794.9178;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;34;360.9106,-1491.802;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-1508.684,-1029.465;Float;False;Constant;_Float4;Float 4;9;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;123;442.4232,-23.92876;Float;False;1-pow(1/(abs(x-.5)+1),k);1;False;2;True;x;FLOAT;0;In;;Float;True;k;FLOAT;0;In;;Float;My Custom Expression;True;False;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;146;535.5166,83.35019;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;145;369.3152,308.4984;Float;False;Constant;_Vector2;Vector 2;9;0;Create;True;0;0;False;0;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;536.2502,228.7188;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;138;-1112.636,-1014.816;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;229.2606,-1495.126;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;106;-1311.89,-1070.016;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;880.1143,-987.1608;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;118;228.2826,195.2483;Float;False;Property;_EdgeSharpness;Edge Sharpness;17;0;Create;True;0;0;False;0;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;33;-26.73814,-1407.928;Float;False;ConsistentCameraPos;-1;;46;ea897b0c40f2bb9459f3d52382256746;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;86;685.7256,-1467.582;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;26;554.9877,-1462.41;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-955.1951,-1544.443;Float;False;WaveNumberg;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;75;1164.786,-1031.525;Float;False;True;6;Float;ASEMaterialInspector;0;0;CustomLighting;heterochromia;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;131;0;132;1
WireConnection;133;0;131;0
WireConnection;136;0;132;3
WireConnection;134;0;133;0
WireConnection;134;1;132;2
WireConnection;202;0;201;0
WireConnection;202;1;203;0
WireConnection;199;0;198;0
WireConnection;199;1;108;0
WireConnection;135;0;134;0
WireConnection;135;1;136;0
WireConnection;200;0;199;0
WireConnection;200;1;202;0
WireConnection;104;19;105;0
WireConnection;129;0;200;0
WireConnection;129;3;135;0
WireConnection;109;5;129;0
WireConnection;161;0;104;2
WireConnection;125;0;109;0
WireConnection;125;1;126;0
WireConnection;124;0;166;0
WireConnection;124;1;125;0
WireConnection;189;0;124;0
WireConnection;176;0;174;0
WireConnection;176;1;173;0
WireConnection;175;0;174;0
WireConnection;175;1;173;0
WireConnection;196;0;176;0
WireConnection;196;1;186;0
WireConnection;195;0;176;0
WireConnection;195;1;186;0
WireConnection;188;0;175;0
WireConnection;188;1;186;0
WireConnection;187;0;175;0
WireConnection;187;1;186;0
WireConnection;192;0;191;0
WireConnection;181;0;192;0
WireConnection;181;1;188;0
WireConnection;181;2;187;0
WireConnection;159;0;93;0
WireConnection;160;0;121;0
WireConnection;158;0;104;0
WireConnection;178;0;192;0
WireConnection;178;1;195;0
WireConnection;178;2;196;0
WireConnection;180;0;181;0
WireConnection;179;0;178;0
WireConnection;183;0;168;0
WireConnection;183;1;169;0
WireConnection;183;2;180;0
WireConnection;182;0;167;0
WireConnection;182;1;168;0
WireConnection;182;2;179;0
WireConnection;218;0;109;0
WireConnection;184;0;174;0
WireConnection;184;1;192;0
WireConnection;184;2;182;0
WireConnection;184;3;183;0
WireConnection;184;4;183;0
WireConnection;219;0;218;0
WireConnection;219;1;220;0
WireConnection;163;0;184;0
WireConnection;210;0;219;0
WireConnection;76;0;57;0
WireConnection;76;1;162;0
WireConnection;139;1;144;0
WireConnection;10;0;76;0
WireConnection;10;1;72;0
WireConnection;34;0;31;0
WireConnection;123;0;124;0
WireConnection;123;1;118;0
WireConnection;146;0;123;0
WireConnection;144;0;124;0
WireConnection;144;1;145;0
WireConnection;138;0;106;0
WireConnection;31;0;29;0
WireConnection;31;1;33;0
WireConnection;106;0;104;0
WireConnection;106;1;93;0
WireConnection;106;2;137;0
WireConnection;77;0;209;0
WireConnection;77;1;76;0
WireConnection;86;0;26;0
WireConnection;26;0;34;0
WireConnection;26;1;16;0
WireConnection;164;0;104;1
WireConnection;75;2;77;0
WireConnection;75;13;10;0
ASEEND*/
//CHKSM=95B50CDBC4A16FFCAD53B2403374A7EE59402AA5
