// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Pokadots 1/New AmplifyShader"
{
	Properties
	{
		_Base("Base", Color) = (0,0,0,0)
		_ColorCont("ColorCont", Float) = 2
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		_Color2("Color 2", Color) = (0,0,0,0)
		_ObjectSpaceScale("ObjectSpaceScale", Float) = 0
		_WorldSpaceScale("WorldSpaceScale", Float) = 0
		_TimeOffset("TimeOffset", Vector) = (0,0,0,0)
		_DotSharpness("DotSharpness", Float) = 10
		_ShadowBaseBrightness("ShadowBaseBrightness", Float) = 0.5
		_ShadowRamp("ShadowRamp", 2D) = "white" {}
		_ShadowPower("ShadowPower", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Float) = 1
		_Metallic("Metallic", Float) = 1
		[Toggle]_FlipRampDirection("FlipRampDirection", Float) = 1
		_BaseTexture("BaseTexture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float3 worldPos;
			float2 uv_texcoord;
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

		uniform sampler2D _ShadowRamp;
		uniform float _FlipRampDirection;
		uniform float _ShadowBaseBrightness;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _ShadowPower;
		uniform float4 _Base;
		uniform float _ObjectSpaceScale;
		uniform float _WorldSpaceScale;
		uniform float _ColorCont;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float4 _TimeOffset;
		uniform float _DotSharpness;
		uniform sampler2D _BaseTexture;
		uniform float4 _BaseTexture_ST;


		inline float4 MyCustomExpression71( float C , float4 C1 , float4 C2 , float4 C3 )
		{
			return (C==0)*C1+
			(C==1)*C2+
			(C==2)*C3;
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


		inline float MyCustomExpression54( float r , float p )
		{
			return 1-pow((1-r),p);
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 temp_cast_0 = (1.0).xxxx;
			SurfaceOutputStandardSpecular s78 = (SurfaceOutputStandardSpecular ) 0;
			float3 temp_cast_1 = (_ShadowBaseBrightness).xxx;
			s78.Albedo = temp_cast_1;
			s78.Normal = i.worldNormal;
			s78.Emission = float3( 0,0,0 );
			float3 temp_cast_2 = (_Metallic).xxx;
			s78.Specular = temp_cast_2;
			s78.Smoothness = _Smoothness;
			s78.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi78 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g78 = UnityGlossyEnvironmentSetup( s78.Smoothness, data.worldViewDir, s78.Normal, float3(0,0,0));
			gi78 = UnityGlobalIllumination( data, s78.Occlusion, s78.Normal, g78 );
			#endif

			float3 surfResult78 = LightingStandardSpecular ( s78, viewDir, gi78 ).rgb;
			surfResult78 += s78.Emission;

			float dotResult81 = dot( float3(0.3,0.59,0.11) , ( saturate( surfResult78 ) * 0.99 ) );
			float2 temp_cast_3 = (lerp(( 1.0 - dotResult81 ),dotResult81,_FlipRampDirection)).xx;
			float4 lerpResult88 = lerp( temp_cast_0 , tex2D( _ShadowRamp, temp_cast_3 ) , _ShadowPower);
			SurfaceOutputStandardSpecular s79 = (SurfaceOutputStandardSpecular ) 0;
			float3 ase_worldPos = i.worldPos;
			float4 appendResult35 = (float4(ase_worldPos , 1.0));
			float4 transform34 = mul(unity_WorldToObject,appendResult35);
			float3 temp_output_36_0 = ( ( (transform34).xyz * _ObjectSpaceScale ) + ( ase_worldPos * _WorldSpaceScale ) );
			float3 temp_output_5_0 = floor( temp_output_36_0 );
			float simplePerlin3D65 = snoise( temp_output_5_0 );
			float C71 = floor( (0.0 + (simplePerlin3D65 - -1.0) * (_ColorCont - 0.0) / (1.0 - -1.0)) );
			float4 C171 = _Color0;
			float4 C271 = _Color1;
			float4 C371 = _Color2;
			float4 localMyCustomExpression7171 = MyCustomExpression71( C71 , C171 , C271 , C371 );
			float2 _Vector1 = float2(2,-1);
			float mulTime41 = _Time.y * _TimeOffset.w;
			float3 temp_output_43_0 = ( (_TimeOffset).xyz * mulTime41 );
			float simplePerlin3D1 = snoise( ( (temp_output_5_0).yzx + temp_output_43_0 ) );
			float simplePerlin3D6 = snoise( ( temp_output_43_0 + temp_output_5_0 ) );
			float simplePerlin3D7 = snoise( ( temp_output_43_0 + (temp_output_5_0).zxy ) );
			float3 appendResult10 = (float3(simplePerlin3D1 , simplePerlin3D6 , simplePerlin3D7));
			float r54 = saturate( ( 1.0 - ( length( ( (( temp_output_36_0 - temp_output_5_0 )*_Vector1.x + _Vector1.y) - appendResult10 ) ) / ( 1.0 - max( max( abs( appendResult10 ).x , abs( appendResult10 ).y ) , abs( appendResult10 ).z ) ) ) ) );
			float p54 = _DotSharpness;
			float localMyCustomExpression5454 = MyCustomExpression54( r54 , p54 );
			float4 lerpResult47 = lerp( _Base , localMyCustomExpression7171 , saturate( localMyCustomExpression5454 ));
			s79.Albedo = lerpResult47.xyz;
			s79.Normal = i.worldNormal;
			s79.Emission = float3( 0,0,0 );
			float3 temp_cast_9 = (_Metallic).xxx;
			s79.Specular = temp_cast_9;
			s79.Smoothness = _Smoothness;
			s79.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi79 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g79 = UnityGlossyEnvironmentSetup( s79.Smoothness, data.worldViewDir, s79.Normal, float3(0,0,0));
			gi79 = UnityGlobalIllumination( data, s79.Occlusion, s79.Normal, g79 );
			#endif

			float3 surfResult79 = LightingStandardSpecular ( s79, viewDir, gi79 ).rgb;
			surfResult79 += s79.Emission;

			float4 appendResult104 = (float4(surfResult79 , (lerpResult47).w));
			float2 uv_BaseTexture = i.uv_texcoord * _BaseTexture_ST.xy + _BaseTexture_ST.zw;
			float4 temp_output_103_0 = ( ( lerpResult88 * appendResult104 ) * tex2D( _BaseTexture, uv_BaseTexture ) );
			c.rgb = temp_output_103_0.rgb;
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
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
Version=14201
1206;92;714;926;180.4682;946.6974;1.607754;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-520.7927,-254.8417;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;35;-337.2831,-500.3493;Float;False;FLOAT4;4;0;FLOAT3;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;1.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;34;-190.813,-504.0111;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;39;6.95077,-506.0843;Float;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;12.9269,-405.1022;Float;False;Property;_ObjectSpaceScale;ObjectSpaceScale;5;0;Create;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-77.47977,-180.8067;Float;False;Property;_WorldSpaceScale;WorldSpaceScale;6;0;Create;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;194.5916,-505.8849;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;136.6161,-262.8824;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;362.3153,-262.7237;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;55;-175.6647,0.5624444;Float;False;Property;_TimeOffset;TimeOffset;7;0;Create;0,0,0,0;0,-1,0,0.1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;41;35.1021,89.58132;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;56;25.83557,-2.037692;Float;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FloorOpNode;5;509.1298,-125.5977;Float;False;1;0;FLOAT3;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;9;640.0688,-62.66785;Float;False;FLOAT3;2;0;1;2;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;8;642.1043,-192.9182;Float;False;FLOAT3;1;2;0;2;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;201.637,2.907733;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;382.5573,70.06316;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;385.157,-23.53673;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;378.6573,161.0632;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;834.6319,-191.3413;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;833.5681,-125.2752;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;7;832.9068,-61.66785;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;1027.375,-147.1145;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;21;834.7145,119.3082;Float;False;1;0;FLOAT3;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;64;644.4205,-462.5201;Float;False;Constant;_Vector1;Vector 1;7;0;Create;2,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;581.8113,-308.5146;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;23;943.9144,121.9081;Float;False;FLOAT3;1;0;FLOAT3;0.0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;20;1168.812,119.3082;Float;False;2;0;FLOAT;0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;63;857.2201,-344.1201;Float;False;3;0;FLOAT3;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;22;1278.014,146.608;Float;False;2;0;FLOAT;0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;1207.717,-190.8911;Float;False;2;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;11;1372.876,-41.61488;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;2467.529,-700.4628;Float;False;Property;_ShadowBaseBrightness;ShadowBaseBrightness;9;0;Create;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;2460.326,-438.4478;Float;False;Property;_Smoothness;Smoothness;12;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;1390.313,146.6082;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;2466.264,-524.5568;Float;False;Property;_Metallic;Metallic;13;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;78;2640.044,-619.0488;Float;False;Specular;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0;False;4;FLOAT;0.0;False;5;FLOAT;1.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;1541.112,124.5085;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;1237.626,-403.2238;Float;False;Property;_ColorCont;ColorCont;1;0;Create;2;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;65;1218.637,-518.6467;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;2878.898,-543.7275;Float;False;Constant;_Float2;Float 2;9;0;Create;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;2878.897,-619.3835;Float;False;1;0;FLOAT3;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;27;1694.542,119.9796;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;1848.844,120.6797;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;66;1437.036,-531.6468;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;-1.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;3.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;82;2955.017,-774.9364;Float;False;Constant;_Vector0;Vector 0;8;0;Create;0.3,0.59,0.11;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;3037.93,-617.8397;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;52;1719.332,220.1604;Float;False;Property;_DotSharpness;DotSharpness;8;0;Create;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;67;1598.007,-536.8449;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;1351.846,-1061.507;Float;False;Property;_Color0;Color 0;2;0;Create;0,0,0,0;0.8901961,0.5215685,0.7294118,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;54;2018.533,119.9609;Float;False;1-pow((1-r),p);1;False;2;True;r;FLOAT;0.0;In;True;p;FLOAT;0.0;In;My Custom Expression;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;68;1358.083,-889.7778;Float;False;Property;_Color1;Color 1;3;0;Create;0,0,0,0;0.4549019,0.7764706,0.7764706,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;81;3180.48,-698.4883;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;69;1376.445,-720.1616;Float;False;Property;_Color2;Color 2;4;0;Create;0,0,0,0;1,0.9294118,0.5843138,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;45;2085.777,-687.1071;Float;False;Property;_Base;Base;0;0;Create;0,0,0,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;71;1751.406,-666.8447;Float;False;(C==0)*C1+$(C==1)*C2+$(C==2)*C3;4;False;4;True;C;FLOAT;0.0;In;True;C1;FLOAT4;0,0,0,0;In;True;C2;FLOAT4;0,0,0,0;In;True;C3;FLOAT4;0,0,0,0;In;My Custom Expression;4;0;FLOAT;0.0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;99;3160.833,-858.1691;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;53;2228.633,115.4602;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;2407.025,-340.8225;Float;False;3;0;FLOAT4;0.0;False;1;FLOAT4;0.0,0,0,0;False;2;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ToggleSwitchNode;100;3248.833,-1052.169;Float;False;Property;_FlipRampDirection;FlipRampDirection;14;0;Create;1;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;3473.334,-807.751;Float;False;Constant;_Float3;Float 3;9;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;79;2646.262,-309.2926;Float;False;Specular;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0;False;4;FLOAT;0.0;False;5;FLOAT;1.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;106;2668.342,-91.43206;Float;False;FLOAT;3;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;3335.921,-531.3755;Float;False;Property;_ShadowPower;ShadowPower;11;0;Create;0;0.72;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;83;3295.273,-720.5803;Float;True;Property;_ShadowRamp;ShadowRamp;10;0;Create;None;7ec716b81bf49854b9f245925cfc982f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;104;2896.188,-284.0727;Float;False;FLOAT4;4;0;FLOAT3;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;1.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;88;3613.842,-673.4235;Float;False;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;102;2836.933,-115.5406;Float;True;Property;_BaseTexture;BaseTexture;15;0;Create;None;2fdbdc0f4e69e2446949ba0d39dd120e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;3620.018,-367.7114;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;105;4069.739,-333.3221;Float;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;3874.833,-274.1692;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;77;4294.875,-456.5922;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Pokadots;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0,0,0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;0;2;0
WireConnection;34;0;35;0
WireConnection;39;0;34;0
WireConnection;3;0;39;0
WireConnection;3;1;4;0
WireConnection;37;0;2;0
WireConnection;37;1;38;0
WireConnection;36;0;3;0
WireConnection;36;1;37;0
WireConnection;41;0;55;4
WireConnection;56;0;55;0
WireConnection;5;0;36;0
WireConnection;9;0;5;0
WireConnection;8;0;5;0
WireConnection;43;0;56;0
WireConnection;43;1;41;0
WireConnection;93;0;43;0
WireConnection;93;1;5;0
WireConnection;92;0;8;0
WireConnection;92;1;43;0
WireConnection;94;0;43;0
WireConnection;94;1;9;0
WireConnection;1;0;92;0
WireConnection;6;0;93;0
WireConnection;7;0;94;0
WireConnection;10;0;1;0
WireConnection;10;1;6;0
WireConnection;10;2;7;0
WireConnection;21;0;10;0
WireConnection;17;0;36;0
WireConnection;17;1;5;0
WireConnection;23;0;21;0
WireConnection;20;0;23;0
WireConnection;20;1;23;1
WireConnection;63;0;17;0
WireConnection;63;1;64;1
WireConnection;63;2;64;2
WireConnection;22;0;20;0
WireConnection;22;1;23;2
WireConnection;18;0;63;0
WireConnection;18;1;10;0
WireConnection;11;0;18;0
WireConnection;24;0;22;0
WireConnection;78;0;80;0
WireConnection;78;3;95;0
WireConnection;78;4;96;0
WireConnection;25;0;11;0
WireConnection;25;1;24;0
WireConnection;65;0;5;0
WireConnection;85;0;78;0
WireConnection;27;0;25;0
WireConnection;26;0;27;0
WireConnection;66;0;65;0
WireConnection;66;4;91;0
WireConnection;86;0;85;0
WireConnection;86;1;87;0
WireConnection;67;0;66;0
WireConnection;54;0;26;0
WireConnection;54;1;52;0
WireConnection;81;0;82;0
WireConnection;81;1;86;0
WireConnection;71;0;67;0
WireConnection;71;1;46;0
WireConnection;71;2;68;0
WireConnection;71;3;69;0
WireConnection;99;0;81;0
WireConnection;53;0;54;0
WireConnection;47;0;45;0
WireConnection;47;1;71;0
WireConnection;47;2;53;0
WireConnection;100;0;99;0
WireConnection;100;1;81;0
WireConnection;79;0;47;0
WireConnection;79;3;95;0
WireConnection;79;4;96;0
WireConnection;106;0;47;0
WireConnection;83;1;100;0
WireConnection;104;0;79;0
WireConnection;104;3;106;0
WireConnection;88;0;89;0
WireConnection;88;1;83;0
WireConnection;88;2;90;0
WireConnection;84;0;88;0
WireConnection;84;1;104;0
WireConnection;105;0;103;0
WireConnection;103;0;84;0
WireConnection;103;1;102;0
WireConnection;77;9;105;0
WireConnection;77;13;103;0
ASEEND*/
//CHKSM=B197D806E4EA3F1D1F8B87E1076A78A1343ACC19
