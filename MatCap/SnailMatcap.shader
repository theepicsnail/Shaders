// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Snail/Matcap"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_MatCap("MatCap", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,0)
		_NormalMap("NormalMap", 2D) = "bump" {}
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
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float2 data28;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _MatCap;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_NormalMap = v.texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float4 tex2DNode50 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			float3x3 tangentToWorld = CreateTangentToWorldPerVertex( ase_worldNormal, ase_worldTangent, v.tangent.w );
			float3 tangentNormal51 = tex2DNode50.rgb;
			float3 modWorldNormal51 = (tangentToWorld[0] * tangentNormal51.x + tangentToWorld[1] * tangentNormal51.y + tangentToWorld[2] * tangentNormal51.z);
			float3 normalizeResult15 = normalize( ( ( (unity_WorldToObject[0]).xyz * modWorldNormal51.x ) + ( (unity_WorldToObject[1]).xyz * modWorldNormal51.y ) + ( (unity_WorldToObject[2]).xyz * modWorldNormal51.z ) ) );
			o.data28 = ((mul( UNITY_MATRIX_V, float4( normalizeResult15 , 0.0 ) ).xyz).xy*0.5 + 0.5);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float4 tex2DNode50 = tex2D( _NormalMap, uv_NormalMap );
			o.Normal = tex2DNode50.rgb;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = ( _Color * tex2D( _MainTex, uv_MainTex ) * tex2D( _MatCap, i.data28 ) * 2.0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
1308;92;612;926;-1309.939;413.2784;1.6;True;False
Node;AmplifyShaderEditor.WorldToObjectMatrix;31;-902.5125,-144.104;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.VectorFromMatrixNode;34;-528.9225,-136.239;Float;False;Row;1;1;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-629.6424,600.3001;Float;True;Property;_NormalMap;NormalMap;5;0;Create;None;None;True;0;False;bump;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VectorFromMatrixNode;32;-528.9228,-301.4045;Float;False;Row;0;1;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VectorFromMatrixNode;36;-519.0914,34.82594;Float;False;Row;2;1;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;51;-364.6493,283.3826;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;35;-342.1281,-110.677;Float;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;37;-334.2629,62.35414;Float;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;33;-344.0946,-273.8764;Float;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-88.78563,-113.6664;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-89.41936,-221.6304;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-95.35088,3.495211;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;100.1951,-132.7785;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0,0;False;2;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;15;227.3677,-133.2094;Float;False;1;0;FLOAT3;0.0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewMatrixNode;16;249.4689,-199.8477;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;395.3676,-162.2094;Float;False;2;2;0;FLOAT4x4;0.0;False;1;FLOAT3;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;41;528.6486,-86.34483;Float;False;Constant;_Float0;Float 0;3;0;Create;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;20;526.3679,-167.2094;Float;False;FLOAT2;0;1;2;2;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;21;688.698,-155.8768;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexToFragmentNode;28;907.9124,-157.4706;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;1260.14,0.505075;Float;False;Constant;_Float1;Float 1;3;0;Create;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;1113.946,-189.3544;Float;True;Property;_MatCap;MatCap;1;0;Create;None;634e449c49ad851428de8f7ddb4a3bd6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;1110.946,-397.3544;Float;True;Property;_MainTex;MainTex;0;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;25;1194.946,-568.3544;Float;False;Property;_Color;Color;2;0;Create;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;1484.758,281.8472;Float;False;Property;_Gloss;Gloss;3;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;1482.158,202.5473;Float;False;Property;_Specular;Specular;4;0;Create;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;1468.946,-183.3544;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;30;-345.1603,147.9142;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1861.799,-33.27832;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Snail/Matcap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;False;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;31;0
WireConnection;32;0;31;0
WireConnection;36;0;31;0
WireConnection;51;0;50;0
WireConnection;35;0;34;0
WireConnection;37;0;36;0
WireConnection;33;0;32;0
WireConnection;10;0;35;0
WireConnection;10;1;51;2
WireConnection;9;0;33;0
WireConnection;9;1;51;1
WireConnection;11;0;37;0
WireConnection;11;1;51;3
WireConnection;13;0;9;0
WireConnection;13;1;10;0
WireConnection;13;2;11;0
WireConnection;15;0;13;0
WireConnection;17;0;16;0
WireConnection;17;1;15;0
WireConnection;20;0;17;0
WireConnection;21;0;20;0
WireConnection;21;1;41;0
WireConnection;21;2;41;0
WireConnection;28;0;21;0
WireConnection;23;1;28;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;26;2;23;0
WireConnection;26;3;27;0
WireConnection;0;0;26;0
WireConnection;0;1;50;0
ASEEND*/
//CHKSM=F09425460267A26FB53A65110F3E2921887F2B50