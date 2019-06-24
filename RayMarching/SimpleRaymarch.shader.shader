Shader "snail/RayMarching/SimpleRaymarch" {
	Properties {
		_Steps ("Steps", Float) = 10
		_MaxDistance ("Distance", Float) = 10
		_Threshold ("Collision distance", Float) = 0.01 


		
		Iterations("Iterations", Float) = 10
		Bailout("Bailout", Float) = 2
		Power("Power", Float)= 2

	}
	SubShader {
		Blend SrcAlpha OneMinusSrcAlpha
		Cull back
		ZWrite On
		ZTest Off

		CGINCLUDE
			uniform float _Steps;
			uniform float _MaxDistance;
			uniform float _Threshold;
			
			uniform float Iterations;
			uniform float Bailout;
			uniform float Power;
		ENDCG

		CGINCLUDE
			float3 ballFold(float r, float3 v) {
				float3 d = normalize(v);
				float m = length(v);
				if(m<r)
					return d / (r*r);
				else if(m < 1)
					return d / m;
				return d;
			}

			inline float boxFold1(float f) {
				return lerp(f, sign(f)*2-f, abs(f)>1);
			}

			float3 boxFold3(float3 p) {
				return float3(
					boxFold1(p.x),
					boxFold1(p.y),
					boxFold1(p.z)
				);
			}

			float3x3 rotAxis(float3 axis, float a) {
				float s=sin(a);
				float c=cos(a);
				float oc=1.0-c;
				float3 as=axis*s;
				float3x3 p=float3x3(axis.x*axis,axis.y*axis,axis.z*axis);
				float3x3 q=float3x3(c,-as.z,as.y,as.z,c,-as.x,-as.y,as.x,c);
				return p*oc+q;
			}
			
			float sdBox( float3 p, float3 b )
			{
				float3 d = abs(p) - b;
				return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
			}
			float udBox( float3 p, float3 b )
			{
				return length(max(abs(p)-b,0.0));
			}
			float sdCylinder( float3 p, float3 c )
			{
			  return length(p.xz-c.xy)-c.z;
			}
			float sdCappedCylinder( float3 p, float2 h )
			{
				float2 d = abs(float2(length(p.xz),p.y)) - h;
				return min(max(d.x,d.y),0.0) + length(max(d,0.0));
			}

			float smin( float a, float b, float k )
			{
				float res = exp( -k*a ) + exp( -k*b );
				return -log( res )/k;
			}
			
			float sdTorus( float3 p, float2 t )
			{
			  float2 q = float2(length(p.xz)-t.x, p.y);
			  return length(q)-t.y;
			}

			
				
			float sdSpiral(float3 p, float3 t) {
				// t = float3(
				//			rotation/phase [0,1]
				//			direction [-1, 1]	-1 =clockwise, 0 = concentric circles, 1 = counter clockwise
				//			thickness);
				float arm_distance = frac(atan2(p.z, p.x)*t.y/6.28318 - t.x - frac(length(p.xz)));
				return length(float2(min(arm_distance, 1-arm_distance), p.y)) - t.z;

				/*
					float phase = (atan2(p.z, p.x) * t.y + pi)/tau - t.x; // 0-1
					float radius = frac(length(p.xz));
					float c = frac(phase-radius);
					float spiralLineDistance = min(c, 1-c);
					float spiralTubeDistance = length(float2(spiralLineDistance, p.y));
					return spiralTubeDistance - t.z;
				*/
			}


			
float3 mod289(float3 x)
{
    return x - floor(x / 289.0) * 289.0;
}

float4 mod289(float4 x)
{
    return x - floor(x / 289.0) * 289.0;
}

float4 permute(float4 x)
{
    return mod289((x * 34.0 + 1.0) * x);
}

float4 taylorInvSqrt(float4 r)
{
    return 1.79284291400159 - r * 0.85373472095314;
}

float snoise(float3 v)
{
    const float2 C = float2(1.0 / 6.0, 1.0 / 3.0);

    // First corner
    float3 i  = floor(v + dot(v, C.yyy));
    float3 x0 = v   - i + dot(i, C.xxx);

    // Other corners
    float3 g = step(x0.yzx, x0.xyz);
    float3 l = 1.0 - g;
    float3 i1 = min(g.xyz, l.zxy);
    float3 i2 = max(g.xyz, l.zxy);

    // x1 = x0 - i1  + 1.0 * C.xxx;
    // x2 = x0 - i2  + 2.0 * C.xxx;
    // x3 = x0 - 1.0 + 3.0 * C.xxx;
    float3 x1 = x0 - i1 + C.xxx;
    float3 x2 = x0 - i2 + C.yyy;
    float3 x3 = x0 - 0.5;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    float4 p =
      permute(permute(permute(i.z + float4(0.0, i1.z, i2.z, 1.0))
                            + i.y + float4(0.0, i1.y, i2.y, 1.0))
                            + i.x + float4(0.0, i1.x, i2.x, 1.0));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float4 j = p - 49.0 * floor(p / 49.0);  // mod(p,7*7)

    float4 x_ = floor(j / 7.0);
    float4 y_ = floor(j - 7.0 * x_);  // mod(j,N)

    float4 x = (x_ * 2.0 + 0.5) / 7.0 - 1.0;
    float4 y = (y_ * 2.0 + 0.5) / 7.0 - 1.0;

    float4 h = 1.0 - abs(x) - abs(y);

    float4 b0 = float4(x.xy, y.xy);
    float4 b1 = float4(x.zw, y.zw);

    //float4 s0 = float4(lessThan(b0, 0.0)) * 2.0 - 1.0;
    //float4 s1 = float4(lessThan(b1, 0.0)) * 2.0 - 1.0;
    float4 s0 = floor(b0) * 2.0 + 1.0;
    float4 s1 = floor(b1) * 2.0 + 1.0;
    float4 sh = -step(h, 0.0);

    float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

    float3 g0 = float3(a0.xy, h.x);
    float3 g1 = float3(a0.zw, h.y);
    float3 g2 = float3(a1.xy, h.z);
    float3 g3 = float3(a1.zw, h.w);

    // Normalise gradients
    float4 norm = taylorInvSqrt(float4(dot(g0, g0), dot(g1, g1), dot(g2, g2), dot(g3, g3)));
    g0 *= norm.x;
    g1 *= norm.y;
    g2 *= norm.z;
    g3 *= norm.w;

    // Mix final noise value
    float4 m = max(0.6 - float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
    m = m * m;
    m = m * m;

    float4 px = float4(dot(x0, g0), dot(x1, g1), dot(x2, g2), dot(x3, g3));
    return 42.0 * dot(m, px);
}

float4 snoise_grad(float3 v)
{
    const float2 C = float2(1.0 / 6.0, 1.0 / 3.0);

    // First corner
    float3 i  = floor(v + dot(v, C.yyy));
    float3 x0 = v   - i + dot(i, C.xxx);

    // Other corners
    float3 g = step(x0.yzx, x0.xyz);
    float3 l = 1.0 - g;
    float3 i1 = min(g.xyz, l.zxy);
    float3 i2 = max(g.xyz, l.zxy);

    // x1 = x0 - i1  + 1.0 * C.xxx;
    // x2 = x0 - i2  + 2.0 * C.xxx;
    // x3 = x0 - 1.0 + 3.0 * C.xxx;
    float3 x1 = x0 - i1 + C.xxx;
    float3 x2 = x0 - i2 + C.yyy;
    float3 x3 = x0 - 0.5;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    float4 p =
      permute(permute(permute(i.z + float4(0.0, i1.z, i2.z, 1.0))
                            + i.y + float4(0.0, i1.y, i2.y, 1.0))
                            + i.x + float4(0.0, i1.x, i2.x, 1.0));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float4 j = p - 49.0 * floor(p / 49.0);  // mod(p,7*7)

    float4 x_ = floor(j / 7.0);
    float4 y_ = floor(j - 7.0 * x_);  // mod(j,N)

    float4 x = (x_ * 2.0 + 0.5) / 7.0 - 1.0;
    float4 y = (y_ * 2.0 + 0.5) / 7.0 - 1.0;

    float4 h = 1.0 - abs(x) - abs(y);

    float4 b0 = float4(x.xy, y.xy);
    float4 b1 = float4(x.zw, y.zw);

    //float4 s0 = float4(lessThan(b0, 0.0)) * 2.0 - 1.0;
    //float4 s1 = float4(lessThan(b1, 0.0)) * 2.0 - 1.0;
    float4 s0 = floor(b0) * 2.0 + 1.0;
    float4 s1 = floor(b1) * 2.0 + 1.0;
    float4 sh = -step(h, 0.0);

    float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

    float3 g0 = float3(a0.xy, h.x);
    float3 g1 = float3(a0.zw, h.y);
    float3 g2 = float3(a1.xy, h.z);
    float3 g3 = float3(a1.zw, h.w);

    // Normalise gradients
    float4 norm = taylorInvSqrt(float4(dot(g0, g0), dot(g1, g1), dot(g2, g2), dot(g3, g3)));
    g0 *= norm.x;
    g1 *= norm.y;
    g2 *= norm.z;
    g3 *= norm.w;

    // Compute noise and gradient at P
    float4 m = max(0.6 - float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
    float4 m2 = m * m;
    float4 m3 = m2 * m;
    float4 m4 = m2 * m2;
    float3 grad =
        -6.0 * m3.x * x0 * dot(x0, g0) + m4.x * g0 +
        -6.0 * m3.y * x1 * dot(x1, g1) + m4.y * g1 +
        -6.0 * m3.z * x2 * dot(x2, g2) + m4.z * g2 +
        -6.0 * m3.w * x3 * dot(x3, g3) + m4.w * g3;
    float4 px = float4(dot(x0, g0), dot(x1, g1), dot(x2, g2), dot(x3, g3));
    return 42.0 * float4(grad, dot(m4, px));
}


			
			float3 pointFromCell(float3 cell) {
				float4 n = snoise_grad(cell*3);
				return cell + .5 + .1 * mul(rotAxis(normalize(n.xyz), _Time.y + n.w),float3(1,1,1));
			}
			float3 compute_distance(float3 pos) {
				float dist =1000;

				float ndist = 0;

				float3 cell = floor(pos);
				float3 center = pointFromCell(cell);

				//float dx = 0;
				//float dy = 0;
				for(int dx = -1 ; dx <= 1 ; dx ++)
				for(int dy = -1 ; dy <= 1 ; dy ++)
				for(int dz = -1 ; dz <= 1 ; dz ++) {
					float3 npoint = pointFromCell(cell + float3(dx,dy,dz));
					dist = min(dist, length(npoint - pos) - .2);
						
					float3 n= normalize(center-npoint);
					float3 p= (npoint + center)/2;
					ndist = abs(dot(n, pos - p));
					dist = min(dist, ndist);
				}
				return dist;

			/*
				float d = sdSpiral(p, float3(frac(-_Time.x),1,.2));
				p = p.yxz * float3(-1, 1, 1);
				float d2= sdSpiral(p, float3(frac(-_Time.x+.25),0,.2));
				d = min(d, d2);
				
				p = p.yxz * float3(1, -1, 1);
				p = p.xzy * float3(1, -1, 1);
				float d3= sdSpiral(p, float3(frac(-_Time.x),-1,.2));
				return min(d, d3);
				*/
				/*
				float d = 1.#INF;
				p.xz = fmod(p.xz, 10);
				float angle = sin(fmod(_Time.y, 6.28318));
				float l = .1;
				for(int i = 0 ; i <8 ; i ++) {
					float3x3 rot = rotAxis(normalize(float3(sin(i)*cos(i+1),cos(i)*cos(i+1),sin(i+1))), 1*sin(i+_Time.y));
					p = mul(rot, p);
				
					p -= float3(0,l,0);
					//d = smin(d, , 32);
					float d2 = sdCappedCylinder(p, float2(.1, l));
					d = min(d,d2);
					p -= float3(0,l,0);
					d = min(d, length(p)-.1);
				}
				return d;
				//return udBox(p, float3(.1, .5, .1));
				*/

				/*float d = sdBox(p,float3(1,1,1));
				float3 res = float3( d, 1.0, 0.0 );

				float s = 1.0;
				for( int m=0; m<3; m++ )
				{
					float3 a = fmod(fmod( p*s, 2.0 )+2,2)-1.0;
					s *= 3.0;
					float3 r = abs(1.0 - 3.0*abs(a));

					float da = max(r.x,r.y);
					float db = max(r.y,r.z);
					float dc = max(r.z,r.x);
					float c = (min(da,min(db,dc))-1.0)/s;

					if( c>d )
					{
						d = c;
						res = float3( d, 0.2*da*db*dc, (1.0+float(m))/4.0 );
					}
				}

				return res;*/


				/*
				
				float d = 1000;
				float t = fmod(_Time.x, 3.14159*2);
				for(int i = 1 ; i <10; i++) {
					p = mul(
						rotAxis(
							normalize(float3(cos(i+t),1,sin(i+t*1.5))),
							3.1415),
						p);
					float s = 1.0/i;
					d = min(d, sdTorus(p*s, float2(.25, 0.14*s))/s);
				}
				return d;
		*/
	// length(pos-z);
				/*float3 z = pos;
				float dr = 1.0;
				float r = 0.0;
				for (int i = 0; i < Iterations ; i++) {
					r = length(z);
					if (r>Bailout) break;
		
					// convert to polar coordinates
					float theta = acos(z.y/r);
					float phi = atan2(z.x,z.z);
					float phio = phi;
					dr =  pow( r, Power-1.0)*Power*dr+2;
		
					// scale and rotate the point
					float zr = pow( r,Power);
					theta = theta*Power;
					phi = phi*Power;
		
					// convert back to cartesian coordinates
					z = zr*float3(sin(phi)  *sin(theta),
								  cos(theta),
								  sin(theta)*cos(phi)
								  );
								  
					z+=pos;
				}
				return 0.5*log(l)*l/dr;*/
			}


			float3 march_raycast(inout float3 position, float3 direction) {
				// Note position is inout. Result is collision position.
				float distance = 0;
				for (int i = 0; i < _Steps && distance < _MaxDistance; ++i) {
					float3 size = compute_distance(position);
					if(size.x < _Threshold) return float3(distance, 1, i/_Steps);
					distance += size.x;
					position += size.x * direction;
				}
				return float3(distance, 0, 1);
			}




			float march_compute_depth(float3 wpos) {
				float4 clippos = mul(UNITY_MATRIX_IT_MV, float4(wpos, 1.0));
				return clippos.z;
			}


			float3 estimate_normal(float3 pos) {
				float E = 0.001;
				return normalize(float3(
					compute_distance(pos + float3(E,0,0)).x - compute_distance(pos - float3(E,0,0)).x,
					compute_distance(pos + float3(0,E,0)).x - compute_distance(pos - float3(0,E,0)).x,
					compute_distance(pos + float3(0,0,E)).x - compute_distance(pos - float3(0,0,E)).x
				));
			}

			
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc" 

			struct fragmentInput {
				float4 position : SV_POSITION;
				float4 worldpos : TEXCOORD0;
			};

			struct fragmentOutput {
				float4 color : SV_Target;
				float zvalue : SV_Depth;
			};

			fragmentInput vert(appdata_base i) {
				fragmentInput o;
				o.position = UnityObjectToClipPos(i.vertex);
				o.worldpos = mul(unity_ObjectToWorld, i.vertex);
				return o;
			}
			
			float3 palette( in float t, in float3 a, in float3 b, in float3 c, in float3 d )
			{
				return a + b*cos( 6.28318*(c*t+d) );
			}

			fragmentOutput frag(fragmentInput i, fixed facing : VFACE) {
				fragmentOutput o;
				


				float3 wpos = i.worldpos; //_WorldSpaceCameraPos;//lerp(_WorldSpaceCameraPos, i.worldpos, facing > 0);
				float3 wdir = -normalize(_WorldSpaceCameraPos -i.worldpos);
				float3 dist_hit = march_raycast(wpos, wdir);
				float depth = march_compute_depth(wpos);

				float3 normal = normalize(cross(ddy(wdir),ddx(wdir)));//estimate_normal(wpos);
				float intensity = abs(dot(_WorldSpaceLightPos0, normal)) ;
				float4 color = /*_LightColor0 */ saturate(intensity);
				float3 psycolor = palette(dist_hit.z * 3 + _Time.y*.1, 
					float3(0.5, 0.5, 0.5),	
					float3(0.5, 0.5, 0.5),	
					float3(1.0, 1.0, 0.5),
					float3(0.80, 0.90, 0.30));

				color *=abs(dot(normal, -wdir));
				color.rgb *= psycolor;
				color.a = dist_hit.y;
					
				float4 clip_pos = mul(UNITY_MATRIX_VP, float4(wpos, 1.0));
				o.zvalue = clip_pos.z / clip_pos.w;
					
				o.color = color;
				
				return o;
			}
		ENDCG


		Pass {
			Tags {
				"Queue"="Background+1"
				"IgnoreProjector"="True"
				"RenderType"="Transparent"
				"LightMode"="ForwardBase"
			}
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 3.0
			ENDCG
		}
	}
}
