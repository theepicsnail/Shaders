// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/NewSurfaceShader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(Blinn Phong Light)]
		_Posterization("Posterization", Float) = 0
		_R("R", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Posterization;
		uniform float _R;
		uniform float _Cutoff = 0.5;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float4 temp_output_42_0_g1 = tex2DNode1;
			SurfaceOutputStandard s16 = (SurfaceOutputStandard ) 0;
			s16.Albedo = tex2DNode1.rgb;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 _Vector0 = float3(0,0,1);
			float div42=256.0/float((int)_Posterization);
			float4 posterize42 = ( floor( float4( ( ase_worldNormal + ( ( _R * float2( 1,-1 ) ).x * _Vector0 ) ) , 0.0 ) * div42 ) / div42 );
			float div41=256.0/float((int)_Posterization);
			float4 posterize41 = ( floor( float4( ( ase_worldNormal + ( ( _R * float2( 1,-1 ) ).y * _Vector0 ) ) , 0.0 ) * div41 ) / div41 );
			float3 _Vector1 = float3(0,1,0);
			float div40=256.0/float((int)_Posterization);
			float4 posterize40 = ( floor( float4( ( ase_worldNormal + ( ( _R * float2( 1,-1 ) ).x * _Vector1 ) ) , 0.0 ) * div40 ) / div40 );
			float div39=256.0/float((int)_Posterization);
			float4 posterize39 = ( floor( float4( ( ase_worldNormal + ( ( _R * float2( 1,-1 ) ).y * _Vector1 ) ) , 0.0 ) * div39 ) / div39 );
			float3 _Vector2 = float3(1,0,0);
			float div38=256.0/float((int)_Posterization);
			float4 posterize38 = ( floor( float4( ( ase_worldNormal + ( ( _R * float2( 1,-1 ) ).x * _Vector2 ) ) , 0.0 ) * div38 ) / div38 );
			float div13=256.0/float((int)_Posterization);
			float4 posterize13 = ( floor( float4( ( ase_worldNormal + ( ( _R * float2( 1,-1 ) ).y * _Vector2 ) ) , 0.0 ) * div13 ) / div13 );
			float4 normalizeResult14 = normalize( ( posterize42 + posterize41 + posterize40 + posterize39 + posterize38 + posterize13 + float4( ase_worldNormal , 0.0 ) ) );
			s16.Normal = WorldNormalVector( i, normalizeResult14.rgb);
			s16.Emission = float3( 0,0,0 );
			s16.Metallic = 0.0;
			s16.Smoothness = 0.0;
			s16.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi16 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g16 = UnityGlossyEnvironmentSetup( s16.Smoothness, data.worldViewDir, s16.Normal, float3(0,0,0));
			gi16 = UnityGlobalIllumination( data, s16.Occlusion, s16.Normal, g16 );
			#endif

			float3 surfResult16 = LightingStandard ( s16, viewDir, gi16 ).rgb;
			surfResult16 += s16.Emission;

			c.rgb = surfResult16;
			c.a = 1;
			clip( (temp_output_42_0_g1).a - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				LightingStandardCustomLighting( o, worldViewDir, gi );
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
Version=14201
1017;92;903;926;1111.047;457.4614;1.6;True;False
Node;AmplifyShaderEditor.RangedFloatNode;24;-1608.5,190.5;Float;False;Property;_R;R;6;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;22;-1615.5,299.5;Float;False;Constant;_Vector3;Vector 3;4;0;Create;1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1446.5,277.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT2;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;26;-1308.5,280.5;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;20;-1235.5,678.5;Float;False;Constant;_Vector2;Vector 2;4;0;Create;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;19;-1239.5,533.5;Float;False;Constant;_Vector1;Vector 1;4;0;Create;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;18;-1240.5,382.5;Float;False;Constant;_Vector0;Vector 0;4;0;Create;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1030.5,340.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1029.5,602.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1030.5,775.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1029.5,514.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1030.5,428.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1030.5,687.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;31;-1069.5,119.5;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-848.5002,779.7;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-849.5,689.5;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-871.1998,872.0005;Float;False;Property;_Posterization;Posterization;5;0;Create;0;64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-847.5,423.5;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-846.5,320.5;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-847.5,514.5;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-850.5,601.5;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosterizeNode;39;-719.2562,608.1854;Float;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;42;-714.0084,340.1807;Float;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;40;-712.8521,511.0955;Float;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;13;-718.0999,779.1001;Float;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;38;-716.6561,695.285;Float;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;41;-711.4083,427.2803;Float;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-500.8561,432.6857;Float;False;7;7;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;FLOAT3;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-597.9,-169.9;Float;True;Property;_MainTex;MainTex;7;0;Create;None;c0eb417fddab3694da26635dd74f3d85;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;14;-385.9001,431.6001;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-143.5,29.5;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;16;-193.5,402.9;Float;False;Metallic;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;1.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ShadeVertexLightsHlpNode;3;-654.1999,45.69999;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-410.3,104.2;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;10;-185.7,214.9001;Float;False;Blinn-Phong Light;1;;1;cf814dba44d007a4e958d2ddd5813da6;3;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;43;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;57
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;113.3308,164.4868;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;snail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Masked;0.5;True;True;0;False;TransparentCutout;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;One;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0,0,0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;24;0
WireConnection;23;1;22;0
WireConnection;26;0;23;0
WireConnection;17;0;26;0
WireConnection;17;1;18;0
WireConnection;28;0;26;1
WireConnection;28;1;19;0
WireConnection;30;0;26;1
WireConnection;30;1;20;0
WireConnection;27;0;26;0
WireConnection;27;1;19;0
WireConnection;21;0;26;1
WireConnection;21;1;18;0
WireConnection;29;0;26;0
WireConnection;29;1;20;0
WireConnection;37;0;31;0
WireConnection;37;1;30;0
WireConnection;36;0;31;0
WireConnection;36;1;29;0
WireConnection;33;0;31;0
WireConnection;33;1;21;0
WireConnection;32;0;31;0
WireConnection;32;1;17;0
WireConnection;34;0;31;0
WireConnection;34;1;27;0
WireConnection;35;0;31;0
WireConnection;35;1;28;0
WireConnection;39;1;35;0
WireConnection;39;0;15;0
WireConnection;42;1;32;0
WireConnection;42;0;15;0
WireConnection;40;1;34;0
WireConnection;40;0;15;0
WireConnection;13;1;37;0
WireConnection;13;0;15;0
WireConnection;38;1;36;0
WireConnection;38;0;15;0
WireConnection;41;1;33;0
WireConnection;41;0;15;0
WireConnection;43;0;42;0
WireConnection;43;1;41;0
WireConnection;43;2;40;0
WireConnection;43;3;39;0
WireConnection;43;4;38;0
WireConnection;43;5;13;0
WireConnection;43;6;31;0
WireConnection;14;0;43;0
WireConnection;7;0;1;0
WireConnection;7;1;8;0
WireConnection;16;0;1;0
WireConnection;16;1;14;0
WireConnection;8;0;3;0
WireConnection;10;42;1;0
WireConnection;10;52;14;0
WireConnection;10;43;1;0
WireConnection;0;10;10;57
WireConnection;0;13;16;0
ASEEND*/
//CHKSM=DA8569F71DB765A9AB38F285E838AB8E2D1BC56E
