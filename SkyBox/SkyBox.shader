// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/SkyBox/SkyBox"
{
	Properties
	{
		_Scale("Scale", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		
    	#include "../ShaderUtils/Noise2.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 

		uniform float _Scale;
		struct Input
		{
			float3 viewDir;
			float3 worldPos;
		};

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float sum = 0;
			float sum2 = 0;
			float4 pos = float4(i.viewDir, _Time.x);
			float s = 1;

			for(int p = 0 ; p < 5; p++) {
				sum += snoise(pos ) * s;
				sum2 += snoise(pos + float4(0,0,0,.1) ) * s;
				pos *= _Scale;
				s /= _Scale;
			}



			o.Alpha = 1;
			o.Emission = float4(sum.x/2, sum2.xx/2,1);
/*
			float3 temp_output_7_0 = ( i.viewDir * _Scale );
			float simplePerlin3D8 = snoise( temp_output_7_0 );
			float3 temp_output_12_0 = ( temp_output_7_0 * _Scale );
			float simplePerlin3D13 = snoise( temp_output_12_0 );
			float simplePerlin3D18 = snoise( ( temp_output_12_0 * _Scale ) );
			float simplePerlin3D26 = snoise( _WorldSpaceCameraPos );
			float3 temp_cast_0 = (( ( simplePerlin3D8 + ( ( simplePerlin3D13 + ( ( simplePerlin3D18 + simplePerlin3D26 ) / _Scale ) ) / _Scale ) ) / _Scale )).xxx;
			o.Emission = temp_cast_0;
			o.Alpha = 1;
			*/
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1127;92;793;926;1661.571;637.903;1.986253;True;False
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1;-1353.241,-87.05428;Float;False;World;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-1316.943,178.5169;Float;False;Property;_Scale;Scale;0;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1011.631,-74.55162;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1012.235,133.7751;Float;False;2;2;0;FLOAT3;0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;24;-1434.35,520.3656;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1022.957,287.7146;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-732.3192,497.3969;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-749.0316,296.0196;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-512.1538,327.6144;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-334.7515,297.1314;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;13;-738.3103,142.0801;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-493.1795,139.1788;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;8;-717.0541,-77.72013;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-324.0305,143.1919;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-488.59,-76.52149;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;11;-315.8524,-81.19759;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;126.2076,-126.2076;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Custom/SkyBox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;False;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;1;0
WireConnection;7;1;6;0
WireConnection;12;0;7;0
WireConnection;12;1;6;0
WireConnection;17;0;12;0
WireConnection;17;1;6;0
WireConnection;26;0;24;0
WireConnection;18;0;17;0
WireConnection;23;0;18;0
WireConnection;23;1;26;0
WireConnection;20;0;23;0
WireConnection;20;1;6;0
WireConnection;13;0;12;0
WireConnection;22;0;13;0
WireConnection;22;1;20;0
WireConnection;8;0;7;0
WireConnection;14;0;22;0
WireConnection;14;1;6;0
WireConnection;21;0;8;0
WireConnection;21;1;14;0
WireConnection;11;0;21;0
WireConnection;11;1;6;0
WireConnection;0;2;11;0
ASEEND*/
//CHKSM=3585082811BFEF1923BDF2F48703EA74B9A8B846
