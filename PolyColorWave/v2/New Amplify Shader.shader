// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/PolyColorWave/v2/New Amplify Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float3 worldPos;
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


		float random( float n )
		{
			return frac(cos(n * 12345.6543) * 43758.5453123);
		}


		float2 idToUV( float x )
		{
			return float2(random(x),random(2*x));
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult212 = dot( ase_worldNormal , ase_worldlightDir );
			float3 temp_cast_0 = (dotResult212).xxx;
			c.rgb = temp_cast_0;
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
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
901;92;1019;650;-4084.618;1605.367;1.9;True;False
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;216;5390.705,-849.8619;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;210;5054.704,-680.2621;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;3592.604,-1108.096;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;128;2530.617,668.0707;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.IndirectSpecularLight;205;4679.801,-1448.832;Float;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;190;5029.8,-339.8295;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;193;4580.999,-708.9294;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;4675.739,-865.2468;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;170;3904.604,-1065.096;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;124;2511.617,197.0707;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;204;4721.401,-1548.932;Float;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;188;4121.002,-338.23;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;125;2511.617,303.0707;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;201;4941.209,-767.685;Float;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;3681.607,-1431.429;Float;False;PolyHash;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;3415.333,-1422.787;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;116;2123.845,-625.739;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ShadeVertexLightsHlpNode;127;2526.617,580.0707;Float;False;4;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;158;3468.551,-918.5264;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;157;3128.606,-1203.345;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;180;4301.327,-1080.101;Float;False;return float2(random(x),random(2*x))@;2;False;1;True;x;FLOAT;0;In;;Float;idToUV;False;True;1;177;1;0;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;136;3059.908,-519.7397;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;2974.376,-1374.557;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;1234.654;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;198;4920.412,-437.4852;Float;False;Constant;_Color2;Color 2;6;0;Create;True;0;0;False;0;0.3278905,0.8970588,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectDiffuseLighting;117;2552.765,-655.4537;Float;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;206;5067.199,-1389.032;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;2798.534,838.0735;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;39;4357.708,-557.3015;Float;True;Property;_Shadow;Shadow;5;0;Create;True;0;0;False;0;None;516133a9f844ad84d8bf8ebbaeaa13cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;123;2511.617,82.07074;Float;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;194;4813.4,-500.6253;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.CustomExpressionNode;187;4415.301,-247.9881;Float;False;float3 normal = normalize(mul(unity_ObjectToWorld, float4(norm.xyz,0)))@$return max(0,ShadeSH9(float4(normal, 1))) +$Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb, unity_4LightAtten0, $normalize(mul(unity_ObjectToWorld, float4(vertex.xyz,1))), normal)@;3;False;2;True;vertex;FLOAT3;0,0,0;In;;Float;True;norm;FLOAT3;0,0,0;In;;Float;My Custom Expression;True;False;0;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PrimitiveIDVariableNode;148;3003.657,-1441.735;Float;False;0;1;INT;0
Node;AmplifyShaderEditor.FractNode;154;3553.134,-1426.232;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;139;2768.805,-378.4954;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;135;3247.66,-605.8646;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LengthOpNode;182;4218.651,-487.6161;Float;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;3361.604,-1088.096;Float;False;Property;_Noise;Noise;4;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;171;3901.604,-977.0964;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;181;4490.428,-1140.747;Float;True;Property;_Palette;Palette;1;0;Create;True;0;0;False;0;None;bb47b838a0905154496dfe9920ae73b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;3158.683,-1431.4;Float;False;2;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;130;2541.617,943.0707;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;115;2138.055,-468.1236;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FogParamsNode;121;2542.43,-127.0547;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;112;2673.168,-1158.306;Half;False;}// Geometry injection start$$#pragma geometry geom$[maxvertexcount(3)]$void geom($  triangle appdata IN[3],$  uint id:SV_PrimitiveID,$  inout TriangleStream<appdata> tristream) {$$  tristream.Append(IN[0])@$  tristream.Append(IN[1])@$  tristream.Append(IN[2])@$  tristream.RestartStrip()@$}$$void geomInjectorEnd(){ // Geometry injection end;7;False;0;geomInjector;False;False;0;1;0;FLOAT;0;False;1;OBJECT;0
Node;AmplifyShaderEditor.CustomExpressionNode;177;4294.204,-1184.53;Float;False;return frac(cos(n * 12345.6543) * 43758.5453123)@;1;False;1;True;n;FLOAT;0;In;;Float;random;False;False;0;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;207;5115.395,-1080.932;Float;False;ShadeSH9(float4(0,0,0,1));4;False;0;indirectColor;False;False;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;122;2502.617,5.07074;Float;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;4278.944,-906.9041;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;5c5633bc98159d144a0426fa6d56ae27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;212;5289.902,-608.2625;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;202;4928.71,-1019.885;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;167;3402.604,-997.0964;Float;False;Property;_Slope;Slope;3;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;120;2532.958,-203.2777;Float;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;118;2618.654,-553.3912;Float;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;129;2529.617,826.0707;Float;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.NormalVertexDataNode;189;4125.799,-176.6302;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;152;3293.037,-1427.955;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;126;2511.617,433.0707;Float;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;113;2638.57,-1005.796;Float;False; ;7;False;1;True;Noop;FLOAT3;0,0,0;InOut;;Float;DependencyInjection;True;False;1;112;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;FLOAT3;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;173;4010.604,-979.0964;Float;False;ColorPercent;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;186;4750.1,-297.588;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;209;5177.802,-978.2325;Float;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;156;3075.037,-1078.022;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;168;3755.604,-1020.096;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;164;3516.604,-1242.096;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;5121.908,-839.1851;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;163;3286.604,-917.0964;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;0.01;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;4012.858,-1172.119;Float;False;ColorID;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;141;3347.563,-176.9632;Float;False; ShadeSH9(float4(0,0,0,1));3;False;0;My Custom Expression;True;False;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;208;5129.697,-1203.133;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;211;5059.503,-545.8625;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;215;5449.906,-595.4621;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;203;5614.23,-1252.319;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Snail/Amplify/PolycolorWave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;166;0;164;0
WireConnection;166;1;167;0
WireConnection;190;0;186;0
WireConnection;145;0;1;0
WireConnection;145;1;39;0
WireConnection;145;2;181;0
WireConnection;170;0;168;0
WireConnection;155;0;154;0
WireConnection;153;0;152;0
WireConnection;153;1;150;0
WireConnection;158;0;163;0
WireConnection;180;0;170;0
WireConnection;117;0;115;0
WireConnection;206;0;204;0
WireConnection;206;1;205;0
WireConnection;131;0;129;1
WireConnection;131;1;129;2
WireConnection;39;1;182;0
WireConnection;187;0;188;0
WireConnection;187;1;189;0
WireConnection;154;0;153;0
WireConnection;135;0;1;0
WireConnection;135;2;136;0
WireConnection;171;0;168;0
WireConnection;181;1;180;0
WireConnection;151;0;148;0
WireConnection;151;1;150;0
WireConnection;212;0;210;0
WireConnection;212;1;216;0
WireConnection;152;0;151;0
WireConnection;173;0;171;0
WireConnection;186;0;187;0
WireConnection;168;0;166;0
WireConnection;168;1;158;0
WireConnection;164;0;157;2
WireConnection;164;1;155;0
WireConnection;164;2;165;0
WireConnection;200;0;202;0
WireConnection;200;1;201;0
WireConnection;172;0;170;0
WireConnection;215;0;212;0
WireConnection;203;13;212;0
ASEEND*/
//CHKSM=248DAC056BD677AC5A49C0562FB409488F64D84D
