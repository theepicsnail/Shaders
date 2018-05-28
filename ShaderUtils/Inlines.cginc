/*
	Return a 'stable' camera position.
	In VR this is between your two eyes. In desktop it's your camera.
*/
inline float4 GetCameraPosition() {
	return float4(
		#if UNITY_SINGLE_PASS_STEREO
			(unity_StereoWorldSpaceCameraPos[0] +
			unity_StereoWorldSpaceCameraPos[1]) / 2
		#else
			_WorldSpaceCameraPos
		#endif
	,1);
}

inline float Remap(float s, float l0, float h0, float l1, float h1) {
	return (s-l0)/(h0-l0) * (h1-l1) + l1;
}