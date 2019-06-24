// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Squares/Squares 2"
{
	Properties
	{
		_Scale("Scale", Float) = 0
		_Posterize("Posterize", Float) = 0
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
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
			float2 uv3_texcoord3;
		};

		uniform float _Posterize;
		uniform float _Scale;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv3_TexCoord69 = i.uv3_texcoord3 * float2( 1,1 ) + float2( 0,0 );
			float div83=256.0/float((int)_Posterize);
			float4 posterize83 = ( floor( float4( uv3_TexCoord69, 0.0 , 0.0 ) * div83 ) / div83 );
			float3 appendResult82 = (float3(( posterize83 * _Scale ).rg , _Time.y));
			float simplePerlin3D81 = snoise( appendResult82 );
			float3 temp_cast_3 = (simplePerlin3D81).xxx;
			o.Albedo = temp_cast_3;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1051;92;869;926;-788.5561;-249.1732;1.790747;True;False
Node;AmplifyShaderEditor.RangedFloatNode;84;1565.74,1087.243;Float;False;Property;_Posterize;Posterize;3;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;1532.061,932.2912;Float;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;1691.205,618.0161;Float;False;Property;_Scale;Scale;2;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosterizeNode;83;1766.304,954.7275;Float;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;1931.292,433.8891;Float;False;2;2;0;COLOR;0,0;False;1;FLOAT;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;78;1654.581,707.4241;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;2078.749,442.3687;Float;False;FLOAT3;4;0;FLOAT2;0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;1309.067,-185.2051;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;1080.067,-347.2051;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;62;1462.067,-278.2051;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DeltaTime;53;1071.067,-242.2051;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;56;1928.811,-537.0735;Float;False;Property;_Color0;Color 0;1;0;Create;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;75;2519.642,304.4449;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;57;1776.186,-505.6987;Float;False;Property;_Color1;Color 1;0;0;Create;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareLower;54;1904.677,-281.2051;Float;False;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;58;1617.067,-277.2051;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;1929.502,317.473;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;81;2224.803,436.5896;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;1661.745,313.4;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;1661.22,192.8796;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1932.792,199.7259;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;80;2076.958,325.9525;Float;False;FLOAT3;4;0;FLOAT2;0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;55;2122.185,-416.6987;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;60;1993.067,-41.20508;Float;False;1;0;OBJECT;0.0;False;1;OBJECT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;64;2221.149,195.1617;Float;False;Simplex3D;1;0;FLOAT3;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;2077.261,198.7751;Float;False;FLOAT3;4;0;FLOAT2;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;79;2220.846,322.3391;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;19;3066.753,718.9855;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/Squares;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;83;1;69;0
WireConnection;83;0;84;0
WireConnection;73;0;83;0
WireConnection;73;1;67;0
WireConnection;82;0;73;0
WireConnection;82;2;78;0
WireConnection;61;0;52;0
WireConnection;61;1;53;1
WireConnection;62;0;52;0
WireConnection;62;1;61;0
WireConnection;75;0;64;0
WireConnection;75;1;79;0
WireConnection;75;2;81;0
WireConnection;54;0;58;0
WireConnection;54;1;58;0
WireConnection;58;0;62;0
WireConnection;71;0;68;0
WireConnection;71;1;67;0
WireConnection;81;0;82;0
WireConnection;66;0;65;0
WireConnection;66;1;67;0
WireConnection;80;0;71;0
WireConnection;80;2;78;0
WireConnection;55;0;56;0
WireConnection;55;1;57;0
WireConnection;55;2;61;0
WireConnection;64;0;76;0
WireConnection;76;0;66;0
WireConnection;76;2;78;0
WireConnection;79;0;80;0
WireConnection;19;0;81;0
ASEEND*/
//CHKSM=63F11ED44D902F0A4B3942A6C68AD20792639C2D
