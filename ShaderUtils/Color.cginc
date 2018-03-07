#ifndef SNAIL_COLOR
#define SNAIL_COLOR

float3 HSVtoRGB( float3 c )
{
	float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
	float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
	return c.z * lerp( K.xxx, clamp( p - K.xxx, 0.0, 1.0 ), c.y );
}

float3 RGBtoHSV(float3 RGB)
{
	float3 HSV = 0;
	float M = min(RGB.r, min(RGB.g, RGB.b));
	HSV.z = max(RGB.r, max(RGB.g, RGB.b));
	float C = HSV.z - M;
	if (C != 0)
	{
		HSV.y = C / HSV.z;
		float3 D = (((HSV.z - RGB) / 6) + (C / 2)) / C;
		if (RGB.r == HSV.z)
			HSV.x = D.b - D.g;
		else if (RGB.g == HSV.z)
			HSV.x = (1.0/3.0) + D.r - D.b;
		else if (RGB.b == HSV.z)
			HSV.x = (2.0/3.0) + D.g - D.r;
		if ( HSV.x < 0.0 ) { HSV.x += 1.0; }
		if ( HSV.x > 1.0 ) { HSV.x -= 1.0; }
	}
	return HSV;
}

#endif