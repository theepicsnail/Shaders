// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Burn/New Amplify Shader"
{
	Properties
	{
		_Vector1("Vector 1", Vector) = (15,6,0,0)
		_Vector0("Vector 0", Vector) = (15,6,0,0)
		_Float3("Float 3", Float) = 4
		_Vector3("Vector 3", Vector) = (5,5,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float _Float3;
		uniform float2 _Vector3;
		uniform float2 _Vector0;
		uniform float2 _Vector1;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner69 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + i.uv_texcoord);
			float simplePerlin2D71 = snoise( ( _Vector3 * panner69 ) );
			float mulTime54 = _Time.y * -0.1;
			float2 appendResult57 = (float2(0.0 , mulTime54));
			float2 uv_TexCoord32 = i.uv_texcoord + appendResult57;
			float simplePerlin2D1 = snoise( ( uv_TexCoord32 * _Vector0 ) );
			float2 uv_TexCoord58 = i.uv_texcoord + appendResult57;
			float simplePerlin2D61 = snoise( ( uv_TexCoord58 * _Vector1 ) );
			float2 temp_cast_0 = (( 1.0 - ( ( ( ( _Float3 * i.uv_texcoord.y ) + simplePerlin2D71 ) - saturate( simplePerlin2D1 ) ) - saturate( simplePerlin2D61 ) ) )).xx;
			o.Albedo = tex2D( _TextureSample0, temp_cast_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
870;92;1050;638;1238.258;721.9266;2.330609;True;False
Node;AmplifyShaderEditor.RangedFloatNode;55;-785.3956,289.963;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;54;-615.0956,296.463;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-452.5951,271.7631;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;73;-283.9623,-496.1836;Float;False;Constant;_Vector2;Vector 2;0;0;Create;True;0;0;False;0;0,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-212.8022,-141.1513;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;93;-90.81817,394.9602;Float;False;Property;_Vector0;Vector 0;1;0;Create;True;0;0;False;0;15,6;12,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-125.4821,237.463;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;69;-40.87128,-429.9984;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;76;8.64706,-559.9371;Float;False;Property;_Vector3;Vector 3;3;0;Create;True;0;0;False;0;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;109.8741,239.312;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;66;-69.54812,754.5014;Float;False;Property;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;15,6;13,11;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-126.3542,642.1327;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;188.047,-487.137;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;64;14.57385,-235.3327;Float;False;Property;_Float3;Float 3;2;0;Create;True;0;0;False;0;4;3.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;129.1442,639.2813;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;71;324.0375,-344.1848;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;179.9739,-144.0327;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;263.1481,238.1207;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;83;474.182,240.9951;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;420.6377,-170.7839;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;61;285.3441,635.9004;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;855.8039,26.76308;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;84;495.8279,630.2159;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;1023.074,27.56726;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;85;1210.808,23.59018;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;1539.116,-0.932889;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1821.976,3.718532;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;55;0
WireConnection;57;1;54;0
WireConnection;32;1;57;0
WireConnection;69;0;49;0
WireConnection;69;2;73;0
WireConnection;94;0;32;0
WireConnection;94;1;93;0
WireConnection;58;1;57;0
WireConnection;75;0;76;0
WireConnection;75;1;69;0
WireConnection;60;0;58;0
WireConnection;60;1;66;0
WireConnection;71;0;75;0
WireConnection;63;0;64;0
WireConnection;63;1;49;2
WireConnection;1;0;94;0
WireConnection;83;0;1;0
WireConnection;74;0;63;0
WireConnection;74;1;71;0
WireConnection;61;0;60;0
WireConnection;53;0;74;0
WireConnection;53;1;83;0
WireConnection;84;0;61;0
WireConnection;62;0;53;0
WireConnection;62;1;84;0
WireConnection;85;0;62;0
WireConnection;77;1;85;0
WireConnection;0;0;77;0
ASEEND*/
//CHKSM=0BE5A3C0F87A8B5ABDBA49412EB5EAF4D4300446
