// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/SnailHouse/SnailsHouse"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "../ShaderUtils/Noise.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;


		float MyCustomExpression16( float In0 , float2 uv )
		{
			float o = 0;
			float3	 input = float3(In0, uv);
			o =       snoise(input); 
			input *= 2;
			o = o/2 + snoise(input); 
			input *= 2;
			o = o/2 + snoise(input);
			return o;
		}

		float smoothFloor(float v) {
			return floor(v)+smoothstep(0,1,smoothstep(floor(v), ceil(v), v));
		}
		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float In016 = 0.0;
			float2 uv_TexCoord2 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 uv16 = uv_TexCoord2;
			float r = MyCustomExpression16( In016 , uv16 )*1.1;
			float g = MyCustomExpression16( In016  , uv16 )*0;
			float b = MyCustomExpression16( In016, uv16 )*1.1;
			float4 lerpResult13 = float4(
				lerp( _Color0.r , _Color1.r , floor(smoothFloor(r*3)*3)/9),
				lerp( _Color0.g , _Color1.g , floor(smoothFloor(r*3)*3)/9),
				lerp( _Color0.b , _Color1.b , floor(smoothFloor(r*3)*3)/9),
				1);
			o.Albedo = lerpResult13.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
608;92;1312;624;1670.81;849.6799;1.558375;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-775.1028,-166.3094;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-734.2264,-268.4063;Float;False;Constant;_Float0;Float 0;2;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;16;-507.3285,-254.9954;Float;False;float o = 0@$float3	 input = float3(In0, uv)@$o =       snoise(input)@ $input *= 2@$o = o/2 + snoise(input)@ $input *= 2@$o = o/2 + snoise(input)@$return o@;1;False;2;True;In0;FLOAT;0.0;In;True;uv;FLOAT2;0.0;In;My Custom Expression;2;0;FLOAT;0.0;False;1;FLOAT2;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-510.0766,-427.2476;Float;False;Property;_Color1;Color 1;1;0;Create;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-490.3684,-615.0691;Float;False;Property;_Color0;Color 0;0;0;Create;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;13;-128.85,-473.4749;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;275.1738,-455.7592;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/SnailsHouse;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;1;../ShaderUtils/Noise.cginc;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;19;0
WireConnection;16;1;2;0
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;13;2;16;0
WireConnection;0;0;13;0
ASEEND*/
//CHKSM=897A977391817B1ADCBE0472682555C623370E1A
