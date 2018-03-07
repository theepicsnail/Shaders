/*
struct appdata_full {
	float4 vertex : POSITION;
	float4 tangent : TANGENT;
	float3 normal : NORMAL;
	float4 texcoord : TEXCOORD0;
	float4 texcoord1 : TEXCOORD1;
	fixed4 color : COLOR;
}
*/

Shader "Snail/LavaLamp"
{
	Properties
	{
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		
		#include "../ShaderUtils/noise.cginc"

		#pragma target 3.0
		#pragma surface surf Standard keepalpha fullforwardshadows nolightmap addshadow 

		struct Input
		{
			float3 viewDir;
			float3 worldPos;
			float4 screenPos;
			float2 uv_texcoord;
		};


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			#if UNITY_SINGLE_PASS_STEREO
			o.x = frac(o.x*2);
			#endif
			return o;
		}

		float4 trace(float3 ro, float3 rd, float phase) {
			int maxSteps =10 ;
			float threshold = .5;
			
			// Make contact with blob.
			int step = 0;
			float distance = 0.01;
			for(step=0 ; step < maxSteps; step++) {
				if(snoise_grad(rd * distance + ro).w > threshold)
					break;
				distance += distance;
			}
			if(step == maxSteps)
				return float4(0,0,0,0);
			
			// Walk back from blob to find a spot in front of it.
			float insideDistance = distance;
			float outsideDistance = distance;
			for(step=0 ; step < maxSteps; step++) {
				if(snoise_grad(rd * outsideDistance + ro).w < threshold)
					break;
				outsideDistance -= 0.2;
			}

			float guess = outsideDistance;
			float4 result;
			if(step < maxSteps) {
				// Blob surface is somewhere between
				// distanceIntoBlob - distance (outside)
				// and
				// distanceIntoBlob - distance/2 (inside)

				for(step=0 ; step < maxSteps; step++) {
					guess = (insideDistance + outsideDistance)/2.0;
					result = snoise_grad(rd * guess + ro);
					if(result.w > threshold)
						insideDistance = guess;
					else
						outsideDistance = guess;
				}
			}

			float percent = guess/(2*maxSteps);

			float3 color = lerp(float3(1,0,0),float3(1,1,0),saturate(sin(insideDistance*6)*.5+.5));
			color *= lerp(1, .2, guess/(maxSteps*2));
			color *= length(result.xyz);
			return float4(color,1);
		}
		
		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float2 uv_TexCoord5 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float4 c = trace(
				i.worldPos - float3(0,_Time.x,0),
				-i.viewDir, 
				i.uv_texcoord.y);
					
			o.Emission.rgb =  c.rgb;
			o.Alpha = c.a;
		}
		
		ENDCG
	}
}