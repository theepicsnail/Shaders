// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/3DPano/3dPano 1"
{
	Properties
	{
		_Right("Right", 2D) = "white" {}
		_Left("Left", 2D) = "white" {}
		_EdgeScaleOffset__("Edge (Scale, Offset, _, _)", Vector) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 viewDir;
			float3 worldPos;
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

		uniform sampler2D _Left;
		uniform sampler2D _Right;
		uniform float2 _EdgeScaleOffset__;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float4 transform47 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float dotResult37 = dot( float4( i.viewDir , 0.0 ) , ( float4( ase_worldPos , 0.0 ) - transform47 ) );
			c.rgb = 0;
			c.a = saturate( (-dotResult37*_EdgeScaleOffset__.x + _EdgeScaleOffset__.y) );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 appendResult13 = (float2(( ( atan2( i.viewDir.x , i.viewDir.z ) / 6.28318548202515 ) + 0.5 ) , ( acos( i.viewDir.y ) / UNITY_PI )));
			float localunity_StereoEyeIndex99 = ( unity_StereoEyeIndex );
			float4 lerpResult8 = lerp( tex2D( _Left, appendResult13 ) , tex2D( _Right, appendResult13 ) , localunity_StereoEyeIndex99);
			o.Emission = lerpResult8.rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
972;92;948;926;947.2442;498.853;1.896496;False;False
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;10;-1494.687,-263.8692;Float;False;World;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;47;-628.6329,849.5553;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;48;-636.219,695.9395;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ATan2OpNode;11;-1214.213,-226.6702;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;25;-1199.407,-112.8167;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-404.8464,819.2114;Float;False;2;0;FLOAT3;0.0;False;1;FLOAT4;0.0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ACosOpNode;27;-1205.569,6.54071;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;30;-1254.569,86.54071;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;24;-1079.807,-212.9167;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;34;-422.8436,425.5525;Float;False;World;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-931.6064,-184.3167;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-1071.569,-9.45929;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;37;-200.8436,498.5525;Float;False;2;0;FLOAT3;0,0,0,0;False;1;FLOAT4;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;40;-176.1908,621.1404;Float;False;Property;_EdgeScaleOffset__;Edge (Scale, Offset, _, _);2;0;Create;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;38;-75.84363,496.5525;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-743.3392,-125.8187;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-511.7943,-228.1816;Float;True;Property;_Left;Left;1;0;Create;None;fd8ec6ae50d70ed4097432d97b998eea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;39;79.15637,505.5525;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;9;-440.1069,158.7135;Float;False;unity_StereoEyeIndex;1;False;0;unity_StereoEyeIndex;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-508.7943,-38.18156;Float;True;Property;_Right;Right;0;0;Create;None;120cba1e84671d047a1d021831d048f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;35;-430.8436,570.5525;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;8;-139.6465,11.07365;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;33;298.1564,519.5525;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;560.909,-86.7125;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;snail/3dPano;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Front;0;0;False;0;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.0,0,0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;1
WireConnection;11;1;10;3
WireConnection;49;0;48;0
WireConnection;49;1;47;0
WireConnection;27;0;10;2
WireConnection;24;0;11;0
WireConnection;24;1;25;0
WireConnection;26;0;24;0
WireConnection;29;0;27;0
WireConnection;29;1;30;0
WireConnection;37;0;34;0
WireConnection;37;1;49;0
WireConnection;38;0;37;0
WireConnection;13;0;26;0
WireConnection;13;1;29;0
WireConnection;1;1;13;0
WireConnection;39;0;38;0
WireConnection;39;1;40;1
WireConnection;39;2;40;2
WireConnection;2;1;13;0
WireConnection;8;0;1;0
WireConnection;8;1;2;0
WireConnection;8;2;9;0
WireConnection;33;0;39;0
WireConnection;0;2;8;0
WireConnection;0;9;33;0
ASEEND*/
//CHKSM=2F66135D6EC927A6C1B681B48ACF3C3BCA94442C
