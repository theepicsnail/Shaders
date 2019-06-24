// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Avatar/Rainbow/New Amplify Shader 1"
{
	Properties
	{
		_LightRamp("LightRamp", 2D) = "white" {}
		[Toggle(_FLIPLIGHTRAMP_ON)] _FlipLightRamp("Flip Light Ramp", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_MAKEGRAYSCALE_ON)] _MakeGrayscale("Make Grayscale", Float) = 0
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
		uniform sampler2D _LightRamp;


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
			float Color11 = 0.0;
			float3 temp_output_5_0 = ( staticSwitch5_g6 * Color11 );
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
			float2 temp_cast_0 = (lerpResult23_g49).xx;
			c.rgb = ( temp_output_5_0 * ( localSH98_g49 + (( ase_lightColor * tex2D( _LightRamp, temp_cast_0 ) * ase_lightAtten )).rgb ) );
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
			float Emission10 = 0.0;
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g6 = (temp_output_10_0_g6).xxx;
			#else
				float3 staticSwitch5_g6 = temp_output_2_0_g6;
			#endif
			float Color11 = 0.0;
			float3 temp_output_5_0 = ( staticSwitch5_g6 * Color11 );
			o.Emission = ( (temp_output_10_0_g6*_BaseEmission + Emission10) * temp_output_5_0 );
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
733;92;1187;926;1786.65;385.6689;1.3;True;False
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-858.5844,-68.57323;Float;False;Emission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-841.9482,225.6373;Float;False;Color;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-628.4821,13.84421;Float;False;Property;_BaseEmission;Base Emission;6;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2;-628.8862,-65.86884;Float;False;10;Emission;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;3;-608.9711,102.8082;Float;False;MainTex;3;;6;45db3e40c3069804caaf81bcab512992;0;0;3;FLOAT;11;FLOAT;9;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1;-605.0358,228.6224;Float;False;11;Color;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;6;-368.4818,-9.855766;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;7;-405.0038,292.8347;Float;False;FlatLighting;0;;49;fc517e88685f04d45a66f4bd14b48aba;1,27,0;4;30;FLOAT;1;False;25;FLOAT3;0,0,0;False;22;FLOAT;0;False;20;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-300.21,115.7728;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-152.3621,227.6395;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-150.3379,46.39619;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Skirt;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;3;11
WireConnection;6;1;4;0
WireConnection;6;2;2;0
WireConnection;5;0;3;0
WireConnection;5;1;1;0
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;8;0;6;0
WireConnection;8;1;5;0
WireConnection;0;2;8;0
WireConnection;0;13;9;0
ASEEND*/
//CHKSM=792D9C636431D99E7723D32E312F829C3538FBF3
