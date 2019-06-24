Shader "snail/SnailHouse/Skin" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
	_RimPower ("Power", Float) = 0
	_RimColor ("Color", Color) = (1,1,1,1)

  }
  SubShader {
    Tags { "RenderType" = "Opaque" }
    CGPROGRAM

	#pragma surface surf WrapLambert

half4 LightingWrapLambert (SurfaceOutput s, half3 dir, half atten) {
    dir = normalize(dir);
    half NdotL = dot (s.Normal, dir);
    half diff = NdotL * 0.5 + 0.5;
    half4 c;
    c.rgb = s.Albedo * _LightColor0.rgb * (diff * floor(atten*2)/1 * 2);
    c.a = s.Alpha;
    return c;
}

struct Input {
    float2 uv_MainTex;
};
sampler2D _MainTex;

void surf (Input IN, inout SurfaceOutput o) {
    o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
}


    ENDCG
  } 
  Fallback "Diffuse"
}
