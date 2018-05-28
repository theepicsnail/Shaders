/*
	Replaces local rotation/scale with hard-coded values.
	This is similar to using a rigid body or particle system to keep a mesh from rotating except
	that it doesn't suffer the frame/physics engine delay.
	
*/
Shader "Snail/RotationLock"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Scale("Scale", Float) = 1.0
		_Rotation("Rotation (x,y,z,unused)", Vector) = (0,0,0,0)
	}

	SubShader
	{
		Pass
		{
			Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
			Cull Back
			CGPROGRAM
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma target 3.0
		
			#pragma vertex VS_Main
			#pragma fragment FS_Main

			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform float _Scale;
			uniform float4 _Rotation;

			struct v2f {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			inline float2 rotate(float2 p, float t) {
				float s = sin(t);
				float c = cos(t);
				return float2(
					p.x * c - p.y * s,
					p.x * s + p.y * c
				);
			}
			v2f VS_Main( appdata_img v )
			{
				v2f o;
				// Scale
				o.pos = float4(v.vertex.xyz * _Scale,1 );
				// Rotate
				o.pos.yz = rotate(o.pos.yz, _Rotation.x);
				o.pos.xz = rotate(o.pos.xz, _Rotation.y);
				o.pos.xy = rotate(o.pos.xy, _Rotation.z);
				//Translate
				o.pos.xyz += mul(unity_ObjectToWorld,float4(0,0,0,1)).xyz;
				o.pos = mul(UNITY_MATRIX_VP, o.pos);

				o.uv = v.texcoord;//ComputeScreenPos(o.pos);
				return o;
			}    
 
			half4 FS_Main (v2f i) : COLOR
			{
				return tex2D(_MainTex,TRANSFORM_TEX(i.uv, _MainTex));//float4(i.uv.xy/i.uv.w,1,1);

			}
			ENDCG
		}
	}
}