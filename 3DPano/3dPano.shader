// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/3DPano/3dPano"
{
	Properties
	{
		_Right("Right", 2D) = "white" {}
		_Left("Left", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 viewDir;
		};

		uniform sampler2D _Left;
		uniform sampler2D _Right;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult13 = (float2(( ( atan2( i.viewDir.x , i.viewDir.z ) / 6.28318548202515 ) + 0.5 ) , ( acos( i.viewDir.y ) / UNITY_PI )));
			float localunity_StereoEyeIndex99 = ( unity_StereoEyeIndex );
			float4 lerpResult8 = lerp( tex2D( _Left, appendResult13 ) , tex2D( _Right, appendResult13 ) , localunity_StereoEyeIndex99);
			o.Emission = lerpResult8.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
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
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
1412;92;508;650;1384.685;935.3364;3.370756;True;False
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;10;-1494.687,-263.8692;Float;False;World;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TauNode;25;-1199.407,-112.8167;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;11;-1214.213,-226.6702;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ACosOpNode;27;-1205.569,6.54071;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;30;-1254.569,86.54071;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;24;-1079.807,-212.9167;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-1071.569,-9.45929;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-931.6064,-184.3167;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-743.3392,-125.8187;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;9;-440.1069,158.7135;Float;False;unity_StereoEyeIndex;1;False;0;unity_StereoEyeIndex;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-508.7943,-38.18156;Float;True;Property;_Right;Right;0;0;Create;None;120cba1e84671d047a1d021831d048f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-511.7943,-228.1816;Float;True;Property;_Left;Left;1;0;Create;None;fd8ec6ae50d70ed4097432d97b998eea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;8;-139.6465,11.07365;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;368.909,-98.7125;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;snail/3dPano;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;1
WireConnection;11;1;10;3
WireConnection;27;0;10;2
WireConnection;24;0;11;0
WireConnection;24;1;25;0
WireConnection;29;0;27;0
WireConnection;29;1;30;0
WireConnection;26;0;24;0
WireConnection;13;0;26;0
WireConnection;13;1;29;0
WireConnection;2;1;13;0
WireConnection;1;1;13;0
WireConnection;8;0;1;0
WireConnection;8;1;2;0
WireConnection;8;2;9;0
WireConnection;0;2;8;0
ASEEND*/
//CHKSM=7F4D0388B154FA5F328F9D2D204AB0530FFBCBCB
