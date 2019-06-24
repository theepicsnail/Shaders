// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Water/OtherStuff/Waves"
{
	Properties
	{
		_Prev("Prev", 2D) = "white" {}
		_Cur("Cur", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Prev;
		uniform float4 _Prev_TexelSize;
		uniform sampler2D _Cur;
		uniform float4 _Cur_ST;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord3 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 uv_Cur = i.uv_texcoord * _Cur_ST.xy + _Cur_ST.zw;
			o.Emission = saturate( ( ( ( tex2D( _Prev, (float2( 0.5,0 )*_Prev_TexelSize.x + uv_TexCoord3) ) + tex2D( _Prev, (float2( -1,0 )*_Prev_TexelSize.x + uv_TexCoord3) ) + tex2D( _Prev, (float2( 0,0.5 )*_Prev_TexelSize.y + uv_TexCoord3) ) + tex2D( _Prev, (float2( 0,-1 )*_Prev_TexelSize.y + uv_TexCoord3) ) ) / 3.0 ) - tex2D( _Cur, uv_Cur ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
900;92;1020;352;716.9437;-133.2168;2.050849;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;2;178.6996,758.8339;Float;True;Property;_Prev;Prev;0;0;Create;None;e9e32da7ec2276f4dafaa73da00e0ada;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexelSizeNode;5;-921.6457,112.8435;Float;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;31;-426.3307,220.3831;Float;False;1;0;SAMPLER2D;0.0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1120.186,501.4825;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-882.6302,418.3629;Float;False;Constant;_Vector1;Vector 1;2;0;Create;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;27;-652.9599,319.782;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;15;-879.0909,593.8482;Float;False;Constant;_Vector2;Vector 2;2;0;Create;0,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;29;-648.9839,583.5183;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;16;-852.4939,777.8116;Float;False;Constant;_Vector3;Vector 3;2;0;Create;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;28;-709.9483,692.1955;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;32;-379.9446,413.8791;Float;False;1;0;SAMPLER2D;0.0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;13;-881.3953,288.7383;Float;False;Constant;_Vector0;Vector 0;2;0;Create;0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;33;-360.0649,612.6763;Float;False;1;0;SAMPLER2D;0.0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;26;-578.6455,789.0396;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;1.0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;23;-584.8506,251.9739;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;1.0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;25;-581.2962,604.8207;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;1.0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;24;-582.6215,429.879;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;1.0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;7;-317.4886,400.5947;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-314.6568,578.9942;Float;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-321.0802,215.1435;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-313.2413,758.8078;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;392.7448,416.3166;Float;False;Constant;_Float0;Float 0;2;0;Create;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;60.54568,325.5544;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;186.788,552.4207;Float;True;Property;_Cur;Cur;1;0;Create;None;b0dee146f38f21c4b86047fd77811cc7;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;37;528.3577,333.1077;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;36;459.7091,551.2675;Float;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;763.7753,394.3621;Float;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;45;1000.274,390.7028;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;43;1184.616,341.1052;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Custom/Waves;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;False;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;2;0
WireConnection;31;0;2;0
WireConnection;27;0;5;1
WireConnection;29;0;3;0
WireConnection;28;0;5;2
WireConnection;32;0;31;0
WireConnection;33;0;32;0
WireConnection;26;0;16;0
WireConnection;26;1;28;0
WireConnection;26;2;29;0
WireConnection;23;0;13;0
WireConnection;23;1;27;0
WireConnection;23;2;29;0
WireConnection;25;0;15;0
WireConnection;25;1;28;0
WireConnection;25;2;29;0
WireConnection;24;0;14;0
WireConnection;24;1;27;0
WireConnection;24;2;29;0
WireConnection;7;0;32;0
WireConnection;7;1;24;0
WireConnection;8;0;33;0
WireConnection;8;1;25;0
WireConnection;6;0;31;0
WireConnection;6;1;23;0
WireConnection;9;0;33;0
WireConnection;9;1;26;0
WireConnection;20;0;6;0
WireConnection;20;1;7;0
WireConnection;20;2;8;0
WireConnection;20;3;9;0
WireConnection;37;0;20;0
WireConnection;37;1;38;0
WireConnection;36;0;1;0
WireConnection;39;0;37;0
WireConnection;39;1;36;0
WireConnection;45;0;39;0
WireConnection;43;2;45;0
ASEEND*/
//CHKSM=691288A929D1B7B0CECC5CE99E68E2A8F7CFEE2C
