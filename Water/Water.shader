// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Water/Water"
{
	Properties
	{
		_Ripples("Ripples", 2D) = "white" {}
		_SurfaceTiling("SurfaceTiling", Float) = 512
		_SurfaceOpacity("SurfaceOpacity", Float) = 0.08
		_Wavespeed("Wavespeed", Float) = 0
		_Top("Top", Color) = (0,0,0,0)
		_Bottom("Bottom", Color) = (0,0,0,0)
		_MurkyScaleOffsetPower_("Murky [Scale, Offset, Power, _]", Vector) = (0,0,0,0)
		[Toggle]_Opacity("Opacity", Float) = 1
		_RippleNormals("RippleNormals", 2D) = "white" {}
		_Metallioc("Metallioc", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
			float3 data7_g1;
		};

		uniform sampler2D _RippleNormals;
		uniform float _Wavespeed;
		uniform float _SurfaceTiling;
		uniform float4 _Top;
		uniform float4 _Bottom;
		uniform sampler2D _CameraDepthTexture;
		uniform float4 _MurkyScaleOffsetPower_;
		uniform sampler2D _Ripples;
		uniform float _SurfaceOpacity;
		uniform float _Metallioc;
		uniform float _Smoothness;
		uniform float _Opacity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_vertex4Pos = v.vertex;
			o.data7_g1 = ( (mul( UNITY_MATRIX_MV, ase_vertex4Pos )).xyz * float3(-1,-1,1) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Wavespeed).xx;
			float2 temp_cast_1 = (_SurfaceTiling).xx;
			float2 uv_TexCoord30 = i.uv_texcoord * temp_cast_1 + float2( 0,0 );
			float2 _Vector0 = float2(2,4);
			float cos20 = cos( _Vector0.x );
			float sin20 = sin( _Vector0.x );
			float2 rotator20 = mul( uv_TexCoord30 - float2( 0,0 ) , float2x2( cos20 , -sin20 , sin20 , cos20 )) + float2( 0,0 );
			float2 panner21 = ( rotator20 + 1.0 * _Time.y * temp_cast_0);
			float2 temp_cast_2 = (_Wavespeed).xx;
			float cos19 = cos( _Vector0.y );
			float sin19 = sin( _Vector0.y );
			float2 rotator19 = mul( uv_TexCoord30 - float2( 0,0 ) , float2x2( cos19 , -sin19 , sin19 , cos19 )) + float2( 0,0 );
			float2 panner37 = ( rotator19 + 1.0 * _Time.y * temp_cast_2);
			float2 temp_cast_3 = (_Wavespeed).xx;
			float2 panner38 = ( uv_TexCoord30 + 1.0 * _Time.y * temp_cast_3);
			float4 SurfaceRipplesNormal60 = ( ( tex2D( _RippleNormals, panner21 ) + tex2D( _RippleNormals, panner37 ) + tex2D( _RippleNormals, panner38 ) ) / 3.0 );
			o.Normal = SurfaceRipplesNormal60.rgb;
			float3 ase_worldPos = i.worldPos;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float clampDepth11_g1 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float4 appendResult15_g1 = (float4(( clampDepth11_g1 * ( i.data7_g1 * ( _ProjectionParams.z / (i.data7_g1).z ) ) ) , 1.0));
			float temp_output_13_0 = pow( (length( ( ase_worldPos - (mul( unity_CameraToWorld, appendResult15_g1 )).xyz ) )*_MurkyScaleOffsetPower_.x + _MurkyScaleOffsetPower_.y) , _MurkyScaleOffsetPower_.z );
			float4 lerpResult7 = lerp( _Top , _Bottom , saturate( temp_output_13_0 ));
			float4 temp_output_42_0 = ( ( tex2D( _Ripples, panner21 ) + tex2D( _Ripples, panner37 ) + tex2D( _Ripples, panner38 ) ) / 3.0 );
			float4 lerpResult28 = lerp( lerpResult7 , temp_output_42_0 , _SurfaceOpacity);
			o.Albedo = (lerpResult28).rgb;
			o.Metallic = _Metallioc;
			o.Smoothness = _Smoothness;
			o.Alpha = lerp(1.0,(lerpResult28).a,_Opacity);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float3 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float4 screenPos : TEXCOORD4;
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
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
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyz = customInputData.data7_g1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.data7_g1 = IN.customPack2.xyz;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
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
Version=14201
160;172;961;839;-458.8831;1921.854;1;True;False
Node;AmplifyShaderEditor.FunctionNode;1;-1376.371,122.3594;Float;False;Reconstruct World Position From Depth;-1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;1;21;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;3;-1020.371,120.3594;Float;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-1051.371,-24.64065;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;32;-623.4611,-1151.285;Float;False;Property;_SurfaceTiling;SurfaceTiling;1;0;Create;512;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-836.3713,47.35936;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;36;-348.4728,-1309.513;Float;False;Constant;_Vector0;Vector 0;7;0;Create;2,4;2,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-400.8557,-1168.229;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;20;-129.2722,-1222.568;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;19;-121.7806,-1104.435;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;5;-700.3713,46.35936;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-79.96151,-1357.551;Float;False;Property;_Wavespeed;Wavespeed;3;0;Create;0;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;9;-962.3039,200.5654;Float;False;Property;_MurkyScaleOffsetPower_;Murky [Scale, Offset, Power, _];6;0;Create;0,0,0,0;0.08,0,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;38;109.4272,-989.7127;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;102.9083,-777.8185;Float;True;Property;_Ripples;Ripples;0;0;Create;None;8719aca685da18547bba4c5efd115203;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;37;106.8272,-1100.213;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;21;112.8472,-1213.845;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;6;-572.3712,47.35936;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;410.1057,-1045.554;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;408.3384,-1242.79;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;419.7735,-859.7538;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;13;-358.4112,133.661;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;761.8518,-1031.652;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;738.362,-905.6241;Float;False;Constant;_Float0;Float 0;8;0;Create;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;114.5514,-275.1329;Float;False;Property;_Bottom;Bottom;5;0;Create;0,0,0,0;0,0.02110294,0.2573524,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;106.5514,-459.1329;Float;False;Property;_Top;Top;4;0;Create;0,0,0,0;0.1136467,0.5346451,0.672,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;12;361.8145,130.4686;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;53;136.5852,-1820.72;Float;True;Property;_RippleNormals;RippleNormals;8;0;Create;None;130c9934c1a8367418ce5a9389ce7cf9;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;42;900.4324,-1013.341;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;7;470.4507,-82.9329;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;610.0027,-432.6663;Float;False;Property;_SurfaceOpacity;SurfaceOpacity;2;0;Create;0.08;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;428.7871,-1480.33;Float;True;Property;_TextureSample5;Texture Sample 5;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;417.3521,-1863.366;Float;True;Property;_TextureSample4;Texture Sample 4;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;419.1194,-1666.13;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;28;859.8007,-445.5591;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;770.866,-1652.228;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;747.3762,-1526.2;Float;False;Constant;_Float2;Float 2;8;0;Create;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;59;909.4465,-1633.917;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;734.1384,65.60616;Float;False;Constant;_Float1;Float 1;8;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;39;906.3082,-132.8919;Float;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;48;889.8473,37.05949;Float;False;Property;_Opacity;Opacity;7;0;Create;1;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-198.8076,123.8559;Float;False;EffectiveDepth;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;924.8831,181.1465;Float;False;Property;_Smoothness;Smoothness;10;0;Create;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;1045.114,-1648.06;Float;False;SurfaceRipplesNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;1036.1,-1027.484;Float;False;SurfaceRipples;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;40;903.7084,-205.6919;Float;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;46;668.1577,358.8909;Float;False;Constant;_Color0;Color 0;7;0;Create;1,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;61;860.8831,-55.85345;Float;False;60;0;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;62;922.8831,109.1465;Float;False;Property;_Metallioc;Metallioc;9;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1215.153,-72.8872;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Snail/Shaders/WaterSurface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;2;7;False;0;0;Transparent;0.5;True;True;0;False;Transparent;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;100;100;100;7;3;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;30;0;32;0
WireConnection;20;0;30;0
WireConnection;20;2;36;1
WireConnection;19;0;30;0
WireConnection;19;2;36;2
WireConnection;5;0;4;0
WireConnection;38;0;30;0
WireConnection;38;2;25;0
WireConnection;37;0;19;0
WireConnection;37;2;25;0
WireConnection;21;0;20;0
WireConnection;21;2;25;0
WireConnection;6;0;5;0
WireConnection;6;1;9;1
WireConnection;6;2;9;2
WireConnection;17;0;15;0
WireConnection;17;1;37;0
WireConnection;16;0;15;0
WireConnection;16;1;21;0
WireConnection;18;0;15;0
WireConnection;18;1;38;0
WireConnection;13;0;6;0
WireConnection;13;1;9;3
WireConnection;26;0;16;0
WireConnection;26;1;17;0
WireConnection;26;2;18;0
WireConnection;12;0;13;0
WireConnection;42;0;26;0
WireConnection;42;1;43;0
WireConnection;7;0;10;0
WireConnection;7;1;11;0
WireConnection;7;2;12;0
WireConnection;56;0;53;0
WireConnection;56;1;38;0
WireConnection;55;0;53;0
WireConnection;55;1;21;0
WireConnection;54;0;53;0
WireConnection;54;1;37;0
WireConnection;28;0;7;0
WireConnection;28;1;42;0
WireConnection;28;2;29;0
WireConnection;58;0;55;0
WireConnection;58;1;54;0
WireConnection;58;2;56;0
WireConnection;59;0;58;0
WireConnection;59;1;57;0
WireConnection;39;0;28;0
WireConnection;48;0;49;0
WireConnection;48;1;39;0
WireConnection;51;0;13;0
WireConnection;60;0;59;0
WireConnection;50;0;42;0
WireConnection;40;0;28;0
WireConnection;0;0;40;0
WireConnection;0;1;61;0
WireConnection;0;3;62;0
WireConnection;0;4;63;0
WireConnection;0;9;48;0
ASEEND*/
//CHKSM=D15E5814723826C82878CD23B2BE985A09CA3033
