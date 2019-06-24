// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Camera/2/UpdateMemory"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord19 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			o.Emission = frac( ( tex2D( _MainTex, uv_TexCoord19 ) - float4( uv_TexCoord19, 0.0 , 0.0 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1001;92;919;926;1859.883;523.1625;1.601971;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1540.632,369.4261;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;17;-1873.766,-31.22244;Float;True;Property;_MainTex;MainTex;0;0;Create;73e13c93b460f97439307a3accebad03;73e13c93b460f97439307a3accebad03;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;1;-1103.38,-35.97739;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;None;73e13c93b460f97439307a3accebad03;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-1032.647,412.3885;Float;False;2;0;COLOR;0.0;False;1;FLOAT2;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FractNode;22;-818.3812,386.757;Float;False;1;0;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexelSizeNode;15;-1520.766,193.7776;Float;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1298.632,280.4261;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-362.3556,169.0826;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Geometry;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;False;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;17;0
WireConnection;1;1;19;0
WireConnection;21;0;1;0
WireConnection;21;1;19;0
WireConnection;22;0;21;0
WireConnection;15;0;17;0
WireConnection;20;0;15;0
WireConnection;20;1;19;0
WireConnection;0;2;22;0
ASEEND*/
//CHKSM=A35BE52BC4A3D84BA07E369DEFDEF780F76C40AA
