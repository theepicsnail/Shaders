#ifndef SNAIL_RANDOM
#define SNAIL_RANDOM
// Fast and "discontinuous" random noise.
float random (in float4 st) {
	return frac(
		cos(
			dot(
				st, 
				float4(
					12.9898,
					78.233,
					123.691,
					43.7039
				)
			)
		)
		* 43758.5453123
	);
}

float random (in float3 st) {
	return frac(
		cos(
			dot(
				st, 
				float3(
					12.9898,
					78.233,
					123.691
				)
			)
		)
		* 43758.5453123
	);
}

float random (in float2 st) {
	return frac(
		cos(
			dot(
				st, 
				float2(
					12.9898,
					78.233
				)
			)
		)
		* 43758.5453123
	);
}

float random (in float st) {
	return frac(cos(st.x * 12.9898) * 43758.5453123);
}

#endif