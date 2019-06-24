// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/TextureAnimation/TextureAnimation"
{
	Properties
	{
		_texture("texture", 2D) = "white" {}
		_Scale("Scale", Range( 0 , 5)) = 1.248689
		_GradientTexture("GradientTexture", 2D) = "white" {}
		[Toggle] _Gradient("Gradient", Float) = 0.0
		_OnTime("OnTime", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Float) = 0
		_Metallic("Metallic", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _GRADIENT_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _GradientTexture;
		uniform sampler2D _texture;
		uniform float4 _texture_ST;
		uniform float _Scale;
		uniform float _OnTime;
		uniform float _Metallic;
		uniform float _Smoothness;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, clamp( p - K.xxx, 0.0, 1.0 ), c.y );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_texture = i.uv_texcoord * _texture_ST.xy + _texture_ST.zw;
			float4 tex2DNode1 = tex2D( _texture, uv_texture );
			float temp_output_3_0 = ( tex2DNode1.r + ( tex2DNode1.g * 256.0 ) );
			float mulTime5 = _Time.y * 0.1;
			float temp_output_4_0 = ( temp_output_3_0 - mulTime5 );
			float temp_output_8_0 = frac( ( temp_output_4_0 * _Scale ) );
			float temp_output_38_0 = ( temp_output_8_0 / _OnTime );
			float2 temp_cast_0 = (frac( temp_output_38_0 )).xx;
			float3 temp_cast_1 = (floor( temp_output_4_0 )).xxx;
			float simplePerlin3D16 = snoise( temp_cast_1 );
			float3 hsvTorgb3_g1 = HSVToRGB( float3(( simplePerlin3D16 + temp_output_8_0 ),1.0,1.0) );
			#ifdef _GRADIENT_ON
				float4 staticSwitch30 = tex2D( _GradientTexture, temp_cast_0 );
			#else
				float4 staticSwitch30 = float4( hsvTorgb3_g1 , 0.0 );
			#endif
			float clampResult36 = clamp( temp_output_38_0 , 0.0 , 1.0 );
			float4 lerpResult11 = lerp( staticSwitch30 , float4( 0,0,0,0 ) , floor( clampResult36 ));
			float clampResult20 = clamp( temp_output_3_0 , 0.0 , 1.0 );
			o.Emission = ( lerpResult11 * clampResult20 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1015;109;807;924;-645.5344;323.3522;1;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-1626.8,-139.2001;Float;True;Property;_texture;texture;0;0;Create;None;791e1d70500ab624faf7c5ed39104697;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1310.2,-50.39999;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;256.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1187.4,-248.9;Float;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-1136.7,-103.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1023.398,52.89949;Float;False;Property;_Scale;Scale;1;0;Create;1.248689;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-945.4004,-260.0001;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-699.2975,-239.8004;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;23;102.7019,-365.3005;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;8;-517.1997,-240.7003;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-571.2956,32.29874;Float;False;Property;_OnTime;OnTime;4;0;Create;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;161.9989,-239.0005;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;-252.796,-132.8009;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;348.8995,-242.7005;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;42;-244.0933,-410.6994;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;6;501.3998,-243.2;Float;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.ClampOpNode;36;271.1046,-45.70125;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-103.3956,-711.6005;Float;True;Property;_GradientTexture;GradientTexture;2;0;Create;None;0a7de72eaafb4a64ea94944f2c20bcbb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;30;662.5037,-508.4005;Float;False;Property;_Gradient;Gradient;3;0;Create;0;False;True;True;;Toggle;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;43;439.6046,-44.59837;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;20;392.702,238.5999;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;733.9998,-85.60004;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;45;803.5344,238.6478;Float;False;Property;_Metallic;Metallic;6;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;820.5344,352.6478;Float;True;Property;_Smoothness;Smoothness;5;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;923.802,82.59985;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1097.6,64.89987;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Snail/TextureAnimation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;2
WireConnection;3;0;1;1
WireConnection;3;1;2;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;21;0;4;0
WireConnection;21;1;22;0
WireConnection;23;0;4;0
WireConnection;8;0;21;0
WireConnection;16;0;23;0
WireConnection;38;0;8;0
WireConnection;38;1;37;0
WireConnection;13;0;16;0
WireConnection;13;1;8;0
WireConnection;42;0;38;0
WireConnection;6;1;13;0
WireConnection;36;0;38;0
WireConnection;27;1;42;0
WireConnection;30;0;27;0
WireConnection;30;1;6;6
WireConnection;43;0;36;0
WireConnection;20;0;3;0
WireConnection;11;0;30;0
WireConnection;11;2;43;0
WireConnection;19;0;11;0
WireConnection;19;1;20;0
WireConnection;0;2;19;0
WireConnection;0;3;45;0
WireConnection;0;4;46;0
ASEEND*/
//CHKSM=4D0160FF78597B84B4AA1E443BE8DA743A0C0565
