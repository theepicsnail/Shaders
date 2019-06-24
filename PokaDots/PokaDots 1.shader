// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/PokaDots/PokaDots 1"
{
	Properties
	{
		_WorldSpaceScale("WorldSpaceScale", Float) = 0
		_Objectspacescale("Object space scale", Float) = 0
		_OverallScale("OverallScale", Float) = 1
		_Speed("Speed", Float) = 0
		_HueVarianceOffsetCycleSpeed_("Hue <Variance, Offset, CycleSpeed,_>", Vector) = (0,0,0,0)
		_Emission("Emission", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Speed;
		uniform float _WorldSpaceScale;
		uniform float _Objectspacescale;
		uniform float _OverallScale;
		uniform float3 _HueVarianceOffsetCycleSpeed_;
		uniform float _Emission;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, clamp( p - K.xxx, 0.0, 1.0 ), c.y );
		}


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
			float mulTime21 = _Time.y * _Speed;
			float3 ase_worldPos = i.worldPos;
			float4 transform26 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 appendResult65 = (float3(transform26.x , transform26.y , transform26.z));
			float simplePerlin3D16 = snoise( floor( ( ( ( _WorldSpaceScale * ase_worldPos ) + ( ( ase_worldPos - appendResult65 ) * _Objectspacescale ) ) * _OverallScale ) ) );
			float2 appendResult23 = (float2(mulTime21 , simplePerlin3D16));
			float simplePerlin2D20 = snoise( appendResult23 );
			float mulTime40 = _Time.y * _HueVarianceOffsetCycleSpeed_.z;
			float3 hsvTorgb3_g1 = HSVToRGB( float3(( ( simplePerlin2D20 * _HueVarianceOffsetCycleSpeed_.x ) + _HueVarianceOffsetCycleSpeed_.y + mulTime40 ),1.0,1.0) );
			float4 _Vector0 = float4(0,1,-1,1);
			float3 temp_cast_0 = (_Vector0.x).xxx;
			float3 temp_cast_1 = (_Vector0.y).xxx;
			float3 temp_cast_2 = (_Vector0.z).xxx;
			float3 temp_cast_3 = (_Vector0.w).xxx;
			float3 temp_output_13_0 = ( hsvTorgb3_g1 * ( 1.0 - length( (temp_cast_2 + (frac( ( ( ( _WorldSpaceScale * ase_worldPos ) + ( ( ase_worldPos - appendResult65 ) * _Objectspacescale ) ) * _OverallScale ) ) - temp_cast_0) * (temp_cast_3 - temp_cast_2) / (temp_cast_1 - temp_cast_0)) ) ) );
			o.Albedo = temp_output_13_0;
			float3 temp_cast_4 = (_Vector0.x).xxx;
			float3 temp_cast_5 = (_Vector0.y).xxx;
			float3 temp_cast_6 = (_Vector0.z).xxx;
			float3 temp_cast_7 = (_Vector0.w).xxx;
			o.Emission = ( temp_output_13_0 * _Emission );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1015;92;905;926;-1325.03;430.5518;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;66;-2152.987,-139.4777;Float;False;802.1416;479.1716;Object space scaling (done in world space);6;27;32;34;65;63;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;26;-2102.987,28.55409;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;63;-1912.976,-89.47766;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;65;-1859.976,52.52234;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;64;-1819.321,-484.047;Float;False;469.968;306.6848;World space Scaling;3;31;30;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1748.359,-356.3622;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-1695.519,30.84457;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1780.603,224.6939;Float;False;Property;_Objectspacescale;Object space scale;1;0;Create;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1769.321,-434.047;Float;False;Property;_WorldSpaceScale;WorldSpaceScale;0;0;Create;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;67;-1135.33,-264.2463;Float;False;405.0721;267.6144;Mix for final space;3;33;3;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1519.846,41.32976;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1518.353,-396.5945;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1040.005,-214.2463;Float;False;2;2;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1085.33,-111.6319;Float;False;Property;_OverallScale;OverallScale;2;0;Create;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-236.3498,-678.8059;Float;False;1770.127;410.4276;Hue Per Voxel;4;74;71;70;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-899.2581,-209.7516;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;68;-637.7368,-293.115;Float;False;326.0365;243.115;ID(floor) and Position(fract);3;41;15;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RelayNode;41;-587.7368,-203.8936;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;71;-186.3498,-628.8059;Float;False;724.6002;187.0997;Unique voxel noise (over time);4;21;25;23;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FloorOpNode;15;-469.3843,-243.115;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-136.3498,-578.8058;Float;False;Property;_Speed;Speed;3;0;Create;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;70;-176.9581,-433.3781;Float;False;283;165;Unique voxel value;1;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-126.9581,-383.3781;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;21;4.650858,-575.3062;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;175.4506,-574.7062;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;74;553.2379,-620.1178;Float;False;751.5479;308.7677;Compute a controllable hue value;4;37;40;73;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;69;-187.9089,-151.2996;Float;False;743.4688;257;Spheres that are 1 in the center and go down as they go out;4;5;7;6;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;37;603.2379,-495.3495;Float;False;Property;_HueVarianceOffsetCycleSpeed_;Hue <Variance, Offset, CycleSpeed,_>;4;0;Create;0,0,0;0.2,0,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;6;-137.909,-101.2996;Float;False;Constant;_Vector0;Vector 0;1;0;Create;0,1,-1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;2;-465.7002,-160;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;305.2503,-575.5062;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;5;54.04544,-98.0649;Float;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;977.3327,-570.1178;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;40;972.8631,-421.7009;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;7;234.0455,-97.0649;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;1150.786,-468.4382;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;368.5599,-97.1783;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;17;1329.777,-471.343;Float;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;76;1681.03,-22.55176;Float;False;Property;_Emission;Emission;5;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;1675.951,-127.9231;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;1828.03,-37.55176;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1980.443,-126.122;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/PokaDots;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;65;0;26;1
WireConnection;65;1;26;2
WireConnection;65;2;26;3
WireConnection;27;0;63;0
WireConnection;27;1;65;0
WireConnection;32;0;27;0
WireConnection;32;1;34;0
WireConnection;30;0;31;0
WireConnection;30;1;1;0
WireConnection;33;0;30;0
WireConnection;33;1;32;0
WireConnection;3;0;33;0
WireConnection;3;1;4;0
WireConnection;41;0;3;0
WireConnection;15;0;41;0
WireConnection;16;0;15;0
WireConnection;21;0;25;0
WireConnection;23;0;21;0
WireConnection;23;1;16;0
WireConnection;2;0;41;0
WireConnection;20;0;23;0
WireConnection;5;0;2;0
WireConnection;5;1;6;1
WireConnection;5;2;6;2
WireConnection;5;3;6;3
WireConnection;5;4;6;4
WireConnection;73;0;20;0
WireConnection;73;1;37;1
WireConnection;40;0;37;3
WireConnection;7;0;5;0
WireConnection;72;0;73;0
WireConnection;72;1;37;2
WireConnection;72;2;40;0
WireConnection;19;0;7;0
WireConnection;17;1;72;0
WireConnection;13;0;17;6
WireConnection;13;1;19;0
WireConnection;77;0;13;0
WireConnection;77;1;76;0
WireConnection;0;0;13;0
WireConnection;0;2;77;0
ASEEND*/
//CHKSM=A834AFF4C8571ADA5BC93B2DB61A7A2CB6D6F65A
