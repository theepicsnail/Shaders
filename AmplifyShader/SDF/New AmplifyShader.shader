// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New AmplifyShader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Float2("Float 2", Float) = 0
		_Steps("Steps", Int) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float3 viewDir;
		};

		uniform int _Steps;
		uniform float _Float2;
		uniform float _Cutoff = 0.5;


		float3 sdf_extern4_g225(  )
		{
			// Inject 'SDF' function start
			return float3(0,0,0);
			}
			void SDF(
			float3 position,
			out float distance
			);
			void SDF_noop(){
			// Inject 'SDF' function end
		}


		float3 renderer_extern2_g258( float3 _ )
		{
			// Inject 'render' function start
			return _;
			}
			void render(
				Input i,
				inout SurfaceOutput o,
				float3 UNUSED
			);
			void render_noop(){
			// Inject 'render' function end
		}


		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float localRenderer7_g2587_g258 = ( 0.0 );
			float localInline4_g2584_g258 = ( 0 );
			float localInline1_g2251_g225 = ( 0.0 );
			float3 localsdf_extern4_g2254_g225 = sdf_extern4_g225();
			float3 POSITION1_g225 = localsdf_extern4_g2254_g225;
			//<SDFStart>
			render(i, o, POSITION1_g225/*Unused*/);
			}
			void SDF(
			float3 POSITION1_g225,
			out float distance
			) {
			//</SDFStart>
			float3 UNUSED4_g258 = POSITION1_g225;
			float3 temp_output_251_0 = ( frac( POSITION1_g225 ) + -0.5 );
			float3 temp_output_1_0_g226 = temp_output_251_0;
			float temp_output_2_0_g226 = 0.25;
			float SDF_RESULT4_g258 = ( ( length( temp_output_1_0_g226 ) - temp_output_2_0_g226 ) + ( sin( ( temp_output_251_0 * 20.0 ) ).x * sin( ( temp_output_251_0 * 20.0 ) ).y * sin( ( temp_output_251_0 * 20.0 ) ).z * 0.1 ) );
			//<SDFEnd>
			distance = SDF_RESULT4_g258;
			}
			void render(
				Input i ,
				inout SurfaceOutput o,
				float3 UNUSED4_g258 /*unused*/
			){
			//</SDFEnd>
			float Unused7_g258 = UNUSED4_g258.x;
			float3 _2_g258 = _WorldSpaceCameraPos;
			float3 localrenderer_extern2_g2582_g258 = renderer_extern2_g258( _2_g258 );
			float3 pos7_g258 = localrenderer_extern2_g2582_g258;
			float3 dir7_g258 = -i.viewDir;
			int steps7_g258 = _Steps;
			float distance7_g258 = 0.0;
			float hit7_g258 = 0.0;
			float epsilon7_g258 = _Float2;
			float est = 0;
			while(steps7_g258-->0){
			  SDF(pos7_g258, est);
			  if(est < epsilon7_g258) {
			    hit7_g258 = 1;
			    break;
			  }
			  distance7_g258 += est;
			  pos7_g258 += est * dir7_g258;
			}
			float3 temp_output_270_0 = ( frac( pos7_g258 ) / distance7_g258 );
			o.Emission = temp_output_270_0;
			o.Alpha = 1;
			clip( hit7_g258 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
0;596;1920;422;2018.415;143.407;1.6;True;False
Node;AmplifyShaderEditor.CommentaryNode;278;-961.8303,17.48206;Float;False;377.5103;268.1686;Tiling;3;277;252;251;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;239;-1106.189,-156.8713;Float;False;SDFStart;-1;;225;f831723f0aa4bc04cbdda510aeab3a66;0;2;FLOAT3;5;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-911.8303,170.6507;Float;False;Constant;_Float0;Float 0;1;0;Create;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;277;-879.0039,75.29778;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;251;-738.3199,67.48206;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-664.815,350.9931;Float;False;Constant;_Float3;Float 3;3;0;Create;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;-447.2151,238.9931;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;302;-298.4152,238.993;Float;False;1;0;FLOAT3;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-627.3699,-75.25494;Float;False;Constant;_Float1;Float 1;0;0;Create;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;303;-180.0151,240.593;Float;False;FLOAT3;1;0;FLOAT3;0.0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;305;-106.415,394.1931;Float;False;Constant;_Float6;Float 6;3;0;Create;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;25;-448.1436,34.07249;Float;False;SphereSDF;-1;;226;b574a8fcf3c1d004eb58d221e96a13e4;2;2;FLOAT;0.0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;59.98516,245.393;Float;False;4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;283;-303.3439,-294.1736;Float;False;Property;_Float2;Float 2;1;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;298;-212.0141,64.59309;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;285;-297.6439,-210.5738;Float;False;Property;_Steps;Steps;2;0;Create;0;0;0;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;286;-122.9281,-227.5116;Float;False;SDFEnd;-1;;258;513471f80b0a3e84892f0d5c335354ad;6;17;FLOAT;0.0;False;16;INT;0;False;15;FLOAT3;0,0,0;False;14;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;INT;19;FLOAT;12;FLOAT3;0;FLOAT;13
Node;AmplifyShaderEditor.FractNode;276;254.5509,-166.8113;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCCompareNotEqual;287;232.7851,-383.4073;Float;False;4;0;INT;0;False;1;FLOAT;0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-188.0148,-381.8072;Float;False;Constant;_Float5;Float 5;3;0;Create;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;294;45.58618,-497.007;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-120.8135,-541.8067;Float;False;2;2;0;FLOAT;0.0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;289;-5.614868,-311.4072;Float;False;Constant;_Float4;Float 4;3;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;297;472.7866,-498.6068;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;292;-444.0142,-559.4075;Float;False;1;0;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;469.5853,-346.6073;Float;False;2;2;0;FLOAT;0,0,0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FractNode;296;-239.2135,-554.6067;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;270;282.9667,-86.26746;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;771.629,-446.6549;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;New AmplifyShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;0;False;0;0;Custom;0.5;True;False;0;True;TransparentCutout;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;277;0;239;0
WireConnection;251;0;277;0
WireConnection;251;1;252;0
WireConnection;299;0;251;0
WireConnection;299;1;300;0
WireConnection;302;0;299;0
WireConnection;303;0;302;0
WireConnection;25;2;24;0
WireConnection;25;1;251;0
WireConnection;304;0;303;0
WireConnection;304;1;303;1
WireConnection;304;2;303;2
WireConnection;304;3;305;0
WireConnection;298;0;25;0
WireConnection;298;1;304;0
WireConnection;286;17;283;0
WireConnection;286;16;285;0
WireConnection;286;5;239;5
WireConnection;286;3;298;0
WireConnection;276;0;286;0
WireConnection;287;0;286;19
WireConnection;287;1;294;0
WireConnection;287;2;291;0
WireConnection;287;3;289;0
WireConnection;294;0;295;0
WireConnection;295;0;296;0
WireConnection;295;1;285;0
WireConnection;297;0;287;0
WireConnection;290;0;287;0
WireConnection;290;1;270;0
WireConnection;296;0;292;0
WireConnection;270;0;276;0
WireConnection;270;1;286;13
WireConnection;0;2;270;0
WireConnection;0;10;286;12
ASEEND*/
//CHKSM=3C420EFA9454B513A25EB8BA2B1B4E45B0ED768B