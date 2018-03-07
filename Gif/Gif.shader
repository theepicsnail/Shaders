// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Snail/Gif"
{
	Properties
	{
		_SpriteSheet("SpriteSheet", 2D) = "white" {}
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_TransparencyCleanup("TransparencyCleanup", Float) = 1
		_Rows("Rows", Float) = 0
		_Columns("Columns", Float) = 0
		_TotalTiles("TotalTiles", Float) = 0
		_Speed("Speed", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		_Metallic("Metallic", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _SpriteSheet;
		uniform float _Speed;
		uniform float _Columns;
		uniform float _Rows;
		uniform float _TotalTiles;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _TransparencyCleanup;


		float2 MyCustomExpression19( float Speed , float2 UV , float2 Tiles , float TileCount )
		{
			float frame = floor(fmod(_Time.y * Speed, TileCount));
			float column = fmod(frame, Tiles.x);
			float row = fmod(frame-column, Tiles.y);
			float2 offset = float2(row, column);
			return (UV+offset) / Tiles;//float2(x,y);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float Speed19 = _Speed;
			float2 uv_TexCoord20 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 UV19 = uv_TexCoord20;
			float2 appendResult31 = (float2(_Columns , _Rows));
			float2 Tiles19 = appendResult31;
			float TileCount19 = _TotalTiles;
			float2 localMyCustomExpression1919 = MyCustomExpression19( Speed19 , UV19 , Tiles19 , TileCount19 );
			float4 tex2DNode1 = tex2D( _SpriteSheet, localMyCustomExpression1919 );
			o.Albedo = tex2DNode1.rgb;
			o.Emission = ( _EmissionColor * tex2DNode1 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = pow( tex2DNode1.a , _TransparencyCleanup );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD2;
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
1077;92;843;624;277.6227;1369.359;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;29;-20.39697,-773.3984;Float;False;Property;_Columns;Columns;4;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-19.09693,-700.5983;Float;False;Property;_Rows;Rows;3;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;169.0958,-1061.87;Float;False;Property;_Speed;Speed;6;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;178.5031,-785.0987;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-16.55024,-621.6559;Float;False;Property;_TotalTiles;TotalTiles;5;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;88.9585,-948.5035;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;19;373.3844,-960.2883;Float;False;float frame = floor(fmod(_Time.y * Speed, TileCount))@$float column = fmod(frame, Tiles.x)@$flow row = fmod(frame-column, Tiles.y)@$float2 offset = float2(row, column)@$$return (UV+offset) / Tiles@//float2(x,y)@;2;False;4;True;Speed;FLOAT;15.0;In;True;UV;FLOAT2;0,0;In;True;Tiles;FLOAT2;5,20;In;True;TileCount;FLOAT;19.0;In;My Custom Expression;4;0;FLOAT;15.0;False;1;FLOAT2;0,0;False;2;FLOAT2;5,20;False;3;FLOAT;19.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;33;960.5693,-670.3186;Float;False;Property;_TransparencyCleanup;TransparencyCleanup;2;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;606.8221,-975.3683;Float;True;Property;_SpriteSheet;SpriteSheet;0;0;Create;88611999e35471f47b4f1903c5a38193;88611999e35471f47b4f1903c5a38193;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;983.7863,-1182.548;Float;False;Property;_EmissionColor;EmissionColor;1;0;Create;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;1221.633,-901.9298;Float;False;Property;_Metallic;Metallic;8;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;32;1228.529,-728.9341;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1201.116,-1060.346;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;25;1196.436,-828.5921;Float;False;Property;_Smoothness;Smoothness;7;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1473.752,-970.3669;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Snail/Gif;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Transparent;0.5;True;True;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;29;0
WireConnection;31;1;30;0
WireConnection;19;0;5;0
WireConnection;19;1;20;0
WireConnection;19;2;31;0
WireConnection;19;3;34;0
WireConnection;1;1;19;0
WireConnection;32;0;1;4
WireConnection;32;1;33;0
WireConnection;28;0;27;0
WireConnection;28;1;1;0
WireConnection;0;0;1;0
WireConnection;0;2;28;0
WireConnection;0;3;24;0
WireConnection;0;4;25;0
WireConnection;0;9;32;0
ASEEND*/
//CHKSM=6E5A20A1C9FE3DC3D326A4B8D951B0E26B8E6496