// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Snail/Shaders/DigitalDisplay"
{
	Properties
	{
		_DigitTex("DigitTex", 2D) = "white" {}
		_Digits("Digits", Float) = 0
		_Precision("Precision", Float) = 0
		_Value("Value", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _DigitTex;
		uniform float _Digits;
		uniform fixed _Precision;
		uniform float _Value;


		float2 DigitCalculator8( float2 UV , float Places , float Precision , float Value )
		{
			// Cleanup/fix Precision.
			Precision = floor(Precision);
			Precision = (Precision+1)*saturate(Precision)-1;
			float digitNum = floor(UV.x*Places); // 0 1 2 ... Digits-1
			float decimalPos = Places-Precision-1;
			float x = digitNum - decimalPos;
			float e = 1-saturate(x)+x;
			//Value += .000001;
			while(e > 0) {
			  e -= 1;
			  Value *= 10;
			}
			while(e < 0) {
			  e += 1;
			  Value /= 10;
			}
			float charNum = floor(fmod(Value,10));
			charNum = lerp(10,charNum, abs(sign(x)));
			UV.x = (frac(UV.x*Places)+charNum)/11;
			return UV;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord9 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 UV8 = uv_TexCoord9;
			float Places8 = _Digits;
			float Precision8 = _Precision;
			float Value8 = _Value;
			float2 localDigitCalculator88 = DigitCalculator8( UV8 , Places8 , Precision8 , Value8 );
			float4 tex2DNode1 = tex2D( _DigitTex, localDigitCalculator88 );
			o.Albedo = tex2DNode1.rgb;
			o.Emission = tex2DNode1.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
862;92;1058;926;2699.711;793.9735;2.214457;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-1474.666,113.9775;Float;False;Property;_Value;Value;3;0;Create;0;9.876543E+08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1235.917,-184.7045;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1151.995,-59.59824;Float;False;Property;_Digits;Digits;1;0;Create;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1150.695,17.10163;Fixed;False;Property;_Precision;Precision;2;0;Create;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;8;-910.9171,-65.70447;Float;False;// Cleanup/fix Precision.$Precision = floor(Precision)@$Precision = (Precision+1)*saturate(Precision)-1@$$$float digitNum = floor(UV.x*Places)@ // 0 1 2 ... Digits-1$float decimalPos = Places-Precision-1@$$float x = digitNum - decimalPos@$float e = 1-saturate(x)+x@$//Value += .000001@$while(e > 0) {$  e -= 1@$  Value *= 10@$}$while(e < 0) {$  e += 1@$  Value /= 10@$}$$float charNum = floor(fmod(Value,10))@$charNum = lerp(10,charNum, abs(sign(x)))@$UV.x = (frac(UV.x*Places)+charNum)/11@$return UV@$;2;False;4;True;UV;FLOAT2;0,0;In;True;Places;FLOAT;0.0;In;True;Precision;FLOAT;0.0;In;True;Value;FLOAT;0.0;In;DigitCalculator;4;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;15;-1734.207,433.3254;Float;False;Property;_SampleMultiply;SampleMultiply;7;0;Create;0,0,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LengthOpNode;17;-1393.558,275.1085;Float;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1880.979,243.3628;Float;True;Property;_ColorSample;ColorSample;5;0;Create;None;3ad08855580f0f449bffd3cc127b888d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-2080.979,266.3628;Float;False;Property;_SamplePosition;SamplePosition;6;0;Create;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;1;-709.032,-89.64468;Float;True;Property;_DigitTex;DigitTex;0;0;Create;None;3fbe67cfb65fe994b8d95b4b8b7a59ef;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1522.715,291.2534;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT3;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;11;-1217.81,243.1458;Float;True;Property;_InputValue;InputValue;4;0;Create;1;False;False;True;;Toggle;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-343.0215,-115.716;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Snail/Shaders/DigitalDisplay;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;9;0
WireConnection;8;1;2;0
WireConnection;8;2;3;0
WireConnection;8;3;4;0
WireConnection;17;0;16;0
WireConnection;12;1;14;0
WireConnection;1;1;8;0
WireConnection;16;0;12;0
WireConnection;16;1;15;0
WireConnection;11;0;4;0
WireConnection;11;1;17;0
WireConnection;0;0;1;0
WireConnection;0;2;1;0
ASEEND*/
//CHKSM=9201A8BEBEFC07C7D35B4F2F6C8DA501F03CA6CD