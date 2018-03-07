#ifndef SNAIL_SYNC
#define SNAIL_SYNC

#include "Color.cginc"

float3 SyncColor(float f) {
	return HSVtoRGB(float3(f*1.618, 1, 1));
}

float SyncTime(float phase, float step) {
	float t = (_Time.y + phase) * .1;
	return t - frac(t) * step;
}
#endif
