// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Water/OtherStuff/Damping"
{
	Properties
	{
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
			fixed filler;
		};


		inline float MyCustomExpression46( float In0 )
		{
			return frac(_Time.y) < frac(_Time.y - unity_DeltaTime.x);
		}


		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float In046 = 0.0;
			float localMyCustomExpression4646 = MyCustomExpression46( In046 );
			float3 temp_cast_0 = (localMyCustomExpression4646).xxx;
			o.Emission = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
900;465;1020;553;-830.6588;-234.9666;1.3;True;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;1082.698,391.5983;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;45;1227.206,386.8786;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;46;1561.259,466.3666;Float;False;frac(_Time.y) < frac(_Time.y - unity_DeltaTime.x);1;False;1;True;In0;FLOAT;0.0;In;My Custom Expression;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;1196.504,603.5334;Float;True;Property;_Cur;Cur;1;0;Create;None;e9e32da7ec2276f4dafaa73da00e0ada;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;36;761.9322,370.1009;Float;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;788.2688,302.1818;Float;False;Property;_Damping;Damping;2;0;Create;0;0.37;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;43;1868.187,365.812;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Custom/Waves;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;False;0;True;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;36;0
WireConnection;40;1;41;0
WireConnection;45;0;40;0
WireConnection;36;0;1;0
WireConnection;43;2;46;0
ASEEND*/
//CHKSM=E7D867BD722DB42E7681BD5EB5570DA0A7A0D1AD
