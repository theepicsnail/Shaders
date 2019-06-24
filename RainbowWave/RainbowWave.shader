Shader "snail/RainbowWave/RainbowWave"
{
	Properties
	{
		_Percent( "Percent", Range(0,1) ) = 0
	}
	SubShader
	{
        Tags {
            "Queue"="Transparent-1"
            "RenderType"="Transparent"
        }
		Cull Front ZWrite Off ZTest Always
		LOD 100
		
		GrabPass
		{
			"_MainTex"
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "../ShaderUtils/random.cginc"
			#include "../ShaderUtils/noise.cginc"
			#include "../ShaderUtils/color.cginc"

			struct VertIn
			{
				float4 vertex : POSITION;
				float3 uv : TEXCOORD0;
			};

			struct VertOut
			{
				float4 vertex : SV_POSITION;
				float4 uv : TEXCOORD0;
				float3 posWorld : TEXCOORD1;
				float3 ray : TEXCOORD2;
			};


			VertOut vert(VertIn v)
			{
				VertOut o;
				half index = v.vertex.z;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeGrabScreenPos(o.vertex);
				o.uv = screenPos;
				o.posWorld = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
				o.ray = mul(UNITY_MATRIX_MV, v.vertex).xyz * float3(-1,-1,1);
				o.ray = lerp(o.ray, v.uv, v.uv.z != 0);
				return o;
			}

			sampler2D _CameraDepthNormalsTexture;
			sampler2D_float _CameraDepthTexture;
			uniform sampler2D _MainTex;
			
			half4 frag (VertOut i) : SV_Target
			{
				float4 screenColor2 = tex2Dproj( _MainTex, UNITY_PROJ_COORD( i.uv ) );

				float rawDepth = DecodeFloatRG(tex2Dproj(_CameraDepthTexture, i.uv));
				float linearDepth = Linear01Depth(rawDepth);

				i.ray = i.ray * (_ProjectionParams.z / i.ray.z);
				float4 vpos = float4(i.ray * linearDepth, 1);
				float3 wpos = mul(unity_CameraToWorld, vpos).xyz;

				wpos += snoise(wpos)*.5;
				

				float4 objectPos = mul(unity_ObjectToWorld,float4(0,0,0,1));
				
				float r = length( wpos.xyz - objectPos);
				float c = 0;
				float t = (sqrt(r) - _Time.y)*10;
				if(r>1)
				c = 1-saturate(frac(t/10)*5);

				float3 waveColor = HSVtoRGB(
				float3(
					random(floor(t) * float3(1,1,1)), 1, 1
				));
				
				c = saturate(c-r/10);

				return half4(
				lerp(screenColor2.rgb, 
					waveColor,
					c)
				,1);
			}
			ENDCG
		}
	}
}
