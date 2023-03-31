// Upgrade NOTE: replaced 'defined FOG_COMBINED_WITH_WORLD_POS' with 'defined (FOG_COMBINED_WITH_WORLD_POS)'

// Upgrade NOTE: upgraded instancing buffer 'WobblyLifePlayerWobblyClothes' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WobblyLife/Player/WobblyClothes"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_Cutoff("Mask Clip Value", Float) = 0
		_ReplaceKey("ReplaceKey", Color) = (1,0,0.6,1)
		_ReplaceColor("ReplaceColor", Color) = (1,1,1,1)
		[HideInInspector] _texcoord("", 2D) = "white" {}
		[HideInInspector] __dirty("", Int) = 1
	}

		SubShader
		{
			Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" }
			Cull Back

			// ------------------------------------------------------------
			// Surface shader code generated out of a CGPROGRAM block:


			// ---- forward rendering base pass:
			Pass {
				Name "FORWARD"
				Tags { "LightMode" = "ForwardBase" }

		CGPROGRAM
			// compile directives
			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma target 3.0
			#pragma multi_compile_instancing
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase
			#include "HLSLSupport.cginc"
			#define UNITY_INSTANCED_LOD_FADE
			#define UNITY_INSTANCED_SH
			#define UNITY_INSTANCED_LIGHTMAPSTS
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"
			// -------- variant for: <when no other keywords are defined>
			#if !defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
			// Surface shader code generated based on:
			// vertex modifier: 'vertexDataFunc'
			// writes to per-pixel normal: no
			// writes to emission: no
			// writes to occlusion: no
			// needs world space reflection vector: no
			// needs world space normal vector: no
			// needs screen space position: no
			// needs world space position: no
			// needs view direction: no
			// needs world space view direction: no
			// needs world space position for lighting: YES
			// needs world space view direction for lighting: YES
			// needs world space view direction for lightmaps: no
			// needs vertex color: no
			// needs VFACE: no
			// needs SV_IsFrontFace: no
			// passes tangent-to-world matrix to pixel shader: no
			// reads from normal: no
			// 1 texcoords actually used
			//   float2 _texcoord
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"

			#define INTERNAL_DATA
			#define WorldReflectionVector(data,normal) data.worldRefl
			#define WorldNormalVector(data,normal) normal

			// Original surface shader snippet:
			#line 19 ""
			#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
			#endif
			/* UNITY: Original start of shader */
					#include "UnityShaderVariables.cginc"
					//#pragma target 3.0
					//#pragma multi_compile_instancing
					//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
					struct Input
					{
						float2 uv_texcoord;
						float4 screenPosition;
					};

					uniform sampler2D _MainTexture;
					uniform float4 _ReplaceKey;
					uniform float _Cutoff = 0;

					UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
						UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
			#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
						UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
			#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
					UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


					inline float Dither8x8Bayer(int x, int y)
					{
						const float dither[64] = {
							 1, 49, 13, 61,  4, 52, 16, 64,
							33, 17, 45, 29, 36, 20, 48, 32,
							 9, 57,  5, 53, 12, 60,  8, 56,
							41, 25, 37, 21, 44, 28, 40, 24,
							 3, 51, 15, 63,  2, 50, 14, 62,
							35, 19, 47, 31, 34, 18, 46, 30,
							11, 59,  7, 55, 10, 58,  6, 54,
							43, 27, 39, 23, 42, 26, 38, 22};
						int r = y * 8 + x;
						return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
					}


					void vertexDataFunc(inout appdata_full v, out Input o)
					{
						UNITY_INITIALIZE_OUTPUT(Input, o);
						float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
						o.screenPosition = ase_screenPos;
					}

					void surf(Input i , inout SurfaceOutputStandard o)
					{
						float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
						float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
						float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
						float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
						o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
						o.Alpha = 1;
						float4 ase_screenPos = i.screenPosition;
						float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
						ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
						float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
						float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
						clip(dither19 - _Cutoff);
					}



					// vertex-to-fragment interpolation data
					// no lightmaps:
					#ifndef LIGHTMAP_ON
					// half-precision fragment shader registers:
					#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					#define FOG_COMBINED_WITH_WORLD_POS
					struct v2f_surf {
					  UNITY_POSITION(pos);
					  float2 pack0 : TEXCOORD0; // _texcoord
					  float3 worldNormal : TEXCOORD1;
					  float4 worldPos : TEXCOORD2;
					  float4 custompack0 : TEXCOORD3; // screenPosition
					  #if UNITY_SHOULD_SAMPLE_SH
					  half3 sh : TEXCOORD4; // SH
					  #endif
					  UNITY_LIGHTING_COORDS(5,6)
					  #if SHADER_TARGET >= 30
					  float4 lmap : TEXCOORD7;
					  #endif
					  UNITY_VERTEX_INPUT_INSTANCE_ID
					  UNITY_VERTEX_OUTPUT_STEREO
					};
					#endif
					// high-precision fragment shader registers:
					#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					struct v2f_surf {
					  UNITY_POSITION(pos);
					  float2 pack0 : TEXCOORD0; // _texcoord
					  float3 worldNormal : TEXCOORD1;
					  float3 worldPos : TEXCOORD2;
					  float4 custompack0 : TEXCOORD3; // screenPosition
					  #if UNITY_SHOULD_SAMPLE_SH
					  half3 sh : TEXCOORD4; // SH
					  #endif
					  UNITY_FOG_COORDS(5)
					  UNITY_SHADOW_COORDS(6)
					  #if SHADER_TARGET >= 30
					  float4 lmap : TEXCOORD7;
					  #endif
					  UNITY_VERTEX_INPUT_INSTANCE_ID
					  UNITY_VERTEX_OUTPUT_STEREO
					};
					#endif
					#endif
					// with lightmaps:
					#ifdef LIGHTMAP_ON
					// half-precision fragment shader registers:
					#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					#define FOG_COMBINED_WITH_WORLD_POS
					struct v2f_surf {
					  UNITY_POSITION(pos);
					  float2 pack0 : TEXCOORD0; // _texcoord
					  float3 worldNormal : TEXCOORD1;
					  float4 worldPos : TEXCOORD2;
					  float4 custompack0 : TEXCOORD3; // screenPosition
					  float4 lmap : TEXCOORD4;
					  UNITY_LIGHTING_COORDS(5,6)
					  UNITY_VERTEX_INPUT_INSTANCE_ID
					  UNITY_VERTEX_OUTPUT_STEREO
					};
					#endif
					// high-precision fragment shader registers:
					#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					struct v2f_surf {
					  UNITY_POSITION(pos);
					  float2 pack0 : TEXCOORD0; // _texcoord
					  float3 worldNormal : TEXCOORD1;
					  float3 worldPos : TEXCOORD2;
					  float4 custompack0 : TEXCOORD3; // screenPosition
					  float4 lmap : TEXCOORD4;
					  UNITY_FOG_COORDS(5)
					  UNITY_SHADOW_COORDS(6)
					  #ifdef DIRLIGHTMAP_COMBINED
					  float3 tSpace0 : TEXCOORD7;
					  float3 tSpace1 : TEXCOORD8;
					  float3 tSpace2 : TEXCOORD9;
					  #endif
					  UNITY_VERTEX_INPUT_INSTANCE_ID
					  UNITY_VERTEX_OUTPUT_STEREO
					};
					#endif
					#endif
					float4 _texcoord_ST;

					// vertex shader
					v2f_surf vert_surf(appdata_full v) {
					  UNITY_SETUP_INSTANCE_ID(v);
					  v2f_surf o;
					  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
					  UNITY_TRANSFER_INSTANCE_ID(v,o);
					  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					  Input customInputData;
					  vertexDataFunc(v, customInputData);
					  o.custompack0.xyzw = customInputData.screenPosition;
					  o.pos = UnityObjectToClipPos(v.vertex);
					  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
					  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
					  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
					  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
					  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
					  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
					  #endif
					  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED) && !defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS)
					  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
					  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
					  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
					  #endif
					  o.worldPos.xyz = worldPos;
					  o.worldNormal = worldNormal;
					  #ifdef DYNAMICLIGHTMAP_ON
					  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					  #endif
					  #ifdef LIGHTMAP_ON
					  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					  #endif

					  // SH/ambient and vertex lights
					  #ifndef LIGHTMAP_ON
						#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						  o.sh = 0;
						  // Approximated illumination from non-important point lights
						  #ifdef VERTEXLIGHT_ON
							o.sh += Shade4PointLights(
							  unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
							  unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
							  unity_4LightAtten0, worldPos, worldNormal);
						  #endif
						  o.sh = ShadeSHPerVertex(worldNormal, o.sh);
						#endif
					  #endif // !LIGHTMAP_ON

					  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
					  #ifdef FOG_COMBINED_WITH_TSPACE
						UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader
					  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
						UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader
					  #else
						UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
					  #endif
					  return o;
					}

					// fragment shader
					fixed4 frag_surf(v2f_surf IN) : SV_Target {
					  UNITY_SETUP_INSTANCE_ID(IN);
					  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
					  // prepare and unpack data
					  Input surfIN;
					  #ifdef FOG_COMBINED_WITH_TSPACE
						UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
					  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
						UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
					  #else
						UNITY_EXTRACT_FOG(IN);
					  #endif
					  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
					  surfIN.uv_texcoord.x = 1.0;
					  surfIN.screenPosition.x = 1.0;
					  surfIN.uv_texcoord = IN.pack0.xy;
					  surfIN.screenPosition = IN.custompack0.xyzw;
					  float3 worldPos = IN.worldPos.xyz;
					  #ifndef USING_DIRECTIONAL_LIGHT
						fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
					  #else
						fixed3 lightDir = _WorldSpaceLightPos0.xyz;
					  #endif
					  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
					  #ifdef UNITY_COMPILER_HLSL
					  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
					  #else
					  SurfaceOutputStandard o;
					  #endif
					  o.Albedo = 0.0;
					  o.Emission = 0.0;
					  o.Alpha = 0.0;
					  o.Occlusion = 1.0;
					  fixed3 normalWorldVertex = fixed3(0,0,1);
					  o.Normal = IN.worldNormal;
					  normalWorldVertex = IN.worldNormal;

					  // call surface function
					  surf(surfIN, o);
					  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);

					  // compute lighting & shadowing factor
					  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
					  fixed4 c = 0;

					  // Setup lighting environment
					  UnityGI gi;
					  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
					  gi.indirect.diffuse = 0;
					  gi.indirect.specular = 0;
					  gi.light.color = _LightColor0.rgb;
					  gi.light.dir = lightDir;
					  // Call GI (lightmaps/SH/reflections) lighting function
					  UnityGIInput giInput;
					  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
					  giInput.light = gi.light;
					  giInput.worldPos = worldPos;
					  giInput.worldViewDir = worldViewDir;
					  giInput.atten = atten;
					  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
						giInput.lightmapUV = IN.lmap;
					  #else
						giInput.lightmapUV = 0.0;
					  #endif
					  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						giInput.ambient = IN.sh;
					  #else
						giInput.ambient.rgb = 0.0;
					  #endif
					  giInput.probeHDR[0] = unity_SpecCube0_HDR;
					  giInput.probeHDR[1] = unity_SpecCube1_HDR;
					  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
						giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
					  #endif
					  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
						giInput.boxMax[0] = unity_SpecCube0_BoxMax;
						giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
						giInput.boxMax[1] = unity_SpecCube1_BoxMax;
						giInput.boxMin[1] = unity_SpecCube1_BoxMin;
						giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
					  #endif
					  LightingStandard_GI(o, giInput, gi);

					  // realtime lighting: call lighting function
					  c += LightingStandard(o, worldViewDir, gi);
					  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
					  return c;
					}


					#endif

						// -------- variant for: INSTANCING_ON 
						#if defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
						// Surface shader code generated based on:
						// vertex modifier: 'vertexDataFunc'
						// writes to per-pixel normal: no
						// writes to emission: no
						// writes to occlusion: no
						// needs world space reflection vector: no
						// needs world space normal vector: no
						// needs screen space position: no
						// needs world space position: no
						// needs view direction: no
						// needs world space view direction: no
						// needs world space position for lighting: YES
						// needs world space view direction for lighting: YES
						// needs world space view direction for lightmaps: no
						// needs vertex color: no
						// needs VFACE: no
						// needs SV_IsFrontFace: no
						// passes tangent-to-world matrix to pixel shader: no
						// reads from normal: no
						// 1 texcoords actually used
						//   float2 _texcoord
						#include "UnityCG.cginc"
						#include "Lighting.cginc"
						#include "UnityPBSLighting.cginc"
						#include "AutoLight.cginc"

						#define INTERNAL_DATA
						#define WorldReflectionVector(data,normal) data.worldRefl
						#define WorldNormalVector(data,normal) normal

						// Original surface shader snippet:
						#line 19 ""
						#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
						#endif
						/* UNITY: Original start of shader */
								#include "UnityShaderVariables.cginc"
								//#pragma target 3.0
								//#pragma multi_compile_instancing
								//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
								struct Input
								{
									float2 uv_texcoord;
									float4 screenPosition;
								};

								uniform sampler2D _MainTexture;
								uniform float4 _ReplaceKey;
								uniform float _Cutoff = 0;

								UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
									UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
						#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
									UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
						#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
								UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


								inline float Dither8x8Bayer(int x, int y)
								{
									const float dither[64] = {
										 1, 49, 13, 61,  4, 52, 16, 64,
										33, 17, 45, 29, 36, 20, 48, 32,
										 9, 57,  5, 53, 12, 60,  8, 56,
										41, 25, 37, 21, 44, 28, 40, 24,
										 3, 51, 15, 63,  2, 50, 14, 62,
										35, 19, 47, 31, 34, 18, 46, 30,
										11, 59,  7, 55, 10, 58,  6, 54,
										43, 27, 39, 23, 42, 26, 38, 22};
									int r = y * 8 + x;
									return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
								}


								void vertexDataFunc(inout appdata_full v, out Input o)
								{
									UNITY_INITIALIZE_OUTPUT(Input, o);
									float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
									o.screenPosition = ase_screenPos;
								}

								void surf(Input i , inout SurfaceOutputStandard o)
								{
									float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
									float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
									float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
									float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
									o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
									o.Alpha = 1;
									float4 ase_screenPos = i.screenPosition;
									float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
									ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
									float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
									float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
									clip(dither19 - _Cutoff);
								}



								// vertex-to-fragment interpolation data
								// no lightmaps:
								#ifndef LIGHTMAP_ON
								// half-precision fragment shader registers:
								#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
								#define FOG_COMBINED_WITH_WORLD_POS
								struct v2f_surf {
								  UNITY_POSITION(pos);
								  float2 pack0 : TEXCOORD0; // _texcoord
								  float3 worldNormal : TEXCOORD1;
								  float4 worldPos : TEXCOORD2;
								  float4 custompack0 : TEXCOORD3; // screenPosition
								  #if UNITY_SHOULD_SAMPLE_SH
								  half3 sh : TEXCOORD4; // SH
								  #endif
								  UNITY_LIGHTING_COORDS(5,6)
								  #if SHADER_TARGET >= 30
								  float4 lmap : TEXCOORD7;
								  #endif
								  UNITY_VERTEX_INPUT_INSTANCE_ID
								  UNITY_VERTEX_OUTPUT_STEREO
								};
								#endif
								// high-precision fragment shader registers:
								#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
								struct v2f_surf {
								  UNITY_POSITION(pos);
								  float2 pack0 : TEXCOORD0; // _texcoord
								  float3 worldNormal : TEXCOORD1;
								  float3 worldPos : TEXCOORD2;
								  float4 custompack0 : TEXCOORD3; // screenPosition
								  #if UNITY_SHOULD_SAMPLE_SH
								  half3 sh : TEXCOORD4; // SH
								  #endif
								  UNITY_FOG_COORDS(5)
								  UNITY_SHADOW_COORDS(6)
								  #if SHADER_TARGET >= 30
								  float4 lmap : TEXCOORD7;
								  #endif
								  UNITY_VERTEX_INPUT_INSTANCE_ID
								  UNITY_VERTEX_OUTPUT_STEREO
								};
								#endif
								#endif
								// with lightmaps:
								#ifdef LIGHTMAP_ON
								// half-precision fragment shader registers:
								#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
								#define FOG_COMBINED_WITH_WORLD_POS
								struct v2f_surf {
								  UNITY_POSITION(pos);
								  float2 pack0 : TEXCOORD0; // _texcoord
								  float3 worldNormal : TEXCOORD1;
								  float4 worldPos : TEXCOORD2;
								  float4 custompack0 : TEXCOORD3; // screenPosition
								  float4 lmap : TEXCOORD4;
								  UNITY_LIGHTING_COORDS(5,6)
								  UNITY_VERTEX_INPUT_INSTANCE_ID
								  UNITY_VERTEX_OUTPUT_STEREO
								};
								#endif
								// high-precision fragment shader registers:
								#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
								struct v2f_surf {
								  UNITY_POSITION(pos);
								  float2 pack0 : TEXCOORD0; // _texcoord
								  float3 worldNormal : TEXCOORD1;
								  float3 worldPos : TEXCOORD2;
								  float4 custompack0 : TEXCOORD3; // screenPosition
								  float4 lmap : TEXCOORD4;
								  UNITY_FOG_COORDS(5)
								  UNITY_SHADOW_COORDS(6)
								  #ifdef DIRLIGHTMAP_COMBINED
								  float3 tSpace0 : TEXCOORD7;
								  float3 tSpace1 : TEXCOORD8;
								  float3 tSpace2 : TEXCOORD9;
								  #endif
								  UNITY_VERTEX_INPUT_INSTANCE_ID
								  UNITY_VERTEX_OUTPUT_STEREO
								};
								#endif
								#endif
								float4 _texcoord_ST;

								// vertex shader
								v2f_surf vert_surf(appdata_full v) {
								  UNITY_SETUP_INSTANCE_ID(v);
								  v2f_surf o;
								  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
								  UNITY_TRANSFER_INSTANCE_ID(v,o);
								  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
								  Input customInputData;
								  vertexDataFunc(v, customInputData);
								  o.custompack0.xyzw = customInputData.screenPosition;
								  o.pos = UnityObjectToClipPos(v.vertex);
								  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
								  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
								  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
								  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
								  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
								  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
								  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
								  #endif
								  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED) && !defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS)
								  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
								  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
								  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
								  #endif
								  o.worldPos.xyz = worldPos;
								  o.worldNormal = worldNormal;
								  #ifdef DYNAMICLIGHTMAP_ON
								  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
								  #endif
								  #ifdef LIGHTMAP_ON
								  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
								  #endif

								  // SH/ambient and vertex lights
								  #ifndef LIGHTMAP_ON
									#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
									  o.sh = 0;
									  // Approximated illumination from non-important point lights
									  #ifdef VERTEXLIGHT_ON
										o.sh += Shade4PointLights(
										  unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
										  unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
										  unity_4LightAtten0, worldPos, worldNormal);
									  #endif
									  o.sh = ShadeSHPerVertex(worldNormal, o.sh);
									#endif
								  #endif // !LIGHTMAP_ON

								  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
								  #ifdef FOG_COMBINED_WITH_TSPACE
									UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader
								  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
									UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader
								  #else
									UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
								  #endif
								  return o;
								}

								// fragment shader
								fixed4 frag_surf(v2f_surf IN) : SV_Target {
								  UNITY_SETUP_INSTANCE_ID(IN);
								  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
								  // prepare and unpack data
								  Input surfIN;
								  #ifdef FOG_COMBINED_WITH_TSPACE
									UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
								  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
									UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
								  #else
									UNITY_EXTRACT_FOG(IN);
								  #endif
								  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
								  surfIN.uv_texcoord.x = 1.0;
								  surfIN.screenPosition.x = 1.0;
								  surfIN.uv_texcoord = IN.pack0.xy;
								  surfIN.screenPosition = IN.custompack0.xyzw;
								  float3 worldPos = IN.worldPos.xyz;
								  #ifndef USING_DIRECTIONAL_LIGHT
									fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
								  #else
									fixed3 lightDir = _WorldSpaceLightPos0.xyz;
								  #endif
								  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
								  #ifdef UNITY_COMPILER_HLSL
								  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
								  #else
								  SurfaceOutputStandard o;
								  #endif
								  o.Albedo = 0.0;
								  o.Emission = 0.0;
								  o.Alpha = 0.0;
								  o.Occlusion = 1.0;
								  fixed3 normalWorldVertex = fixed3(0,0,1);
								  o.Normal = IN.worldNormal;
								  normalWorldVertex = IN.worldNormal;

								  // call surface function
								  surf(surfIN, o);
								  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);

								  // compute lighting & shadowing factor
								  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
								  fixed4 c = 0;

								  // Setup lighting environment
								  UnityGI gi;
								  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
								  gi.indirect.diffuse = 0;
								  gi.indirect.specular = 0;
								  gi.light.color = _LightColor0.rgb;
								  gi.light.dir = lightDir;
								  // Call GI (lightmaps/SH/reflections) lighting function
								  UnityGIInput giInput;
								  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
								  giInput.light = gi.light;
								  giInput.worldPos = worldPos;
								  giInput.worldViewDir = worldViewDir;
								  giInput.atten = atten;
								  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
									giInput.lightmapUV = IN.lmap;
								  #else
									giInput.lightmapUV = 0.0;
								  #endif
								  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
									giInput.ambient = IN.sh;
								  #else
									giInput.ambient.rgb = 0.0;
								  #endif
								  giInput.probeHDR[0] = unity_SpecCube0_HDR;
								  giInput.probeHDR[1] = unity_SpecCube1_HDR;
								  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
									giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
								  #endif
								  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
									giInput.boxMax[0] = unity_SpecCube0_BoxMax;
									giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
									giInput.boxMax[1] = unity_SpecCube1_BoxMax;
									giInput.boxMin[1] = unity_SpecCube1_BoxMin;
									giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
								  #endif
								  LightingStandard_GI(o, giInput, gi);

								  // realtime lighting: call lighting function
								  c += LightingStandard(o, worldViewDir, gi);
								  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
								  return c;
								}


								#endif

									// -------- variant for: LOD_FADE_CROSSFADE 
									#if defined(LOD_FADE_CROSSFADE) && !defined(INSTANCING_ON)
									// Surface shader code generated based on:
									// vertex modifier: 'vertexDataFunc'
									// writes to per-pixel normal: no
									// writes to emission: no
									// writes to occlusion: no
									// needs world space reflection vector: no
									// needs world space normal vector: no
									// needs screen space position: no
									// needs world space position: no
									// needs view direction: no
									// needs world space view direction: no
									// needs world space position for lighting: YES
									// needs world space view direction for lighting: YES
									// needs world space view direction for lightmaps: no
									// needs vertex color: no
									// needs VFACE: no
									// needs SV_IsFrontFace: no
									// passes tangent-to-world matrix to pixel shader: no
									// reads from normal: no
									// 1 texcoords actually used
									//   float2 _texcoord
									#include "UnityCG.cginc"
									#include "Lighting.cginc"
									#include "UnityPBSLighting.cginc"
									#include "AutoLight.cginc"

									#define INTERNAL_DATA
									#define WorldReflectionVector(data,normal) data.worldRefl
									#define WorldNormalVector(data,normal) normal

									// Original surface shader snippet:
									#line 19 ""
									#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
									#endif
									/* UNITY: Original start of shader */
											#include "UnityShaderVariables.cginc"
											//#pragma target 3.0
											//#pragma multi_compile_instancing
											//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
											struct Input
											{
												float2 uv_texcoord;
												float4 screenPosition;
											};

											uniform sampler2D _MainTexture;
											uniform float4 _ReplaceKey;
											uniform float _Cutoff = 0;

											UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
												UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
									#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
												UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
									#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
											UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


											inline float Dither8x8Bayer(int x, int y)
											{
												const float dither[64] = {
													 1, 49, 13, 61,  4, 52, 16, 64,
													33, 17, 45, 29, 36, 20, 48, 32,
													 9, 57,  5, 53, 12, 60,  8, 56,
													41, 25, 37, 21, 44, 28, 40, 24,
													 3, 51, 15, 63,  2, 50, 14, 62,
													35, 19, 47, 31, 34, 18, 46, 30,
													11, 59,  7, 55, 10, 58,  6, 54,
													43, 27, 39, 23, 42, 26, 38, 22};
												int r = y * 8 + x;
												return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
											}


											void vertexDataFunc(inout appdata_full v, out Input o)
											{
												UNITY_INITIALIZE_OUTPUT(Input, o);
												float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
												o.screenPosition = ase_screenPos;
											}

											void surf(Input i , inout SurfaceOutputStandard o)
											{
												float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
												float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
												float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
												float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
												o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
												o.Alpha = 1;
												float4 ase_screenPos = i.screenPosition;
												float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
												ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
												float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
												float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
												clip(dither19 - _Cutoff);
											}



											// vertex-to-fragment interpolation data
											// no lightmaps:
											#ifndef LIGHTMAP_ON
											// half-precision fragment shader registers:
											#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
											#define FOG_COMBINED_WITH_WORLD_POS
											struct v2f_surf {
											  UNITY_POSITION(pos);
											  float2 pack0 : TEXCOORD0; // _texcoord
											  float3 worldNormal : TEXCOORD1;
											  float4 worldPos : TEXCOORD2;
											  float4 custompack0 : TEXCOORD3; // screenPosition
											  #if UNITY_SHOULD_SAMPLE_SH
											  half3 sh : TEXCOORD4; // SH
											  #endif
											  UNITY_LIGHTING_COORDS(5,6)
											  #if SHADER_TARGET >= 30
											  float4 lmap : TEXCOORD7;
											  #endif
											  UNITY_VERTEX_INPUT_INSTANCE_ID
											  UNITY_VERTEX_OUTPUT_STEREO
											};
											#endif
											// high-precision fragment shader registers:
											#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
											struct v2f_surf {
											  UNITY_POSITION(pos);
											  float2 pack0 : TEXCOORD0; // _texcoord
											  float3 worldNormal : TEXCOORD1;
											  float3 worldPos : TEXCOORD2;
											  float4 custompack0 : TEXCOORD3; // screenPosition
											  #if UNITY_SHOULD_SAMPLE_SH
											  half3 sh : TEXCOORD4; // SH
											  #endif
											  UNITY_FOG_COORDS(5)
											  UNITY_SHADOW_COORDS(6)
											  #if SHADER_TARGET >= 30
											  float4 lmap : TEXCOORD7;
											  #endif
											  UNITY_VERTEX_INPUT_INSTANCE_ID
											  UNITY_VERTEX_OUTPUT_STEREO
											};
											#endif
											#endif
											// with lightmaps:
											#ifdef LIGHTMAP_ON
											// half-precision fragment shader registers:
											#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
											#define FOG_COMBINED_WITH_WORLD_POS
											struct v2f_surf {
											  UNITY_POSITION(pos);
											  float2 pack0 : TEXCOORD0; // _texcoord
											  float3 worldNormal : TEXCOORD1;
											  float4 worldPos : TEXCOORD2;
											  float4 custompack0 : TEXCOORD3; // screenPosition
											  float4 lmap : TEXCOORD4;
											  UNITY_LIGHTING_COORDS(5,6)
											  UNITY_VERTEX_INPUT_INSTANCE_ID
											  UNITY_VERTEX_OUTPUT_STEREO
											};
											#endif
											// high-precision fragment shader registers:
											#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
											struct v2f_surf {
											  UNITY_POSITION(pos);
											  float2 pack0 : TEXCOORD0; // _texcoord
											  float3 worldNormal : TEXCOORD1;
											  float3 worldPos : TEXCOORD2;
											  float4 custompack0 : TEXCOORD3; // screenPosition
											  float4 lmap : TEXCOORD4;
											  UNITY_FOG_COORDS(5)
											  UNITY_SHADOW_COORDS(6)
											  #ifdef DIRLIGHTMAP_COMBINED
											  float3 tSpace0 : TEXCOORD7;
											  float3 tSpace1 : TEXCOORD8;
											  float3 tSpace2 : TEXCOORD9;
											  #endif
											  UNITY_VERTEX_INPUT_INSTANCE_ID
											  UNITY_VERTEX_OUTPUT_STEREO
											};
											#endif
											#endif
											float4 _texcoord_ST;

											// vertex shader
											v2f_surf vert_surf(appdata_full v) {
											  UNITY_SETUP_INSTANCE_ID(v);
											  v2f_surf o;
											  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
											  UNITY_TRANSFER_INSTANCE_ID(v,o);
											  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
											  Input customInputData;
											  vertexDataFunc(v, customInputData);
											  o.custompack0.xyzw = customInputData.screenPosition;
											  o.pos = UnityObjectToClipPos(v.vertex);
											  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
											  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
											  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
											  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
											  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
											  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
											  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
											  #endif
											  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED) && !defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS)
											  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
											  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
											  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
											  #endif
											  o.worldPos.xyz = worldPos;
											  o.worldNormal = worldNormal;
											  #ifdef DYNAMICLIGHTMAP_ON
											  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
											  #endif
											  #ifdef LIGHTMAP_ON
											  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
											  #endif

											  // SH/ambient and vertex lights
											  #ifndef LIGHTMAP_ON
												#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
												  o.sh = 0;
												  // Approximated illumination from non-important point lights
												  #ifdef VERTEXLIGHT_ON
													o.sh += Shade4PointLights(
													  unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
													  unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
													  unity_4LightAtten0, worldPos, worldNormal);
												  #endif
												  o.sh = ShadeSHPerVertex(worldNormal, o.sh);
												#endif
											  #endif // !LIGHTMAP_ON

											  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
											  #ifdef FOG_COMBINED_WITH_TSPACE
												UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader
											  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
												UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader
											  #else
												UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
											  #endif
											  return o;
											}

											// fragment shader
											fixed4 frag_surf(v2f_surf IN) : SV_Target {
											  UNITY_SETUP_INSTANCE_ID(IN);
											  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
											  // prepare and unpack data
											  Input surfIN;
											  #ifdef FOG_COMBINED_WITH_TSPACE
												UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
											  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
												UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
											  #else
												UNITY_EXTRACT_FOG(IN);
											  #endif
											  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
											  surfIN.uv_texcoord.x = 1.0;
											  surfIN.screenPosition.x = 1.0;
											  surfIN.uv_texcoord = IN.pack0.xy;
											  surfIN.screenPosition = IN.custompack0.xyzw;
											  float3 worldPos = IN.worldPos.xyz;
											  #ifndef USING_DIRECTIONAL_LIGHT
												fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
											  #else
												fixed3 lightDir = _WorldSpaceLightPos0.xyz;
											  #endif
											  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
											  #ifdef UNITY_COMPILER_HLSL
											  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
											  #else
											  SurfaceOutputStandard o;
											  #endif
											  o.Albedo = 0.0;
											  o.Emission = 0.0;
											  o.Alpha = 0.0;
											  o.Occlusion = 1.0;
											  fixed3 normalWorldVertex = fixed3(0,0,1);
											  o.Normal = IN.worldNormal;
											  normalWorldVertex = IN.worldNormal;

											  // call surface function
											  surf(surfIN, o);
											  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);

											  // compute lighting & shadowing factor
											  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
											  fixed4 c = 0;

											  // Setup lighting environment
											  UnityGI gi;
											  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
											  gi.indirect.diffuse = 0;
											  gi.indirect.specular = 0;
											  gi.light.color = _LightColor0.rgb;
											  gi.light.dir = lightDir;
											  // Call GI (lightmaps/SH/reflections) lighting function
											  UnityGIInput giInput;
											  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
											  giInput.light = gi.light;
											  giInput.worldPos = worldPos;
											  giInput.worldViewDir = worldViewDir;
											  giInput.atten = atten;
											  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
												giInput.lightmapUV = IN.lmap;
											  #else
												giInput.lightmapUV = 0.0;
											  #endif
											  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
												giInput.ambient = IN.sh;
											  #else
												giInput.ambient.rgb = 0.0;
											  #endif
											  giInput.probeHDR[0] = unity_SpecCube0_HDR;
											  giInput.probeHDR[1] = unity_SpecCube1_HDR;
											  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
												giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
											  #endif
											  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
												giInput.boxMax[0] = unity_SpecCube0_BoxMax;
												giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
												giInput.boxMax[1] = unity_SpecCube1_BoxMax;
												giInput.boxMin[1] = unity_SpecCube1_BoxMin;
												giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
											  #endif
											  LightingStandard_GI(o, giInput, gi);

											  // realtime lighting: call lighting function
											  c += LightingStandard(o, worldViewDir, gi);
											  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
											  return c;
											}


											#endif

												// -------- variant for: LOD_FADE_CROSSFADE INSTANCING_ON 
												#if defined(LOD_FADE_CROSSFADE) && defined(INSTANCING_ON)
												// Surface shader code generated based on:
												// vertex modifier: 'vertexDataFunc'
												// writes to per-pixel normal: no
												// writes to emission: no
												// writes to occlusion: no
												// needs world space reflection vector: no
												// needs world space normal vector: no
												// needs screen space position: no
												// needs world space position: no
												// needs view direction: no
												// needs world space view direction: no
												// needs world space position for lighting: YES
												// needs world space view direction for lighting: YES
												// needs world space view direction for lightmaps: no
												// needs vertex color: no
												// needs VFACE: no
												// needs SV_IsFrontFace: no
												// passes tangent-to-world matrix to pixel shader: no
												// reads from normal: no
												// 1 texcoords actually used
												//   float2 _texcoord
												#include "UnityCG.cginc"
												#include "Lighting.cginc"
												#include "UnityPBSLighting.cginc"
												#include "AutoLight.cginc"

												#define INTERNAL_DATA
												#define WorldReflectionVector(data,normal) data.worldRefl
												#define WorldNormalVector(data,normal) normal

												// Original surface shader snippet:
												#line 19 ""
												#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
												#endif
												/* UNITY: Original start of shader */
														#include "UnityShaderVariables.cginc"
														//#pragma target 3.0
														//#pragma multi_compile_instancing
														//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
														struct Input
														{
															float2 uv_texcoord;
															float4 screenPosition;
														};

														uniform sampler2D _MainTexture;
														uniform float4 _ReplaceKey;
														uniform float _Cutoff = 0;

														UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
															UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
												#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
															UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
												#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
														UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


														inline float Dither8x8Bayer(int x, int y)
														{
															const float dither[64] = {
																 1, 49, 13, 61,  4, 52, 16, 64,
																33, 17, 45, 29, 36, 20, 48, 32,
																 9, 57,  5, 53, 12, 60,  8, 56,
																41, 25, 37, 21, 44, 28, 40, 24,
																 3, 51, 15, 63,  2, 50, 14, 62,
																35, 19, 47, 31, 34, 18, 46, 30,
																11, 59,  7, 55, 10, 58,  6, 54,
																43, 27, 39, 23, 42, 26, 38, 22};
															int r = y * 8 + x;
															return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
														}


														void vertexDataFunc(inout appdata_full v, out Input o)
														{
															UNITY_INITIALIZE_OUTPUT(Input, o);
															float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
															o.screenPosition = ase_screenPos;
														}

														void surf(Input i , inout SurfaceOutputStandard o)
														{
															float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
															float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
															float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
															float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
															o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
															o.Alpha = 1;
															float4 ase_screenPos = i.screenPosition;
															float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
															ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
															float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
															float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
															clip(dither19 - _Cutoff);
														}



														// vertex-to-fragment interpolation data
														// no lightmaps:
														#ifndef LIGHTMAP_ON
														// half-precision fragment shader registers:
														#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
														#define FOG_COMBINED_WITH_WORLD_POS
														struct v2f_surf {
														  UNITY_POSITION(pos);
														  float2 pack0 : TEXCOORD0; // _texcoord
														  float3 worldNormal : TEXCOORD1;
														  float4 worldPos : TEXCOORD2;
														  float4 custompack0 : TEXCOORD3; // screenPosition
														  #if UNITY_SHOULD_SAMPLE_SH
														  half3 sh : TEXCOORD4; // SH
														  #endif
														  UNITY_LIGHTING_COORDS(5,6)
														  #if SHADER_TARGET >= 30
														  float4 lmap : TEXCOORD7;
														  #endif
														  UNITY_VERTEX_INPUT_INSTANCE_ID
														  UNITY_VERTEX_OUTPUT_STEREO
														};
														#endif
														// high-precision fragment shader registers:
														#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
														struct v2f_surf {
														  UNITY_POSITION(pos);
														  float2 pack0 : TEXCOORD0; // _texcoord
														  float3 worldNormal : TEXCOORD1;
														  float3 worldPos : TEXCOORD2;
														  float4 custompack0 : TEXCOORD3; // screenPosition
														  #if UNITY_SHOULD_SAMPLE_SH
														  half3 sh : TEXCOORD4; // SH
														  #endif
														  UNITY_FOG_COORDS(5)
														  UNITY_SHADOW_COORDS(6)
														  #if SHADER_TARGET >= 30
														  float4 lmap : TEXCOORD7;
														  #endif
														  UNITY_VERTEX_INPUT_INSTANCE_ID
														  UNITY_VERTEX_OUTPUT_STEREO
														};
														#endif
														#endif
														// with lightmaps:
														#ifdef LIGHTMAP_ON
														// half-precision fragment shader registers:
														#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
														#define FOG_COMBINED_WITH_WORLD_POS
														struct v2f_surf {
														  UNITY_POSITION(pos);
														  float2 pack0 : TEXCOORD0; // _texcoord
														  float3 worldNormal : TEXCOORD1;
														  float4 worldPos : TEXCOORD2;
														  float4 custompack0 : TEXCOORD3; // screenPosition
														  float4 lmap : TEXCOORD4;
														  UNITY_LIGHTING_COORDS(5,6)
														  UNITY_VERTEX_INPUT_INSTANCE_ID
														  UNITY_VERTEX_OUTPUT_STEREO
														};
														#endif
														// high-precision fragment shader registers:
														#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
														struct v2f_surf {
														  UNITY_POSITION(pos);
														  float2 pack0 : TEXCOORD0; // _texcoord
														  float3 worldNormal : TEXCOORD1;
														  float3 worldPos : TEXCOORD2;
														  float4 custompack0 : TEXCOORD3; // screenPosition
														  float4 lmap : TEXCOORD4;
														  UNITY_FOG_COORDS(5)
														  UNITY_SHADOW_COORDS(6)
														  #ifdef DIRLIGHTMAP_COMBINED
														  float3 tSpace0 : TEXCOORD7;
														  float3 tSpace1 : TEXCOORD8;
														  float3 tSpace2 : TEXCOORD9;
														  #endif
														  UNITY_VERTEX_INPUT_INSTANCE_ID
														  UNITY_VERTEX_OUTPUT_STEREO
														};
														#endif
														#endif
														float4 _texcoord_ST;

														// vertex shader
														v2f_surf vert_surf(appdata_full v) {
														  UNITY_SETUP_INSTANCE_ID(v);
														  v2f_surf o;
														  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
														  UNITY_TRANSFER_INSTANCE_ID(v,o);
														  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
														  Input customInputData;
														  vertexDataFunc(v, customInputData);
														  o.custompack0.xyzw = customInputData.screenPosition;
														  o.pos = UnityObjectToClipPos(v.vertex);
														  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
														  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
														  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
														  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
														  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
														  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
														  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
														  #endif
														  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED) && !defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS)
														  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
														  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
														  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
														  #endif
														  o.worldPos.xyz = worldPos;
														  o.worldNormal = worldNormal;
														  #ifdef DYNAMICLIGHTMAP_ON
														  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
														  #endif
														  #ifdef LIGHTMAP_ON
														  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
														  #endif

														  // SH/ambient and vertex lights
														  #ifndef LIGHTMAP_ON
															#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
															  o.sh = 0;
															  // Approximated illumination from non-important point lights
															  #ifdef VERTEXLIGHT_ON
																o.sh += Shade4PointLights(
																  unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
																  unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
																  unity_4LightAtten0, worldPos, worldNormal);
															  #endif
															  o.sh = ShadeSHPerVertex(worldNormal, o.sh);
															#endif
														  #endif // !LIGHTMAP_ON

														  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
														  #ifdef FOG_COMBINED_WITH_TSPACE
															UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader
														  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
															UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader
														  #else
															UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
														  #endif
														  return o;
														}

														// fragment shader
														fixed4 frag_surf(v2f_surf IN) : SV_Target {
														  UNITY_SETUP_INSTANCE_ID(IN);
														  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
														  // prepare and unpack data
														  Input surfIN;
														  #ifdef FOG_COMBINED_WITH_TSPACE
															UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
														  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
															UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
														  #else
															UNITY_EXTRACT_FOG(IN);
														  #endif
														  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
														  surfIN.uv_texcoord.x = 1.0;
														  surfIN.screenPosition.x = 1.0;
														  surfIN.uv_texcoord = IN.pack0.xy;
														  surfIN.screenPosition = IN.custompack0.xyzw;
														  float3 worldPos = IN.worldPos.xyz;
														  #ifndef USING_DIRECTIONAL_LIGHT
															fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
														  #else
															fixed3 lightDir = _WorldSpaceLightPos0.xyz;
														  #endif
														  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
														  #ifdef UNITY_COMPILER_HLSL
														  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
														  #else
														  SurfaceOutputStandard o;
														  #endif
														  o.Albedo = 0.0;
														  o.Emission = 0.0;
														  o.Alpha = 0.0;
														  o.Occlusion = 1.0;
														  fixed3 normalWorldVertex = fixed3(0,0,1);
														  o.Normal = IN.worldNormal;
														  normalWorldVertex = IN.worldNormal;

														  // call surface function
														  surf(surfIN, o);
														  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);

														  // compute lighting & shadowing factor
														  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
														  fixed4 c = 0;

														  // Setup lighting environment
														  UnityGI gi;
														  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
														  gi.indirect.diffuse = 0;
														  gi.indirect.specular = 0;
														  gi.light.color = _LightColor0.rgb;
														  gi.light.dir = lightDir;
														  // Call GI (lightmaps/SH/reflections) lighting function
														  UnityGIInput giInput;
														  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
														  giInput.light = gi.light;
														  giInput.worldPos = worldPos;
														  giInput.worldViewDir = worldViewDir;
														  giInput.atten = atten;
														  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
															giInput.lightmapUV = IN.lmap;
														  #else
															giInput.lightmapUV = 0.0;
														  #endif
														  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
															giInput.ambient = IN.sh;
														  #else
															giInput.ambient.rgb = 0.0;
														  #endif
														  giInput.probeHDR[0] = unity_SpecCube0_HDR;
														  giInput.probeHDR[1] = unity_SpecCube1_HDR;
														  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
															giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
														  #endif
														  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
															giInput.boxMax[0] = unity_SpecCube0_BoxMax;
															giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
															giInput.boxMax[1] = unity_SpecCube1_BoxMax;
															giInput.boxMin[1] = unity_SpecCube1_BoxMin;
															giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
														  #endif
														  LightingStandard_GI(o, giInput, gi);

														  // realtime lighting: call lighting function
														  c += LightingStandard(o, worldViewDir, gi);
														  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
														  return c;
														}


														#endif


														ENDCG

														}

			// ---- forward rendering additive lights pass:
			Pass {
				Name "FORWARD"
				Tags { "LightMode" = "ForwardAdd" }
				ZWrite Off Blend One One

		CGPROGRAM
															// compile directives
															#pragma vertex vert_surf
															#pragma fragment frag_surf
															#pragma target 3.0
															#pragma multi_compile_instancing
															#pragma multi_compile __ LOD_FADE_CROSSFADE
															#pragma multi_compile_fog
															#pragma skip_variants INSTANCING_ON
															#pragma multi_compile_fwdadd_fullshadows
															#include "HLSLSupport.cginc"
															#define UNITY_INSTANCED_LOD_FADE
															#define UNITY_INSTANCED_SH
															#define UNITY_INSTANCED_LIGHTMAPSTS
															#include "UnityShaderVariables.cginc"
															#include "UnityShaderUtilities.cginc"
															// -------- variant for: <when no other keywords are defined>
															#if !defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
															// Surface shader code generated based on:
															// vertex modifier: 'vertexDataFunc'
															// writes to per-pixel normal: no
															// writes to emission: no
															// writes to occlusion: no
															// needs world space reflection vector: no
															// needs world space normal vector: no
															// needs screen space position: no
															// needs world space position: no
															// needs view direction: no
															// needs world space view direction: no
															// needs world space position for lighting: YES
															// needs world space view direction for lighting: YES
															// needs world space view direction for lightmaps: no
															// needs vertex color: no
															// needs VFACE: no
															// needs SV_IsFrontFace: no
															// passes tangent-to-world matrix to pixel shader: no
															// reads from normal: no
															// 1 texcoords actually used
															//   float2 _texcoord
															#include "UnityCG.cginc"
															#include "Lighting.cginc"
															#include "UnityPBSLighting.cginc"
															#include "AutoLight.cginc"

															#define INTERNAL_DATA
															#define WorldReflectionVector(data,normal) data.worldRefl
															#define WorldNormalVector(data,normal) normal

															// Original surface shader snippet:
															#line 19 ""
															#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
															#endif
															/* UNITY: Original start of shader */
																	#include "UnityShaderVariables.cginc"
																	//#pragma target 3.0
																	//#pragma multi_compile_instancing
																	//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																	struct Input
																	{
																		float2 uv_texcoord;
																		float4 screenPosition;
																	};

																	uniform sampler2D _MainTexture;
																	uniform float4 _ReplaceKey;
																	uniform float _Cutoff = 0;

																	UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																		UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
															#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																		UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
															#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																	UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																	inline float Dither8x8Bayer(int x, int y)
																	{
																		const float dither[64] = {
																			 1, 49, 13, 61,  4, 52, 16, 64,
																			33, 17, 45, 29, 36, 20, 48, 32,
																			 9, 57,  5, 53, 12, 60,  8, 56,
																			41, 25, 37, 21, 44, 28, 40, 24,
																			 3, 51, 15, 63,  2, 50, 14, 62,
																			35, 19, 47, 31, 34, 18, 46, 30,
																			11, 59,  7, 55, 10, 58,  6, 54,
																			43, 27, 39, 23, 42, 26, 38, 22};
																		int r = y * 8 + x;
																		return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																	}


																	void vertexDataFunc(inout appdata_full v, out Input o)
																	{
																		UNITY_INITIALIZE_OUTPUT(Input, o);
																		float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																		o.screenPosition = ase_screenPos;
																	}

																	void surf(Input i , inout SurfaceOutputStandard o)
																	{
																		float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																		float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																		float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																		float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																		o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																		o.Alpha = 1;
																		float4 ase_screenPos = i.screenPosition;
																		float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																		ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																		float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																		float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																		clip(dither19 - _Cutoff);
																	}



																	// vertex-to-fragment interpolation data
																	struct v2f_surf {
																	  UNITY_POSITION(pos);
																	  float2 pack0 : TEXCOORD0; // _texcoord
																	  float3 worldNormal : TEXCOORD1;
																	  float3 worldPos : TEXCOORD2;
																	  float4 custompack0 : TEXCOORD3; // screenPosition
																	  UNITY_LIGHTING_COORDS(4,5)
																	  UNITY_FOG_COORDS(6)
																	  UNITY_VERTEX_INPUT_INSTANCE_ID
																	  UNITY_VERTEX_OUTPUT_STEREO
																	};
																	float4 _texcoord_ST;

																	// vertex shader
																	v2f_surf vert_surf(appdata_full v) {
																	  UNITY_SETUP_INSTANCE_ID(v);
																	  v2f_surf o;
																	  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																	  UNITY_TRANSFER_INSTANCE_ID(v,o);
																	  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																	  Input customInputData;
																	  vertexDataFunc(v, customInputData);
																	  o.custompack0.xyzw = customInputData.screenPosition;
																	  o.pos = UnityObjectToClipPos(v.vertex);
																	  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																	  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																	  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																	  o.worldPos.xyz = worldPos;
																	  o.worldNormal = worldNormal;

																	  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
																	  UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
																	  return o;
																	}

																	// fragment shader
																	fixed4 frag_surf(v2f_surf IN) : SV_Target {
																	  UNITY_SETUP_INSTANCE_ID(IN);
																	  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																	  // prepare and unpack data
																	  Input surfIN;
																	  #ifdef FOG_COMBINED_WITH_TSPACE
																		UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																	  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																		UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																	  #else
																		UNITY_EXTRACT_FOG(IN);
																	  #endif
																	  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																	  surfIN.uv_texcoord.x = 1.0;
																	  surfIN.screenPosition.x = 1.0;
																	  surfIN.uv_texcoord = IN.pack0.xy;
																	  surfIN.screenPosition = IN.custompack0.xyzw;
																	  float3 worldPos = IN.worldPos.xyz;
																	  #ifndef USING_DIRECTIONAL_LIGHT
																		fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																	  #else
																		fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																	  #endif
																	  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
																	  #ifdef UNITY_COMPILER_HLSL
																	  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																	  #else
																	  SurfaceOutputStandard o;
																	  #endif
																	  o.Albedo = 0.0;
																	  o.Emission = 0.0;
																	  o.Alpha = 0.0;
																	  o.Occlusion = 1.0;
																	  fixed3 normalWorldVertex = fixed3(0,0,1);
																	  o.Normal = IN.worldNormal;
																	  normalWorldVertex = IN.worldNormal;

																	  // call surface function
																	  surf(surfIN, o);
																	  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																	  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
																	  fixed4 c = 0;

																	  // Setup lighting environment
																	  UnityGI gi;
																	  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
																	  gi.indirect.diffuse = 0;
																	  gi.indirect.specular = 0;
																	  gi.light.color = _LightColor0.rgb;
																	  gi.light.dir = lightDir;
																	  gi.light.color *= atten;
																	  c += LightingStandard(o, worldViewDir, gi);
																	  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
																	  return c;
																	}


																	#endif

																		// -------- variant for: LOD_FADE_CROSSFADE 
																		#if defined(LOD_FADE_CROSSFADE) && !defined(INSTANCING_ON)
																		// Surface shader code generated based on:
																		// vertex modifier: 'vertexDataFunc'
																		// writes to per-pixel normal: no
																		// writes to emission: no
																		// writes to occlusion: no
																		// needs world space reflection vector: no
																		// needs world space normal vector: no
																		// needs screen space position: no
																		// needs world space position: no
																		// needs view direction: no
																		// needs world space view direction: no
																		// needs world space position for lighting: YES
																		// needs world space view direction for lighting: YES
																		// needs world space view direction for lightmaps: no
																		// needs vertex color: no
																		// needs VFACE: no
																		// needs SV_IsFrontFace: no
																		// passes tangent-to-world matrix to pixel shader: no
																		// reads from normal: no
																		// 1 texcoords actually used
																		//   float2 _texcoord
																		#include "UnityCG.cginc"
																		#include "Lighting.cginc"
																		#include "UnityPBSLighting.cginc"
																		#include "AutoLight.cginc"

																		#define INTERNAL_DATA
																		#define WorldReflectionVector(data,normal) data.worldRefl
																		#define WorldNormalVector(data,normal) normal

																		// Original surface shader snippet:
																		#line 19 ""
																		#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																		#endif
																		/* UNITY: Original start of shader */
																				#include "UnityShaderVariables.cginc"
																				//#pragma target 3.0
																				//#pragma multi_compile_instancing
																				//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																				struct Input
																				{
																					float2 uv_texcoord;
																					float4 screenPosition;
																				};

																				uniform sampler2D _MainTexture;
																				uniform float4 _ReplaceKey;
																				uniform float _Cutoff = 0;

																				UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																					UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																		#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																					UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																		#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																				UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																				inline float Dither8x8Bayer(int x, int y)
																				{
																					const float dither[64] = {
																						 1, 49, 13, 61,  4, 52, 16, 64,
																						33, 17, 45, 29, 36, 20, 48, 32,
																						 9, 57,  5, 53, 12, 60,  8, 56,
																						41, 25, 37, 21, 44, 28, 40, 24,
																						 3, 51, 15, 63,  2, 50, 14, 62,
																						35, 19, 47, 31, 34, 18, 46, 30,
																						11, 59,  7, 55, 10, 58,  6, 54,
																						43, 27, 39, 23, 42, 26, 38, 22};
																					int r = y * 8 + x;
																					return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																				}


																				void vertexDataFunc(inout appdata_full v, out Input o)
																				{
																					UNITY_INITIALIZE_OUTPUT(Input, o);
																					float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																					o.screenPosition = ase_screenPos;
																				}

																				void surf(Input i , inout SurfaceOutputStandard o)
																				{
																					float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																					float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																					float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																					float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																					o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																					o.Alpha = 1;
																					float4 ase_screenPos = i.screenPosition;
																					float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																					ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																					float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																					float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																					clip(dither19 - _Cutoff);
																				}



																				// vertex-to-fragment interpolation data
																				struct v2f_surf {
																				  UNITY_POSITION(pos);
																				  float2 pack0 : TEXCOORD0; // _texcoord
																				  float3 worldNormal : TEXCOORD1;
																				  float3 worldPos : TEXCOORD2;
																				  float4 custompack0 : TEXCOORD3; // screenPosition
																				  UNITY_LIGHTING_COORDS(4,5)
																				  UNITY_FOG_COORDS(6)
																				  UNITY_VERTEX_INPUT_INSTANCE_ID
																				  UNITY_VERTEX_OUTPUT_STEREO
																				};
																				float4 _texcoord_ST;

																				// vertex shader
																				v2f_surf vert_surf(appdata_full v) {
																				  UNITY_SETUP_INSTANCE_ID(v);
																				  v2f_surf o;
																				  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																				  UNITY_TRANSFER_INSTANCE_ID(v,o);
																				  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																				  Input customInputData;
																				  vertexDataFunc(v, customInputData);
																				  o.custompack0.xyzw = customInputData.screenPosition;
																				  o.pos = UnityObjectToClipPos(v.vertex);
																				  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																				  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																				  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																				  o.worldPos.xyz = worldPos;
																				  o.worldNormal = worldNormal;

																				  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
																				  UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
																				  return o;
																				}

																				// fragment shader
																				fixed4 frag_surf(v2f_surf IN) : SV_Target {
																				  UNITY_SETUP_INSTANCE_ID(IN);
																				  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																				  // prepare and unpack data
																				  Input surfIN;
																				  #ifdef FOG_COMBINED_WITH_TSPACE
																					UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																				  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																					UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																				  #else
																					UNITY_EXTRACT_FOG(IN);
																				  #endif
																				  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																				  surfIN.uv_texcoord.x = 1.0;
																				  surfIN.screenPosition.x = 1.0;
																				  surfIN.uv_texcoord = IN.pack0.xy;
																				  surfIN.screenPosition = IN.custompack0.xyzw;
																				  float3 worldPos = IN.worldPos.xyz;
																				  #ifndef USING_DIRECTIONAL_LIGHT
																					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																				  #else
																					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																				  #endif
																				  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
																				  #ifdef UNITY_COMPILER_HLSL
																				  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																				  #else
																				  SurfaceOutputStandard o;
																				  #endif
																				  o.Albedo = 0.0;
																				  o.Emission = 0.0;
																				  o.Alpha = 0.0;
																				  o.Occlusion = 1.0;
																				  fixed3 normalWorldVertex = fixed3(0,0,1);
																				  o.Normal = IN.worldNormal;
																				  normalWorldVertex = IN.worldNormal;

																				  // call surface function
																				  surf(surfIN, o);
																				  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																				  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
																				  fixed4 c = 0;

																				  // Setup lighting environment
																				  UnityGI gi;
																				  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
																				  gi.indirect.diffuse = 0;
																				  gi.indirect.specular = 0;
																				  gi.light.color = _LightColor0.rgb;
																				  gi.light.dir = lightDir;
																				  gi.light.color *= atten;
																				  c += LightingStandard(o, worldViewDir, gi);
																				  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
																				  return c;
																				}


																				#endif


																				ENDCG

																				}

															// ---- deferred shading pass:
															Pass {
																Name "DEFERRED"
																Tags { "LightMode" = "Deferred" }

														CGPROGRAM
																					// compile directives
																					#pragma vertex vert_surf
																					#pragma fragment frag_surf
																					#pragma target 3.0
																					#pragma multi_compile_instancing
																					#pragma multi_compile __ LOD_FADE_CROSSFADE
																					#pragma exclude_renderers nomrt
																					#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
																					#pragma multi_compile_prepassfinal
																					#include "HLSLSupport.cginc"
																					#define UNITY_INSTANCED_LOD_FADE
																					#define UNITY_INSTANCED_SH
																					#define UNITY_INSTANCED_LIGHTMAPSTS
																					#include "UnityShaderVariables.cginc"
																					#include "UnityShaderUtilities.cginc"
																					// -------- variant for: <when no other keywords are defined>
																					#if !defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
																					// Surface shader code generated based on:
																					// vertex modifier: 'vertexDataFunc'
																					// writes to per-pixel normal: no
																					// writes to emission: no
																					// writes to occlusion: no
																					// needs world space reflection vector: no
																					// needs world space normal vector: no
																					// needs screen space position: no
																					// needs world space position: no
																					// needs view direction: no
																					// needs world space view direction: no
																					// needs world space position for lighting: YES
																					// needs world space view direction for lighting: YES
																					// needs world space view direction for lightmaps: no
																					// needs vertex color: no
																					// needs VFACE: no
																					// needs SV_IsFrontFace: no
																					// passes tangent-to-world matrix to pixel shader: no
																					// reads from normal: YES
																					// 1 texcoords actually used
																					//   float2 _texcoord
																					#include "UnityCG.cginc"
																					#include "Lighting.cginc"
																					#include "UnityPBSLighting.cginc"

																					#define INTERNAL_DATA
																					#define WorldReflectionVector(data,normal) data.worldRefl
																					#define WorldNormalVector(data,normal) normal

																					// Original surface shader snippet:
																					#line 19 ""
																					#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																					#endif
																					/* UNITY: Original start of shader */
																							#include "UnityShaderVariables.cginc"
																							//#pragma target 3.0
																							//#pragma multi_compile_instancing
																							//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																							struct Input
																							{
																								float2 uv_texcoord;
																								float4 screenPosition;
																							};

																							uniform sampler2D _MainTexture;
																							uniform float4 _ReplaceKey;
																							uniform float _Cutoff = 0;

																							UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																								UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																					#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																								UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																					#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																							UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																							inline float Dither8x8Bayer(int x, int y)
																							{
																								const float dither[64] = {
																									 1, 49, 13, 61,  4, 52, 16, 64,
																									33, 17, 45, 29, 36, 20, 48, 32,
																									 9, 57,  5, 53, 12, 60,  8, 56,
																									41, 25, 37, 21, 44, 28, 40, 24,
																									 3, 51, 15, 63,  2, 50, 14, 62,
																									35, 19, 47, 31, 34, 18, 46, 30,
																									11, 59,  7, 55, 10, 58,  6, 54,
																									43, 27, 39, 23, 42, 26, 38, 22};
																								int r = y * 8 + x;
																								return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																							}


																							void vertexDataFunc(inout appdata_full v, out Input o)
																							{
																								UNITY_INITIALIZE_OUTPUT(Input, o);
																								float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																								o.screenPosition = ase_screenPos;
																							}

																							void surf(Input i , inout SurfaceOutputStandard o)
																							{
																								float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																								float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																								float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																								float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																								o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																								o.Alpha = 1;
																								float4 ase_screenPos = i.screenPosition;
																								float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																								ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																								float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																								float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																								clip(dither19 - _Cutoff);
																							}



																							// vertex-to-fragment interpolation data
																							struct v2f_surf {
																							  UNITY_POSITION(pos);
																							  float2 pack0 : TEXCOORD0; // _texcoord
																							  float3 worldNormal : TEXCOORD1;
																							  float3 worldPos : TEXCOORD2;
																							  float4 custompack0 : TEXCOORD3; // screenPosition
																							#ifndef DIRLIGHTMAP_OFF
																							  float3 viewDir : TEXCOORD4;
																							#endif
																							  float4 lmap : TEXCOORD5;
																							#ifndef LIGHTMAP_ON
																							  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																								half3 sh : TEXCOORD6; // SH
																							  #endif
																							#else
																							  #ifdef DIRLIGHTMAP_OFF
																								float4 lmapFadePos : TEXCOORD6;
																							  #endif
																							#endif
																							  UNITY_VERTEX_INPUT_INSTANCE_ID
																							  UNITY_VERTEX_OUTPUT_STEREO
																							};
																							float4 _texcoord_ST;

																							// vertex shader
																							v2f_surf vert_surf(appdata_full v) {
																							  UNITY_SETUP_INSTANCE_ID(v);
																							  v2f_surf o;
																							  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																							  UNITY_TRANSFER_INSTANCE_ID(v,o);
																							  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																							  Input customInputData;
																							  vertexDataFunc(v, customInputData);
																							  o.custompack0.xyzw = customInputData.screenPosition;
																							  o.pos = UnityObjectToClipPos(v.vertex);
																							  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																							  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																							  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																							  o.worldPos.xyz = worldPos;
																							  o.worldNormal = worldNormal;
																							  float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
																							  #ifndef DIRLIGHTMAP_OFF
																							  o.viewDir = viewDirForLight;
																							  #endif
																							#ifdef DYNAMICLIGHTMAP_ON
																							  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
																							#else
																							  o.lmap.zw = 0;
																							#endif
																							#ifdef LIGHTMAP_ON
																							  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
																							  #ifdef DIRLIGHTMAP_OFF
																								o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
																								o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
																							  #endif
																							#else
																							  o.lmap.xy = 0;
																								#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																								  o.sh = 0;
																								  o.sh = ShadeSHPerVertex(worldNormal, o.sh);
																								#endif
																							#endif
																							  return o;
																							}
																							#ifdef LIGHTMAP_ON
																							float4 unity_LightmapFade;
																							#endif
																							fixed4 unity_Ambient;

																							// fragment shader
																							void frag_surf(v2f_surf IN,
																								out half4 outGBuffer0 : SV_Target0,
																								out half4 outGBuffer1 : SV_Target1,
																								out half4 outGBuffer2 : SV_Target2,
																								out half4 outEmission : SV_Target3
																							#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
																								, out half4 outShadowMask : SV_Target4
																							#endif
																							) {
																							  UNITY_SETUP_INSTANCE_ID(IN);
																							  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																							  // prepare and unpack data
																							  Input surfIN;
																							  #ifdef FOG_COMBINED_WITH_TSPACE
																								UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																							  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																								UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																							  #else
																								UNITY_EXTRACT_FOG(IN);
																							  #endif
																							  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																							  surfIN.uv_texcoord.x = 1.0;
																							  surfIN.screenPosition.x = 1.0;
																							  surfIN.uv_texcoord = IN.pack0.xy;
																							  surfIN.screenPosition = IN.custompack0.xyzw;
																							  float3 worldPos = IN.worldPos.xyz;
																							  #ifndef USING_DIRECTIONAL_LIGHT
																								fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																							  #else
																								fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																							  #endif
																							  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
																							  #ifdef UNITY_COMPILER_HLSL
																							  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																							  #else
																							  SurfaceOutputStandard o;
																							  #endif
																							  o.Albedo = 0.0;
																							  o.Emission = 0.0;
																							  o.Alpha = 0.0;
																							  o.Occlusion = 1.0;
																							  fixed3 normalWorldVertex = fixed3(0,0,1);
																							  o.Normal = IN.worldNormal;
																							  normalWorldVertex = IN.worldNormal;

																							  // call surface function
																							  surf(surfIN, o);
																							  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																							fixed3 originalNormal = o.Normal;
																							  half atten = 1;

																							  // Setup lighting environment
																							  UnityGI gi;
																							  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
																							  gi.indirect.diffuse = 0;
																							  gi.indirect.specular = 0;
																							  gi.light.color = 0;
																							  gi.light.dir = half3(0,1,0);
																							  // Call GI (lightmaps/SH/reflections) lighting function
																							  UnityGIInput giInput;
																							  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
																							  giInput.light = gi.light;
																							  giInput.worldPos = worldPos;
																							  giInput.worldViewDir = worldViewDir;
																							  giInput.atten = atten;
																							  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
																								giInput.lightmapUV = IN.lmap;
																							  #else
																								giInput.lightmapUV = 0.0;
																							  #endif
																							  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																								giInput.ambient = IN.sh;
																							  #else
																								giInput.ambient.rgb = 0.0;
																							  #endif
																							  giInput.probeHDR[0] = unity_SpecCube0_HDR;
																							  giInput.probeHDR[1] = unity_SpecCube1_HDR;
																							  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
																								giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
																							  #endif
																							  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
																								giInput.boxMax[0] = unity_SpecCube0_BoxMax;
																								giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
																								giInput.boxMax[1] = unity_SpecCube1_BoxMax;
																								giInput.boxMin[1] = unity_SpecCube1_BoxMin;
																								giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
																							  #endif
																							  LightingStandard_GI(o, giInput, gi);

																							  // call lighting function to output g-buffer
																							  outEmission = LightingStandard_Deferred(o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
																							  #if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
																								outShadowMask = UnityGetRawBakedOcclusions(IN.lmap.xy, worldPos);
																							  #endif
																							  #ifndef UNITY_HDR_ON
																							  outEmission.rgb = exp2(-outEmission.rgb);
																							  #endif
																							}


																							#endif

																							// -------- variant for: INSTANCING_ON 
																							#if defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
																							// Surface shader code generated based on:
																							// vertex modifier: 'vertexDataFunc'
																							// writes to per-pixel normal: no
																							// writes to emission: no
																							// writes to occlusion: no
																							// needs world space reflection vector: no
																							// needs world space normal vector: no
																							// needs screen space position: no
																							// needs world space position: no
																							// needs view direction: no
																							// needs world space view direction: no
																							// needs world space position for lighting: YES
																							// needs world space view direction for lighting: YES
																							// needs world space view direction for lightmaps: no
																							// needs vertex color: no
																							// needs VFACE: no
																							// needs SV_IsFrontFace: no
																							// passes tangent-to-world matrix to pixel shader: no
																							// reads from normal: YES
																							// 1 texcoords actually used
																							//   float2 _texcoord
																							#include "UnityCG.cginc"
																							#include "Lighting.cginc"
																							#include "UnityPBSLighting.cginc"

																							#define INTERNAL_DATA
																							#define WorldReflectionVector(data,normal) data.worldRefl
																							#define WorldNormalVector(data,normal) normal

																							// Original surface shader snippet:
																							#line 19 ""
																							#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																							#endif
																							/* UNITY: Original start of shader */
																									#include "UnityShaderVariables.cginc"
																									//#pragma target 3.0
																									//#pragma multi_compile_instancing
																									//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																									struct Input
																									{
																										float2 uv_texcoord;
																										float4 screenPosition;
																									};

																									uniform sampler2D _MainTexture;
																									uniform float4 _ReplaceKey;
																									uniform float _Cutoff = 0;

																									UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																										UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																							#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																										UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																							#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																									UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																									inline float Dither8x8Bayer(int x, int y)
																									{
																										const float dither[64] = {
																											 1, 49, 13, 61,  4, 52, 16, 64,
																											33, 17, 45, 29, 36, 20, 48, 32,
																											 9, 57,  5, 53, 12, 60,  8, 56,
																											41, 25, 37, 21, 44, 28, 40, 24,
																											 3, 51, 15, 63,  2, 50, 14, 62,
																											35, 19, 47, 31, 34, 18, 46, 30,
																											11, 59,  7, 55, 10, 58,  6, 54,
																											43, 27, 39, 23, 42, 26, 38, 22};
																										int r = y * 8 + x;
																										return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																									}


																									void vertexDataFunc(inout appdata_full v, out Input o)
																									{
																										UNITY_INITIALIZE_OUTPUT(Input, o);
																										float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																										o.screenPosition = ase_screenPos;
																									}

																									void surf(Input i , inout SurfaceOutputStandard o)
																									{
																										float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																										float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																										float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																										float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																										o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																										o.Alpha = 1;
																										float4 ase_screenPos = i.screenPosition;
																										float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																										ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																										float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																										float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																										clip(dither19 - _Cutoff);
																									}



																									// vertex-to-fragment interpolation data
																									struct v2f_surf {
																									  UNITY_POSITION(pos);
																									  float2 pack0 : TEXCOORD0; // _texcoord
																									  float3 worldNormal : TEXCOORD1;
																									  float3 worldPos : TEXCOORD2;
																									  float4 custompack0 : TEXCOORD3; // screenPosition
																									#ifndef DIRLIGHTMAP_OFF
																									  float3 viewDir : TEXCOORD4;
																									#endif
																									  float4 lmap : TEXCOORD5;
																									#ifndef LIGHTMAP_ON
																									  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																										half3 sh : TEXCOORD6; // SH
																									  #endif
																									#else
																									  #ifdef DIRLIGHTMAP_OFF
																										float4 lmapFadePos : TEXCOORD6;
																									  #endif
																									#endif
																									  UNITY_VERTEX_INPUT_INSTANCE_ID
																									  UNITY_VERTEX_OUTPUT_STEREO
																									};
																									float4 _texcoord_ST;

																									// vertex shader
																									v2f_surf vert_surf(appdata_full v) {
																									  UNITY_SETUP_INSTANCE_ID(v);
																									  v2f_surf o;
																									  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																									  UNITY_TRANSFER_INSTANCE_ID(v,o);
																									  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																									  Input customInputData;
																									  vertexDataFunc(v, customInputData);
																									  o.custompack0.xyzw = customInputData.screenPosition;
																									  o.pos = UnityObjectToClipPos(v.vertex);
																									  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																									  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																									  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																									  o.worldPos.xyz = worldPos;
																									  o.worldNormal = worldNormal;
																									  float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
																									  #ifndef DIRLIGHTMAP_OFF
																									  o.viewDir = viewDirForLight;
																									  #endif
																									#ifdef DYNAMICLIGHTMAP_ON
																									  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
																									#else
																									  o.lmap.zw = 0;
																									#endif
																									#ifdef LIGHTMAP_ON
																									  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
																									  #ifdef DIRLIGHTMAP_OFF
																										o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
																										o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
																									  #endif
																									#else
																									  o.lmap.xy = 0;
																										#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																										  o.sh = 0;
																										  o.sh = ShadeSHPerVertex(worldNormal, o.sh);
																										#endif
																									#endif
																									  return o;
																									}
																									#ifdef LIGHTMAP_ON
																									float4 unity_LightmapFade;
																									#endif
																									fixed4 unity_Ambient;

																									// fragment shader
																									void frag_surf(v2f_surf IN,
																										out half4 outGBuffer0 : SV_Target0,
																										out half4 outGBuffer1 : SV_Target1,
																										out half4 outGBuffer2 : SV_Target2,
																										out half4 outEmission : SV_Target3
																									#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
																										, out half4 outShadowMask : SV_Target4
																									#endif
																									) {
																									  UNITY_SETUP_INSTANCE_ID(IN);
																									  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																									  // prepare and unpack data
																									  Input surfIN;
																									  #ifdef FOG_COMBINED_WITH_TSPACE
																										UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																									  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																										UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																									  #else
																										UNITY_EXTRACT_FOG(IN);
																									  #endif
																									  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																									  surfIN.uv_texcoord.x = 1.0;
																									  surfIN.screenPosition.x = 1.0;
																									  surfIN.uv_texcoord = IN.pack0.xy;
																									  surfIN.screenPosition = IN.custompack0.xyzw;
																									  float3 worldPos = IN.worldPos.xyz;
																									  #ifndef USING_DIRECTIONAL_LIGHT
																										fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																									  #else
																										fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																									  #endif
																									  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
																									  #ifdef UNITY_COMPILER_HLSL
																									  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																									  #else
																									  SurfaceOutputStandard o;
																									  #endif
																									  o.Albedo = 0.0;
																									  o.Emission = 0.0;
																									  o.Alpha = 0.0;
																									  o.Occlusion = 1.0;
																									  fixed3 normalWorldVertex = fixed3(0,0,1);
																									  o.Normal = IN.worldNormal;
																									  normalWorldVertex = IN.worldNormal;

																									  // call surface function
																									  surf(surfIN, o);
																									  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																									fixed3 originalNormal = o.Normal;
																									  half atten = 1;

																									  // Setup lighting environment
																									  UnityGI gi;
																									  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
																									  gi.indirect.diffuse = 0;
																									  gi.indirect.specular = 0;
																									  gi.light.color = 0;
																									  gi.light.dir = half3(0,1,0);
																									  // Call GI (lightmaps/SH/reflections) lighting function
																									  UnityGIInput giInput;
																									  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
																									  giInput.light = gi.light;
																									  giInput.worldPos = worldPos;
																									  giInput.worldViewDir = worldViewDir;
																									  giInput.atten = atten;
																									  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
																										giInput.lightmapUV = IN.lmap;
																									  #else
																										giInput.lightmapUV = 0.0;
																									  #endif
																									  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																										giInput.ambient = IN.sh;
																									  #else
																										giInput.ambient.rgb = 0.0;
																									  #endif
																									  giInput.probeHDR[0] = unity_SpecCube0_HDR;
																									  giInput.probeHDR[1] = unity_SpecCube1_HDR;
																									  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
																										giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
																									  #endif
																									  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
																										giInput.boxMax[0] = unity_SpecCube0_BoxMax;
																										giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
																										giInput.boxMax[1] = unity_SpecCube1_BoxMax;
																										giInput.boxMin[1] = unity_SpecCube1_BoxMin;
																										giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
																									  #endif
																									  LightingStandard_GI(o, giInput, gi);

																									  // call lighting function to output g-buffer
																									  outEmission = LightingStandard_Deferred(o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
																									  #if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
																										outShadowMask = UnityGetRawBakedOcclusions(IN.lmap.xy, worldPos);
																									  #endif
																									  #ifndef UNITY_HDR_ON
																									  outEmission.rgb = exp2(-outEmission.rgb);
																									  #endif
																									}


																									#endif

																									// -------- variant for: LOD_FADE_CROSSFADE 
																									#if defined(LOD_FADE_CROSSFADE) && !defined(INSTANCING_ON)
																									// Surface shader code generated based on:
																									// vertex modifier: 'vertexDataFunc'
																									// writes to per-pixel normal: no
																									// writes to emission: no
																									// writes to occlusion: no
																									// needs world space reflection vector: no
																									// needs world space normal vector: no
																									// needs screen space position: no
																									// needs world space position: no
																									// needs view direction: no
																									// needs world space view direction: no
																									// needs world space position for lighting: YES
																									// needs world space view direction for lighting: YES
																									// needs world space view direction for lightmaps: no
																									// needs vertex color: no
																									// needs VFACE: no
																									// needs SV_IsFrontFace: no
																									// passes tangent-to-world matrix to pixel shader: no
																									// reads from normal: YES
																									// 1 texcoords actually used
																									//   float2 _texcoord
																									#include "UnityCG.cginc"
																									#include "Lighting.cginc"
																									#include "UnityPBSLighting.cginc"

																									#define INTERNAL_DATA
																									#define WorldReflectionVector(data,normal) data.worldRefl
																									#define WorldNormalVector(data,normal) normal

																									// Original surface shader snippet:
																									#line 19 ""
																									#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																									#endif
																									/* UNITY: Original start of shader */
																											#include "UnityShaderVariables.cginc"
																											//#pragma target 3.0
																											//#pragma multi_compile_instancing
																											//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																											struct Input
																											{
																												float2 uv_texcoord;
																												float4 screenPosition;
																											};

																											uniform sampler2D _MainTexture;
																											uniform float4 _ReplaceKey;
																											uniform float _Cutoff = 0;

																											UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																												UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																									#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																												UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																									#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																											UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																											inline float Dither8x8Bayer(int x, int y)
																											{
																												const float dither[64] = {
																													 1, 49, 13, 61,  4, 52, 16, 64,
																													33, 17, 45, 29, 36, 20, 48, 32,
																													 9, 57,  5, 53, 12, 60,  8, 56,
																													41, 25, 37, 21, 44, 28, 40, 24,
																													 3, 51, 15, 63,  2, 50, 14, 62,
																													35, 19, 47, 31, 34, 18, 46, 30,
																													11, 59,  7, 55, 10, 58,  6, 54,
																													43, 27, 39, 23, 42, 26, 38, 22};
																												int r = y * 8 + x;
																												return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																											}


																											void vertexDataFunc(inout appdata_full v, out Input o)
																											{
																												UNITY_INITIALIZE_OUTPUT(Input, o);
																												float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																												o.screenPosition = ase_screenPos;
																											}

																											void surf(Input i , inout SurfaceOutputStandard o)
																											{
																												float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																												float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																												float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																												float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																												o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																												o.Alpha = 1;
																												float4 ase_screenPos = i.screenPosition;
																												float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																												ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																												float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																												float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																												clip(dither19 - _Cutoff);
																											}



																											// vertex-to-fragment interpolation data
																											struct v2f_surf {
																											  UNITY_POSITION(pos);
																											  float2 pack0 : TEXCOORD0; // _texcoord
																											  float3 worldNormal : TEXCOORD1;
																											  float3 worldPos : TEXCOORD2;
																											  float4 custompack0 : TEXCOORD3; // screenPosition
																											#ifndef DIRLIGHTMAP_OFF
																											  float3 viewDir : TEXCOORD4;
																											#endif
																											  float4 lmap : TEXCOORD5;
																											#ifndef LIGHTMAP_ON
																											  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																												half3 sh : TEXCOORD6; // SH
																											  #endif
																											#else
																											  #ifdef DIRLIGHTMAP_OFF
																												float4 lmapFadePos : TEXCOORD6;
																											  #endif
																											#endif
																											  UNITY_VERTEX_INPUT_INSTANCE_ID
																											  UNITY_VERTEX_OUTPUT_STEREO
																											};
																											float4 _texcoord_ST;

																											// vertex shader
																											v2f_surf vert_surf(appdata_full v) {
																											  UNITY_SETUP_INSTANCE_ID(v);
																											  v2f_surf o;
																											  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																											  UNITY_TRANSFER_INSTANCE_ID(v,o);
																											  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																											  Input customInputData;
																											  vertexDataFunc(v, customInputData);
																											  o.custompack0.xyzw = customInputData.screenPosition;
																											  o.pos = UnityObjectToClipPos(v.vertex);
																											  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																											  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																											  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																											  o.worldPos.xyz = worldPos;
																											  o.worldNormal = worldNormal;
																											  float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
																											  #ifndef DIRLIGHTMAP_OFF
																											  o.viewDir = viewDirForLight;
																											  #endif
																											#ifdef DYNAMICLIGHTMAP_ON
																											  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
																											#else
																											  o.lmap.zw = 0;
																											#endif
																											#ifdef LIGHTMAP_ON
																											  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
																											  #ifdef DIRLIGHTMAP_OFF
																												o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
																												o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
																											  #endif
																											#else
																											  o.lmap.xy = 0;
																												#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																												  o.sh = 0;
																												  o.sh = ShadeSHPerVertex(worldNormal, o.sh);
																												#endif
																											#endif
																											  return o;
																											}
																											#ifdef LIGHTMAP_ON
																											float4 unity_LightmapFade;
																											#endif
																											fixed4 unity_Ambient;

																											// fragment shader
																											void frag_surf(v2f_surf IN,
																												out half4 outGBuffer0 : SV_Target0,
																												out half4 outGBuffer1 : SV_Target1,
																												out half4 outGBuffer2 : SV_Target2,
																												out half4 outEmission : SV_Target3
																											#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
																												, out half4 outShadowMask : SV_Target4
																											#endif
																											) {
																											  UNITY_SETUP_INSTANCE_ID(IN);
																											  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																											  // prepare and unpack data
																											  Input surfIN;
																											  #ifdef FOG_COMBINED_WITH_TSPACE
																												UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																											  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																												UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																											  #else
																												UNITY_EXTRACT_FOG(IN);
																											  #endif
																											  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																											  surfIN.uv_texcoord.x = 1.0;
																											  surfIN.screenPosition.x = 1.0;
																											  surfIN.uv_texcoord = IN.pack0.xy;
																											  surfIN.screenPosition = IN.custompack0.xyzw;
																											  float3 worldPos = IN.worldPos.xyz;
																											  #ifndef USING_DIRECTIONAL_LIGHT
																												fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																											  #else
																												fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																											  #endif
																											  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
																											  #ifdef UNITY_COMPILER_HLSL
																											  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																											  #else
																											  SurfaceOutputStandard o;
																											  #endif
																											  o.Albedo = 0.0;
																											  o.Emission = 0.0;
																											  o.Alpha = 0.0;
																											  o.Occlusion = 1.0;
																											  fixed3 normalWorldVertex = fixed3(0,0,1);
																											  o.Normal = IN.worldNormal;
																											  normalWorldVertex = IN.worldNormal;

																											  // call surface function
																											  surf(surfIN, o);
																											  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																											fixed3 originalNormal = o.Normal;
																											  half atten = 1;

																											  // Setup lighting environment
																											  UnityGI gi;
																											  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
																											  gi.indirect.diffuse = 0;
																											  gi.indirect.specular = 0;
																											  gi.light.color = 0;
																											  gi.light.dir = half3(0,1,0);
																											  // Call GI (lightmaps/SH/reflections) lighting function
																											  UnityGIInput giInput;
																											  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
																											  giInput.light = gi.light;
																											  giInput.worldPos = worldPos;
																											  giInput.worldViewDir = worldViewDir;
																											  giInput.atten = atten;
																											  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
																												giInput.lightmapUV = IN.lmap;
																											  #else
																												giInput.lightmapUV = 0.0;
																											  #endif
																											  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																												giInput.ambient = IN.sh;
																											  #else
																												giInput.ambient.rgb = 0.0;
																											  #endif
																											  giInput.probeHDR[0] = unity_SpecCube0_HDR;
																											  giInput.probeHDR[1] = unity_SpecCube1_HDR;
																											  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
																												giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
																											  #endif
																											  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
																												giInput.boxMax[0] = unity_SpecCube0_BoxMax;
																												giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
																												giInput.boxMax[1] = unity_SpecCube1_BoxMax;
																												giInput.boxMin[1] = unity_SpecCube1_BoxMin;
																												giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
																											  #endif
																											  LightingStandard_GI(o, giInput, gi);

																											  // call lighting function to output g-buffer
																											  outEmission = LightingStandard_Deferred(o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
																											  #if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
																												outShadowMask = UnityGetRawBakedOcclusions(IN.lmap.xy, worldPos);
																											  #endif
																											  #ifndef UNITY_HDR_ON
																											  outEmission.rgb = exp2(-outEmission.rgb);
																											  #endif
																											}


																											#endif

																											// -------- variant for: LOD_FADE_CROSSFADE INSTANCING_ON 
																											#if defined(LOD_FADE_CROSSFADE) && defined(INSTANCING_ON)
																											// Surface shader code generated based on:
																											// vertex modifier: 'vertexDataFunc'
																											// writes to per-pixel normal: no
																											// writes to emission: no
																											// writes to occlusion: no
																											// needs world space reflection vector: no
																											// needs world space normal vector: no
																											// needs screen space position: no
																											// needs world space position: no
																											// needs view direction: no
																											// needs world space view direction: no
																											// needs world space position for lighting: YES
																											// needs world space view direction for lighting: YES
																											// needs world space view direction for lightmaps: no
																											// needs vertex color: no
																											// needs VFACE: no
																											// needs SV_IsFrontFace: no
																											// passes tangent-to-world matrix to pixel shader: no
																											// reads from normal: YES
																											// 1 texcoords actually used
																											//   float2 _texcoord
																											#include "UnityCG.cginc"
																											#include "Lighting.cginc"
																											#include "UnityPBSLighting.cginc"

																											#define INTERNAL_DATA
																											#define WorldReflectionVector(data,normal) data.worldRefl
																											#define WorldNormalVector(data,normal) normal

																											// Original surface shader snippet:
																											#line 19 ""
																											#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																											#endif
																											/* UNITY: Original start of shader */
																													#include "UnityShaderVariables.cginc"
																													//#pragma target 3.0
																													//#pragma multi_compile_instancing
																													//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																													struct Input
																													{
																														float2 uv_texcoord;
																														float4 screenPosition;
																													};

																													uniform sampler2D _MainTexture;
																													uniform float4 _ReplaceKey;
																													uniform float _Cutoff = 0;

																													UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																														UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																											#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																														UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																											#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																													UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																													inline float Dither8x8Bayer(int x, int y)
																													{
																														const float dither[64] = {
																															 1, 49, 13, 61,  4, 52, 16, 64,
																															33, 17, 45, 29, 36, 20, 48, 32,
																															 9, 57,  5, 53, 12, 60,  8, 56,
																															41, 25, 37, 21, 44, 28, 40, 24,
																															 3, 51, 15, 63,  2, 50, 14, 62,
																															35, 19, 47, 31, 34, 18, 46, 30,
																															11, 59,  7, 55, 10, 58,  6, 54,
																															43, 27, 39, 23, 42, 26, 38, 22};
																														int r = y * 8 + x;
																														return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																													}


																													void vertexDataFunc(inout appdata_full v, out Input o)
																													{
																														UNITY_INITIALIZE_OUTPUT(Input, o);
																														float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																														o.screenPosition = ase_screenPos;
																													}

																													void surf(Input i , inout SurfaceOutputStandard o)
																													{
																														float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																														float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																														float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																														float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																														o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																														o.Alpha = 1;
																														float4 ase_screenPos = i.screenPosition;
																														float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																														ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																														float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																														float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																														clip(dither19 - _Cutoff);
																													}



																													// vertex-to-fragment interpolation data
																													struct v2f_surf {
																													  UNITY_POSITION(pos);
																													  float2 pack0 : TEXCOORD0; // _texcoord
																													  float3 worldNormal : TEXCOORD1;
																													  float3 worldPos : TEXCOORD2;
																													  float4 custompack0 : TEXCOORD3; // screenPosition
																													#ifndef DIRLIGHTMAP_OFF
																													  float3 viewDir : TEXCOORD4;
																													#endif
																													  float4 lmap : TEXCOORD5;
																													#ifndef LIGHTMAP_ON
																													  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																														half3 sh : TEXCOORD6; // SH
																													  #endif
																													#else
																													  #ifdef DIRLIGHTMAP_OFF
																														float4 lmapFadePos : TEXCOORD6;
																													  #endif
																													#endif
																													  UNITY_VERTEX_INPUT_INSTANCE_ID
																													  UNITY_VERTEX_OUTPUT_STEREO
																													};
																													float4 _texcoord_ST;

																													// vertex shader
																													v2f_surf vert_surf(appdata_full v) {
																													  UNITY_SETUP_INSTANCE_ID(v);
																													  v2f_surf o;
																													  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																													  UNITY_TRANSFER_INSTANCE_ID(v,o);
																													  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																													  Input customInputData;
																													  vertexDataFunc(v, customInputData);
																													  o.custompack0.xyzw = customInputData.screenPosition;
																													  o.pos = UnityObjectToClipPos(v.vertex);
																													  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																													  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																													  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																													  o.worldPos.xyz = worldPos;
																													  o.worldNormal = worldNormal;
																													  float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
																													  #ifndef DIRLIGHTMAP_OFF
																													  o.viewDir = viewDirForLight;
																													  #endif
																													#ifdef DYNAMICLIGHTMAP_ON
																													  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
																													#else
																													  o.lmap.zw = 0;
																													#endif
																													#ifdef LIGHTMAP_ON
																													  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
																													  #ifdef DIRLIGHTMAP_OFF
																														o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
																														o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
																													  #endif
																													#else
																													  o.lmap.xy = 0;
																														#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																														  o.sh = 0;
																														  o.sh = ShadeSHPerVertex(worldNormal, o.sh);
																														#endif
																													#endif
																													  return o;
																													}
																													#ifdef LIGHTMAP_ON
																													float4 unity_LightmapFade;
																													#endif
																													fixed4 unity_Ambient;

																													// fragment shader
																													void frag_surf(v2f_surf IN,
																														out half4 outGBuffer0 : SV_Target0,
																														out half4 outGBuffer1 : SV_Target1,
																														out half4 outGBuffer2 : SV_Target2,
																														out half4 outEmission : SV_Target3
																													#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
																														, out half4 outShadowMask : SV_Target4
																													#endif
																													) {
																													  UNITY_SETUP_INSTANCE_ID(IN);
																													  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																													  // prepare and unpack data
																													  Input surfIN;
																													  #ifdef FOG_COMBINED_WITH_TSPACE
																														UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																													  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																														UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																													  #else
																														UNITY_EXTRACT_FOG(IN);
																													  #endif
																													  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																													  surfIN.uv_texcoord.x = 1.0;
																													  surfIN.screenPosition.x = 1.0;
																													  surfIN.uv_texcoord = IN.pack0.xy;
																													  surfIN.screenPosition = IN.custompack0.xyzw;
																													  float3 worldPos = IN.worldPos.xyz;
																													  #ifndef USING_DIRECTIONAL_LIGHT
																														fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																													  #else
																														fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																													  #endif
																													  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
																													  #ifdef UNITY_COMPILER_HLSL
																													  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																													  #else
																													  SurfaceOutputStandard o;
																													  #endif
																													  o.Albedo = 0.0;
																													  o.Emission = 0.0;
																													  o.Alpha = 0.0;
																													  o.Occlusion = 1.0;
																													  fixed3 normalWorldVertex = fixed3(0,0,1);
																													  o.Normal = IN.worldNormal;
																													  normalWorldVertex = IN.worldNormal;

																													  // call surface function
																													  surf(surfIN, o);
																													  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																													fixed3 originalNormal = o.Normal;
																													  half atten = 1;

																													  // Setup lighting environment
																													  UnityGI gi;
																													  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
																													  gi.indirect.diffuse = 0;
																													  gi.indirect.specular = 0;
																													  gi.light.color = 0;
																													  gi.light.dir = half3(0,1,0);
																													  // Call GI (lightmaps/SH/reflections) lighting function
																													  UnityGIInput giInput;
																													  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
																													  giInput.light = gi.light;
																													  giInput.worldPos = worldPos;
																													  giInput.worldViewDir = worldViewDir;
																													  giInput.atten = atten;
																													  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
																														giInput.lightmapUV = IN.lmap;
																													  #else
																														giInput.lightmapUV = 0.0;
																													  #endif
																													  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
																														giInput.ambient = IN.sh;
																													  #else
																														giInput.ambient.rgb = 0.0;
																													  #endif
																													  giInput.probeHDR[0] = unity_SpecCube0_HDR;
																													  giInput.probeHDR[1] = unity_SpecCube1_HDR;
																													  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
																														giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
																													  #endif
																													  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
																														giInput.boxMax[0] = unity_SpecCube0_BoxMax;
																														giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
																														giInput.boxMax[1] = unity_SpecCube1_BoxMax;
																														giInput.boxMin[1] = unity_SpecCube1_BoxMin;
																														giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
																													  #endif
																													  LightingStandard_GI(o, giInput, gi);

																													  // call lighting function to output g-buffer
																													  outEmission = LightingStandard_Deferred(o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
																													  #if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
																														outShadowMask = UnityGetRawBakedOcclusions(IN.lmap.xy, worldPos);
																													  #endif
																													  #ifndef UNITY_HDR_ON
																													  outEmission.rgb = exp2(-outEmission.rgb);
																													  #endif
																													}


																													#endif


																													ENDCG

																													}

																					// ---- shadow caster pass:
																					Pass {
																						Name "ShadowCaster"
																						Tags { "LightMode" = "ShadowCaster" }
																						ZWrite On ZTest LEqual

																				CGPROGRAM
																														// compile directives
																														#pragma vertex vert_surf
																														#pragma fragment frag_surf
																														#pragma target 3.0
																														#pragma multi_compile_instancing
																														#pragma multi_compile __ LOD_FADE_CROSSFADE
																														#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
																														#pragma multi_compile_shadowcaster
																														#include "HLSLSupport.cginc"
																														#define UNITY_INSTANCED_LOD_FADE
																														#define UNITY_INSTANCED_SH
																														#define UNITY_INSTANCED_LIGHTMAPSTS
																														#include "UnityShaderVariables.cginc"
																														#include "UnityShaderUtilities.cginc"
																														// -------- variant for: <when no other keywords are defined>
																														#if !defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
																														// Surface shader code generated based on:
																														// vertex modifier: 'vertexDataFunc'
																														// writes to per-pixel normal: no
																														// writes to emission: no
																														// writes to occlusion: no
																														// needs world space reflection vector: no
																														// needs world space normal vector: no
																														// needs screen space position: no
																														// needs world space position: no
																														// needs view direction: no
																														// needs world space view direction: no
																														// needs world space position for lighting: YES
																														// needs world space view direction for lighting: YES
																														// needs world space view direction for lightmaps: no
																														// needs vertex color: no
																														// needs VFACE: no
																														// needs SV_IsFrontFace: no
																														// passes tangent-to-world matrix to pixel shader: no
																														// reads from normal: no
																														// 0 texcoords actually used
																														#include "UnityCG.cginc"
																														#include "Lighting.cginc"
																														#include "UnityPBSLighting.cginc"

																														#define INTERNAL_DATA
																														#define WorldReflectionVector(data,normal) data.worldRefl
																														#define WorldNormalVector(data,normal) normal

																														// Original surface shader snippet:
																														#line 19 ""
																														#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																														#endif
																														/* UNITY: Original start of shader */
																																#include "UnityShaderVariables.cginc"
																																//#pragma target 3.0
																																//#pragma multi_compile_instancing
																																//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																																struct Input
																																{
																																	float2 uv_texcoord;
																																	float4 screenPosition;
																																};

																																uniform sampler2D _MainTexture;
																																uniform float4 _ReplaceKey;
																																uniform float _Cutoff = 0;

																																UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																																	UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																														#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																																	UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																														#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																																UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																																inline float Dither8x8Bayer(int x, int y)
																																{
																																	const float dither[64] = {
																																		 1, 49, 13, 61,  4, 52, 16, 64,
																																		33, 17, 45, 29, 36, 20, 48, 32,
																																		 9, 57,  5, 53, 12, 60,  8, 56,
																																		41, 25, 37, 21, 44, 28, 40, 24,
																																		 3, 51, 15, 63,  2, 50, 14, 62,
																																		35, 19, 47, 31, 34, 18, 46, 30,
																																		11, 59,  7, 55, 10, 58,  6, 54,
																																		43, 27, 39, 23, 42, 26, 38, 22};
																																	int r = y * 8 + x;
																																	return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																																}


																																void vertexDataFunc(inout appdata_full v, out Input o)
																																{
																																	UNITY_INITIALIZE_OUTPUT(Input, o);
																																	float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																																	o.screenPosition = ase_screenPos;
																																}

																																void surf(Input i , inout SurfaceOutputStandard o)
																																{
																																	float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																																	float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																																	float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																																	float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																																	o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																																	o.Alpha = 1;
																																	float4 ase_screenPos = i.screenPosition;
																																	float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																																	ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																																	float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																																	float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																																	clip(dither19 - _Cutoff);
																																}



																																// vertex-to-fragment interpolation data
																																struct v2f_surf {
																																  V2F_SHADOW_CASTER;
																																  float3 worldPos : TEXCOORD1;
																																  float4 custompack0 : TEXCOORD2; // screenPosition
																																  UNITY_VERTEX_INPUT_INSTANCE_ID
																																  UNITY_VERTEX_OUTPUT_STEREO
																																};

																																// vertex shader
																																v2f_surf vert_surf(appdata_full v) {
																																  UNITY_SETUP_INSTANCE_ID(v);
																																  v2f_surf o;
																																  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																																  UNITY_TRANSFER_INSTANCE_ID(v,o);
																																  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																																  Input customInputData;
																																  vertexDataFunc(v, customInputData);
																																  o.custompack0.xyzw = customInputData.screenPosition;
																																  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																																  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																																  o.worldPos.xyz = worldPos;
																																  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
																																  return o;
																																}

																																// fragment shader
																																fixed4 frag_surf(v2f_surf IN) : SV_Target {
																																  UNITY_SETUP_INSTANCE_ID(IN);
																																  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																																  // prepare and unpack data
																																  Input surfIN;
																																  #ifdef FOG_COMBINED_WITH_TSPACE
																																	UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																																  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																																	UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																																  #else
																																	UNITY_EXTRACT_FOG(IN);
																																  #endif
																																  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																																  surfIN.uv_texcoord.x = 1.0;
																																  surfIN.screenPosition.x = 1.0;
																																  surfIN.screenPosition = IN.custompack0.xyzw;
																																  float3 worldPos = IN.worldPos.xyz;
																																  #ifndef USING_DIRECTIONAL_LIGHT
																																	fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																																  #else
																																	fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																																  #endif
																																  #ifdef UNITY_COMPILER_HLSL
																																  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																																  #else
																																  SurfaceOutputStandard o;
																																  #endif
																																  o.Albedo = 0.0;
																																  o.Emission = 0.0;
																																  o.Alpha = 0.0;
																																  o.Occlusion = 1.0;
																																  fixed3 normalWorldVertex = fixed3(0,0,1);

																																  // call surface function
																																  surf(surfIN, o);
																																  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																																  SHADOW_CASTER_FRAGMENT(IN)
																																}


																																#endif

																																	// -------- variant for: INSTANCING_ON 
																																	#if defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
																																	// Surface shader code generated based on:
																																	// vertex modifier: 'vertexDataFunc'
																																	// writes to per-pixel normal: no
																																	// writes to emission: no
																																	// writes to occlusion: no
																																	// needs world space reflection vector: no
																																	// needs world space normal vector: no
																																	// needs screen space position: no
																																	// needs world space position: no
																																	// needs view direction: no
																																	// needs world space view direction: no
																																	// needs world space position for lighting: YES
																																	// needs world space view direction for lighting: YES
																																	// needs world space view direction for lightmaps: no
																																	// needs vertex color: no
																																	// needs VFACE: no
																																	// needs SV_IsFrontFace: no
																																	// passes tangent-to-world matrix to pixel shader: no
																																	// reads from normal: no
																																	// 0 texcoords actually used
																																	#include "UnityCG.cginc"
																																	#include "Lighting.cginc"
																																	#include "UnityPBSLighting.cginc"

																																	#define INTERNAL_DATA
																																	#define WorldReflectionVector(data,normal) data.worldRefl
																																	#define WorldNormalVector(data,normal) normal

																																	// Original surface shader snippet:
																																	#line 19 ""
																																	#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																																	#endif
																																	/* UNITY: Original start of shader */
																																			#include "UnityShaderVariables.cginc"
																																			//#pragma target 3.0
																																			//#pragma multi_compile_instancing
																																			//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																																			struct Input
																																			{
																																				float2 uv_texcoord;
																																				float4 screenPosition;
																																			};

																																			uniform sampler2D _MainTexture;
																																			uniform float4 _ReplaceKey;
																																			uniform float _Cutoff = 0;

																																			UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																																				UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																																	#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																																				UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																																	#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																																			UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																																			inline float Dither8x8Bayer(int x, int y)
																																			{
																																				const float dither[64] = {
																																					 1, 49, 13, 61,  4, 52, 16, 64,
																																					33, 17, 45, 29, 36, 20, 48, 32,
																																					 9, 57,  5, 53, 12, 60,  8, 56,
																																					41, 25, 37, 21, 44, 28, 40, 24,
																																					 3, 51, 15, 63,  2, 50, 14, 62,
																																					35, 19, 47, 31, 34, 18, 46, 30,
																																					11, 59,  7, 55, 10, 58,  6, 54,
																																					43, 27, 39, 23, 42, 26, 38, 22};
																																				int r = y * 8 + x;
																																				return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																																			}


																																			void vertexDataFunc(inout appdata_full v, out Input o)
																																			{
																																				UNITY_INITIALIZE_OUTPUT(Input, o);
																																				float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																																				o.screenPosition = ase_screenPos;
																																			}

																																			void surf(Input i , inout SurfaceOutputStandard o)
																																			{
																																				float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																																				float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																																				float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																																				float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																																				o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																																				o.Alpha = 1;
																																				float4 ase_screenPos = i.screenPosition;
																																				float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																																				ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																																				float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																																				float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																																				clip(dither19 - _Cutoff);
																																			}



																																			// vertex-to-fragment interpolation data
																																			struct v2f_surf {
																																			  V2F_SHADOW_CASTER;
																																			  float3 worldPos : TEXCOORD1;
																																			  float4 custompack0 : TEXCOORD2; // screenPosition
																																			  UNITY_VERTEX_INPUT_INSTANCE_ID
																																			  UNITY_VERTEX_OUTPUT_STEREO
																																			};

																																			// vertex shader
																																			v2f_surf vert_surf(appdata_full v) {
																																			  UNITY_SETUP_INSTANCE_ID(v);
																																			  v2f_surf o;
																																			  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																																			  UNITY_TRANSFER_INSTANCE_ID(v,o);
																																			  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																																			  Input customInputData;
																																			  vertexDataFunc(v, customInputData);
																																			  o.custompack0.xyzw = customInputData.screenPosition;
																																			  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																																			  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																																			  o.worldPos.xyz = worldPos;
																																			  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
																																			  return o;
																																			}

																																			// fragment shader
																																			fixed4 frag_surf(v2f_surf IN) : SV_Target {
																																			  UNITY_SETUP_INSTANCE_ID(IN);
																																			  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																																			  // prepare and unpack data
																																			  Input surfIN;
																																			  #ifdef FOG_COMBINED_WITH_TSPACE
																																				UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																																			  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																																				UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																																			  #else
																																				UNITY_EXTRACT_FOG(IN);
																																			  #endif
																																			  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																																			  surfIN.uv_texcoord.x = 1.0;
																																			  surfIN.screenPosition.x = 1.0;
																																			  surfIN.screenPosition = IN.custompack0.xyzw;
																																			  float3 worldPos = IN.worldPos.xyz;
																																			  #ifndef USING_DIRECTIONAL_LIGHT
																																				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																																			  #else
																																				fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																																			  #endif
																																			  #ifdef UNITY_COMPILER_HLSL
																																			  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																																			  #else
																																			  SurfaceOutputStandard o;
																																			  #endif
																																			  o.Albedo = 0.0;
																																			  o.Emission = 0.0;
																																			  o.Alpha = 0.0;
																																			  o.Occlusion = 1.0;
																																			  fixed3 normalWorldVertex = fixed3(0,0,1);

																																			  // call surface function
																																			  surf(surfIN, o);
																																			  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																																			  SHADOW_CASTER_FRAGMENT(IN)
																																			}


																																			#endif

																																				// -------- variant for: LOD_FADE_CROSSFADE 
																																				#if defined(LOD_FADE_CROSSFADE) && !defined(INSTANCING_ON)
																																				// Surface shader code generated based on:
																																				// vertex modifier: 'vertexDataFunc'
																																				// writes to per-pixel normal: no
																																				// writes to emission: no
																																				// writes to occlusion: no
																																				// needs world space reflection vector: no
																																				// needs world space normal vector: no
																																				// needs screen space position: no
																																				// needs world space position: no
																																				// needs view direction: no
																																				// needs world space view direction: no
																																				// needs world space position for lighting: YES
																																				// needs world space view direction for lighting: YES
																																				// needs world space view direction for lightmaps: no
																																				// needs vertex color: no
																																				// needs VFACE: no
																																				// needs SV_IsFrontFace: no
																																				// passes tangent-to-world matrix to pixel shader: no
																																				// reads from normal: no
																																				// 0 texcoords actually used
																																				#include "UnityCG.cginc"
																																				#include "Lighting.cginc"
																																				#include "UnityPBSLighting.cginc"

																																				#define INTERNAL_DATA
																																				#define WorldReflectionVector(data,normal) data.worldRefl
																																				#define WorldNormalVector(data,normal) normal

																																				// Original surface shader snippet:
																																				#line 19 ""
																																				#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																																				#endif
																																				/* UNITY: Original start of shader */
																																						#include "UnityShaderVariables.cginc"
																																						//#pragma target 3.0
																																						//#pragma multi_compile_instancing
																																						//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																																						struct Input
																																						{
																																							float2 uv_texcoord;
																																							float4 screenPosition;
																																						};

																																						uniform sampler2D _MainTexture;
																																						uniform float4 _ReplaceKey;
																																						uniform float _Cutoff = 0;

																																						UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																																							UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																																				#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																																							UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																																				#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																																						UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																																						inline float Dither8x8Bayer(int x, int y)
																																						{
																																							const float dither[64] = {
																																								 1, 49, 13, 61,  4, 52, 16, 64,
																																								33, 17, 45, 29, 36, 20, 48, 32,
																																								 9, 57,  5, 53, 12, 60,  8, 56,
																																								41, 25, 37, 21, 44, 28, 40, 24,
																																								 3, 51, 15, 63,  2, 50, 14, 62,
																																								35, 19, 47, 31, 34, 18, 46, 30,
																																								11, 59,  7, 55, 10, 58,  6, 54,
																																								43, 27, 39, 23, 42, 26, 38, 22};
																																							int r = y * 8 + x;
																																							return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																																						}


																																						void vertexDataFunc(inout appdata_full v, out Input o)
																																						{
																																							UNITY_INITIALIZE_OUTPUT(Input, o);
																																							float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																																							o.screenPosition = ase_screenPos;
																																						}

																																						void surf(Input i , inout SurfaceOutputStandard o)
																																						{
																																							float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																																							float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																																							float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																																							float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																																							o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																																							o.Alpha = 1;
																																							float4 ase_screenPos = i.screenPosition;
																																							float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																																							ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																																							float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																																							float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																																							clip(dither19 - _Cutoff);
																																						}



																																						// vertex-to-fragment interpolation data
																																						struct v2f_surf {
																																						  V2F_SHADOW_CASTER;
																																						  float3 worldPos : TEXCOORD1;
																																						  float4 custompack0 : TEXCOORD2; // screenPosition
																																						  UNITY_VERTEX_INPUT_INSTANCE_ID
																																						  UNITY_VERTEX_OUTPUT_STEREO
																																						};

																																						// vertex shader
																																						v2f_surf vert_surf(appdata_full v) {
																																						  UNITY_SETUP_INSTANCE_ID(v);
																																						  v2f_surf o;
																																						  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																																						  UNITY_TRANSFER_INSTANCE_ID(v,o);
																																						  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																																						  Input customInputData;
																																						  vertexDataFunc(v, customInputData);
																																						  o.custompack0.xyzw = customInputData.screenPosition;
																																						  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																																						  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																																						  o.worldPos.xyz = worldPos;
																																						  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
																																						  return o;
																																						}

																																						// fragment shader
																																						fixed4 frag_surf(v2f_surf IN) : SV_Target {
																																						  UNITY_SETUP_INSTANCE_ID(IN);
																																						  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																																						  // prepare and unpack data
																																						  Input surfIN;
																																						  #ifdef FOG_COMBINED_WITH_TSPACE
																																							UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																																						  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																																							UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																																						  #else
																																							UNITY_EXTRACT_FOG(IN);
																																						  #endif
																																						  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																																						  surfIN.uv_texcoord.x = 1.0;
																																						  surfIN.screenPosition.x = 1.0;
																																						  surfIN.screenPosition = IN.custompack0.xyzw;
																																						  float3 worldPos = IN.worldPos.xyz;
																																						  #ifndef USING_DIRECTIONAL_LIGHT
																																							fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																																						  #else
																																							fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																																						  #endif
																																						  #ifdef UNITY_COMPILER_HLSL
																																						  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																																						  #else
																																						  SurfaceOutputStandard o;
																																						  #endif
																																						  o.Albedo = 0.0;
																																						  o.Emission = 0.0;
																																						  o.Alpha = 0.0;
																																						  o.Occlusion = 1.0;
																																						  fixed3 normalWorldVertex = fixed3(0,0,1);

																																						  // call surface function
																																						  surf(surfIN, o);
																																						  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																																						  SHADOW_CASTER_FRAGMENT(IN)
																																						}


																																						#endif

																																							// -------- variant for: LOD_FADE_CROSSFADE INSTANCING_ON 
																																							#if defined(LOD_FADE_CROSSFADE) && defined(INSTANCING_ON)
																																							// Surface shader code generated based on:
																																							// vertex modifier: 'vertexDataFunc'
																																							// writes to per-pixel normal: no
																																							// writes to emission: no
																																							// writes to occlusion: no
																																							// needs world space reflection vector: no
																																							// needs world space normal vector: no
																																							// needs screen space position: no
																																							// needs world space position: no
																																							// needs view direction: no
																																							// needs world space view direction: no
																																							// needs world space position for lighting: YES
																																							// needs world space view direction for lighting: YES
																																							// needs world space view direction for lightmaps: no
																																							// needs vertex color: no
																																							// needs VFACE: no
																																							// needs SV_IsFrontFace: no
																																							// passes tangent-to-world matrix to pixel shader: no
																																							// reads from normal: no
																																							// 0 texcoords actually used
																																							#include "UnityCG.cginc"
																																							#include "Lighting.cginc"
																																							#include "UnityPBSLighting.cginc"

																																							#define INTERNAL_DATA
																																							#define WorldReflectionVector(data,normal) data.worldRefl
																																							#define WorldNormalVector(data,normal) normal

																																							// Original surface shader snippet:
																																							#line 19 ""
																																							#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																																							#endif
																																							/* UNITY: Original start of shader */
																																									#include "UnityShaderVariables.cginc"
																																									//#pragma target 3.0
																																									//#pragma multi_compile_instancing
																																									//#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																																									struct Input
																																									{
																																										float2 uv_texcoord;
																																										float4 screenPosition;
																																									};

																																									uniform sampler2D _MainTexture;
																																									uniform float4 _ReplaceKey;
																																									uniform float _Cutoff = 0;

																																									UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																																										UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																																							#define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																																										UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																																							#define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																																									UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																																									inline float Dither8x8Bayer(int x, int y)
																																									{
																																										const float dither[64] = {
																																											 1, 49, 13, 61,  4, 52, 16, 64,
																																											33, 17, 45, 29, 36, 20, 48, 32,
																																											 9, 57,  5, 53, 12, 60,  8, 56,
																																											41, 25, 37, 21, 44, 28, 40, 24,
																																											 3, 51, 15, 63,  2, 50, 14, 62,
																																											35, 19, 47, 31, 34, 18, 46, 30,
																																											11, 59,  7, 55, 10, 58,  6, 54,
																																											43, 27, 39, 23, 42, 26, 38, 22};
																																										int r = y * 8 + x;
																																										return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																																									}


																																									void vertexDataFunc(inout appdata_full v, out Input o)
																																									{
																																										UNITY_INITIALIZE_OUTPUT(Input, o);
																																										float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																																										o.screenPosition = ase_screenPos;
																																									}

																																									void surf(Input i , inout SurfaceOutputStandard o)
																																									{
																																										float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																																										float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																																										float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																																										float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																																										o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																																										o.Alpha = 1;
																																										float4 ase_screenPos = i.screenPosition;
																																										float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																																										ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																																										float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																																										float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																																										clip(dither19 - _Cutoff);
																																									}



																																									// vertex-to-fragment interpolation data
																																									struct v2f_surf {
																																									  V2F_SHADOW_CASTER;
																																									  float3 worldPos : TEXCOORD1;
																																									  float4 custompack0 : TEXCOORD2; // screenPosition
																																									  UNITY_VERTEX_INPUT_INSTANCE_ID
																																									  UNITY_VERTEX_OUTPUT_STEREO
																																									};

																																									// vertex shader
																																									v2f_surf vert_surf(appdata_full v) {
																																									  UNITY_SETUP_INSTANCE_ID(v);
																																									  v2f_surf o;
																																									  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																																									  UNITY_TRANSFER_INSTANCE_ID(v,o);
																																									  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																																									  Input customInputData;
																																									  vertexDataFunc(v, customInputData);
																																									  o.custompack0.xyzw = customInputData.screenPosition;
																																									  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																																									  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																																									  o.worldPos.xyz = worldPos;
																																									  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
																																									  return o;
																																									}

																																									// fragment shader
																																									fixed4 frag_surf(v2f_surf IN) : SV_Target {
																																									  UNITY_SETUP_INSTANCE_ID(IN);
																																									  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																																									  // prepare and unpack data
																																									  Input surfIN;
																																									  #ifdef FOG_COMBINED_WITH_TSPACE
																																										UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																																									  #elif defined (FOG_COMBINED_WITH_WORLD_POS)
																																										UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																																									  #else
																																										UNITY_EXTRACT_FOG(IN);
																																									  #endif
																																									  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																																									  surfIN.uv_texcoord.x = 1.0;
																																									  surfIN.screenPosition.x = 1.0;
																																									  surfIN.screenPosition = IN.custompack0.xyzw;
																																									  float3 worldPos = IN.worldPos.xyz;
																																									  #ifndef USING_DIRECTIONAL_LIGHT
																																										fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																																									  #else
																																										fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																																									  #endif
																																									  #ifdef UNITY_COMPILER_HLSL
																																									  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																																									  #else
																																									  SurfaceOutputStandard o;
																																									  #endif
																																									  o.Albedo = 0.0;
																																									  o.Emission = 0.0;
																																									  o.Alpha = 0.0;
																																									  o.Occlusion = 1.0;
																																									  fixed3 normalWorldVertex = fixed3(0,0,1);

																																									  // call surface function
																																									  surf(surfIN, o);
																																									  UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																																									  SHADOW_CASTER_FRAGMENT(IN)
																																									}


																																									#endif


																																									ENDCG

																																									}

																														// ---- meta information extraction pass:
																														Pass {
																															Name "Meta"
																															Tags { "LightMode" = "Meta" }
																															Cull Off

																													CGPROGRAM
																																										  // compile directives
																																										  #pragma vertex vert_surf
																																										  #pragma fragment frag_surf
																																										  #pragma target 3.0
																																										  #pragma multi_compile_instancing
																																										  #pragma multi_compile __ LOD_FADE_CROSSFADE
																																										  #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
																																										  #pragma shader_feature EDITOR_VISUALIZATION

																																										  #include "HLSLSupport.cginc"
																																										  #define UNITY_INSTANCED_LOD_FADE
																																										  #define UNITY_INSTANCED_SH
																																										  #define UNITY_INSTANCED_LIGHTMAPSTS
																																										  #include "UnityShaderVariables.cginc"
																																										  #include "UnityShaderUtilities.cginc"
																																										  // -------- variant for: <when no other keywords are defined>
																																										  #if !defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
																																										  // Surface shader code generated based on:
																																										  // vertex modifier: 'vertexDataFunc'
																																										  // writes to per-pixel normal: no
																																										  // writes to emission: no
																																										  // writes to occlusion: no
																																										  // needs world space reflection vector: no
																																										  // needs world space normal vector: no
																																										  // needs screen space position: no
																																										  // needs world space position: no
																																										  // needs view direction: no
																																										  // needs world space view direction: no
																																										  // needs world space position for lighting: YES
																																										  // needs world space view direction for lighting: YES
																																										  // needs world space view direction for lightmaps: no
																																										  // needs vertex color: no
																																										  // needs VFACE: no
																																										  // needs SV_IsFrontFace: no
																																										  // passes tangent-to-world matrix to pixel shader: no
																																										  // reads from normal: no
																																										  // 1 texcoords actually used
																																										  //   float2 _texcoord
																																										  #include "UnityCG.cginc"
																																										  #include "Lighting.cginc"
																																										  #include "UnityPBSLighting.cginc"

																																										  #define INTERNAL_DATA
																																										  #define WorldReflectionVector(data,normal) data.worldRefl
																																										  #define WorldNormalVector(data,normal) normal

																																										  // Original surface shader snippet:
																																										  #line 19 ""
																																										  #ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																																										  #endif
																																										  /* UNITY: Original start of shader */
																																												  #include "UnityShaderVariables.cginc"
																																												  //#pragma target 3.0
																																												  //#pragma multi_compile_instancing
																																												  //#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																																												  struct Input
																																												  {
																																													  float2 uv_texcoord;
																																													  float4 screenPosition;
																																												  };

																																												  uniform sampler2D _MainTexture;
																																												  uniform float4 _ReplaceKey;
																																												  uniform float _Cutoff = 0;

																																												  UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																																													  UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																																										  #define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																																													  UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																																										  #define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																																												  UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																																												  inline float Dither8x8Bayer(int x, int y)
																																												  {
																																													  const float dither[64] = {
																																														   1, 49, 13, 61,  4, 52, 16, 64,
																																														  33, 17, 45, 29, 36, 20, 48, 32,
																																														   9, 57,  5, 53, 12, 60,  8, 56,
																																														  41, 25, 37, 21, 44, 28, 40, 24,
																																														   3, 51, 15, 63,  2, 50, 14, 62,
																																														  35, 19, 47, 31, 34, 18, 46, 30,
																																														  11, 59,  7, 55, 10, 58,  6, 54,
																																														  43, 27, 39, 23, 42, 26, 38, 22};
																																													  int r = y * 8 + x;
																																													  return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																																												  }


																																												  void vertexDataFunc(inout appdata_full v, out Input o)
																																												  {
																																													  UNITY_INITIALIZE_OUTPUT(Input, o);
																																													  float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																																													  o.screenPosition = ase_screenPos;
																																												  }

																																												  void surf(Input i , inout SurfaceOutputStandard o)
																																												  {
																																													  float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																																													  float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																																													  float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																																													  float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																																													  o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																																													  o.Alpha = 1;
																																													  float4 ase_screenPos = i.screenPosition;
																																													  float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																																													  ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																																													  float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																																													  float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																																													  clip(dither19 - _Cutoff);
																																												  }


																																										  #include "UnityMetaPass.cginc"

																																												  // vertex-to-fragment interpolation data
																																												  struct v2f_surf {
																																													UNITY_POSITION(pos);
																																													float2 pack0 : TEXCOORD0; // _texcoord
																																													float3 worldPos : TEXCOORD1;
																																													float4 custompack0 : TEXCOORD2; // screenPosition
																																												  #ifdef EDITOR_VISUALIZATION
																																													float2 vizUV : TEXCOORD3;
																																													float4 lightCoord : TEXCOORD4;
																																												  #endif
																																													UNITY_VERTEX_INPUT_INSTANCE_ID
																																													UNITY_VERTEX_OUTPUT_STEREO
																																												  };
																																												  float4 _texcoord_ST;

																																												  // vertex shader
																																												  v2f_surf vert_surf(appdata_full v) {
																																													UNITY_SETUP_INSTANCE_ID(v);
																																													v2f_surf o;
																																													UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																																													UNITY_TRANSFER_INSTANCE_ID(v,o);
																																													UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																																													Input customInputData;
																																													vertexDataFunc(v, customInputData);
																																													o.custompack0.xyzw = customInputData.screenPosition;
																																													o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
																																												  #ifdef EDITOR_VISUALIZATION
																																													o.vizUV = 0;
																																													o.lightCoord = 0;
																																													if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
																																													  o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
																																													else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
																																													{
																																													  o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
																																													  o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
																																													}
																																												  #endif
																																													o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																																													float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																																													float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																																													o.worldPos.xyz = worldPos;
																																													return o;
																																												  }

																																												  // fragment shader
																																												  fixed4 frag_surf(v2f_surf IN) : SV_Target {
																																													UNITY_SETUP_INSTANCE_ID(IN);
																																													UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																																													// prepare and unpack data
																																													Input surfIN;
																																													#ifdef FOG_COMBINED_WITH_TSPACE
																																													  UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																																													#elif defined (FOG_COMBINED_WITH_WORLD_POS)
																																													  UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																																													#else
																																													  UNITY_EXTRACT_FOG(IN);
																																													#endif
																																													UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																																													surfIN.uv_texcoord.x = 1.0;
																																													surfIN.screenPosition.x = 1.0;
																																													surfIN.uv_texcoord = IN.pack0.xy;
																																													surfIN.screenPosition = IN.custompack0.xyzw;
																																													float3 worldPos = IN.worldPos.xyz;
																																													#ifndef USING_DIRECTIONAL_LIGHT
																																													  fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																																													#else
																																													  fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																																													#endif
																																													#ifdef UNITY_COMPILER_HLSL
																																													SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																																													#else
																																													SurfaceOutputStandard o;
																																													#endif
																																													o.Albedo = 0.0;
																																													o.Emission = 0.0;
																																													o.Alpha = 0.0;
																																													o.Occlusion = 1.0;
																																													fixed3 normalWorldVertex = fixed3(0,0,1);

																																													// call surface function
																																													surf(surfIN, o);
																																													UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																																													UnityMetaInput metaIN;
																																													UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
																																													metaIN.Albedo = o.Albedo;
																																													metaIN.Emission = o.Emission;
																																												  #ifdef EDITOR_VISUALIZATION
																																													metaIN.VizUV = IN.vizUV;
																																													metaIN.LightCoord = IN.lightCoord;
																																												  #endif
																																													return UnityMetaFragment(metaIN);
																																												  }


																																												  #endif

																																													  // -------- variant for: INSTANCING_ON 
																																													  #if defined(INSTANCING_ON) && !defined(LOD_FADE_CROSSFADE)
																																													  // Surface shader code generated based on:
																																													  // vertex modifier: 'vertexDataFunc'
																																													  // writes to per-pixel normal: no
																																													  // writes to emission: no
																																													  // writes to occlusion: no
																																													  // needs world space reflection vector: no
																																													  // needs world space normal vector: no
																																													  // needs screen space position: no
																																													  // needs world space position: no
																																													  // needs view direction: no
																																													  // needs world space view direction: no
																																													  // needs world space position for lighting: YES
																																													  // needs world space view direction for lighting: YES
																																													  // needs world space view direction for lightmaps: no
																																													  // needs vertex color: no
																																													  // needs VFACE: no
																																													  // needs SV_IsFrontFace: no
																																													  // passes tangent-to-world matrix to pixel shader: no
																																													  // reads from normal: no
																																													  // 1 texcoords actually used
																																													  //   float2 _texcoord
																																													  #include "UnityCG.cginc"
																																													  #include "Lighting.cginc"
																																													  #include "UnityPBSLighting.cginc"

																																													  #define INTERNAL_DATA
																																													  #define WorldReflectionVector(data,normal) data.worldRefl
																																													  #define WorldNormalVector(data,normal) normal

																																													  // Original surface shader snippet:
																																													  #line 19 ""
																																													  #ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																																													  #endif
																																													  /* UNITY: Original start of shader */
																																															  #include "UnityShaderVariables.cginc"
																																															  //#pragma target 3.0
																																															  //#pragma multi_compile_instancing
																																															  //#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																																															  struct Input
																																															  {
																																																  float2 uv_texcoord;
																																																  float4 screenPosition;
																																															  };

																																															  uniform sampler2D _MainTexture;
																																															  uniform float4 _ReplaceKey;
																																															  uniform float _Cutoff = 0;

																																															  UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																																																  UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																																													  #define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																																																  UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																																													  #define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																																															  UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																																															  inline float Dither8x8Bayer(int x, int y)
																																															  {
																																																  const float dither[64] = {
																																																	   1, 49, 13, 61,  4, 52, 16, 64,
																																																	  33, 17, 45, 29, 36, 20, 48, 32,
																																																	   9, 57,  5, 53, 12, 60,  8, 56,
																																																	  41, 25, 37, 21, 44, 28, 40, 24,
																																																	   3, 51, 15, 63,  2, 50, 14, 62,
																																																	  35, 19, 47, 31, 34, 18, 46, 30,
																																																	  11, 59,  7, 55, 10, 58,  6, 54,
																																																	  43, 27, 39, 23, 42, 26, 38, 22};
																																																  int r = y * 8 + x;
																																																  return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																																															  }


																																															  void vertexDataFunc(inout appdata_full v, out Input o)
																																															  {
																																																  UNITY_INITIALIZE_OUTPUT(Input, o);
																																																  float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																																																  o.screenPosition = ase_screenPos;
																																															  }

																																															  void surf(Input i , inout SurfaceOutputStandard o)
																																															  {
																																																  float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																																																  float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																																																  float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																																																  float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																																																  o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																																																  o.Alpha = 1;
																																																  float4 ase_screenPos = i.screenPosition;
																																																  float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																																																  ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																																																  float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																																																  float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																																																  clip(dither19 - _Cutoff);
																																															  }


																																													  #include "UnityMetaPass.cginc"

																																															  // vertex-to-fragment interpolation data
																																															  struct v2f_surf {
																																																UNITY_POSITION(pos);
																																																float2 pack0 : TEXCOORD0; // _texcoord
																																																float3 worldPos : TEXCOORD1;
																																																float4 custompack0 : TEXCOORD2; // screenPosition
																																															  #ifdef EDITOR_VISUALIZATION
																																																float2 vizUV : TEXCOORD3;
																																																float4 lightCoord : TEXCOORD4;
																																															  #endif
																																																UNITY_VERTEX_INPUT_INSTANCE_ID
																																																UNITY_VERTEX_OUTPUT_STEREO
																																															  };
																																															  float4 _texcoord_ST;

																																															  // vertex shader
																																															  v2f_surf vert_surf(appdata_full v) {
																																																UNITY_SETUP_INSTANCE_ID(v);
																																																v2f_surf o;
																																																UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																																																UNITY_TRANSFER_INSTANCE_ID(v,o);
																																																UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																																																Input customInputData;
																																																vertexDataFunc(v, customInputData);
																																																o.custompack0.xyzw = customInputData.screenPosition;
																																																o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
																																															  #ifdef EDITOR_VISUALIZATION
																																																o.vizUV = 0;
																																																o.lightCoord = 0;
																																																if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
																																																  o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
																																																else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
																																																{
																																																  o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
																																																  o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
																																																}
																																															  #endif
																																																o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																																																float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																																																float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																																																o.worldPos.xyz = worldPos;
																																																return o;
																																															  }

																																															  // fragment shader
																																															  fixed4 frag_surf(v2f_surf IN) : SV_Target {
																																																UNITY_SETUP_INSTANCE_ID(IN);
																																																UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																																																// prepare and unpack data
																																																Input surfIN;
																																																#ifdef FOG_COMBINED_WITH_TSPACE
																																																  UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																																																#elif defined (FOG_COMBINED_WITH_WORLD_POS)
																																																  UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																																																#else
																																																  UNITY_EXTRACT_FOG(IN);
																																																#endif
																																																UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																																																surfIN.uv_texcoord.x = 1.0;
																																																surfIN.screenPosition.x = 1.0;
																																																surfIN.uv_texcoord = IN.pack0.xy;
																																																surfIN.screenPosition = IN.custompack0.xyzw;
																																																float3 worldPos = IN.worldPos.xyz;
																																																#ifndef USING_DIRECTIONAL_LIGHT
																																																  fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																																																#else
																																																  fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																																																#endif
																																																#ifdef UNITY_COMPILER_HLSL
																																																SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																																																#else
																																																SurfaceOutputStandard o;
																																																#endif
																																																o.Albedo = 0.0;
																																																o.Emission = 0.0;
																																																o.Alpha = 0.0;
																																																o.Occlusion = 1.0;
																																																fixed3 normalWorldVertex = fixed3(0,0,1);

																																																// call surface function
																																																surf(surfIN, o);
																																																UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																																																UnityMetaInput metaIN;
																																																UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
																																																metaIN.Albedo = o.Albedo;
																																																metaIN.Emission = o.Emission;
																																															  #ifdef EDITOR_VISUALIZATION
																																																metaIN.VizUV = IN.vizUV;
																																																metaIN.LightCoord = IN.lightCoord;
																																															  #endif
																																																return UnityMetaFragment(metaIN);
																																															  }


																																															  #endif

																																																  // -------- variant for: LOD_FADE_CROSSFADE 
																																																  #if defined(LOD_FADE_CROSSFADE) && !defined(INSTANCING_ON)
																																																  // Surface shader code generated based on:
																																																  // vertex modifier: 'vertexDataFunc'
																																																  // writes to per-pixel normal: no
																																																  // writes to emission: no
																																																  // writes to occlusion: no
																																																  // needs world space reflection vector: no
																																																  // needs world space normal vector: no
																																																  // needs screen space position: no
																																																  // needs world space position: no
																																																  // needs view direction: no
																																																  // needs world space view direction: no
																																																  // needs world space position for lighting: YES
																																																  // needs world space view direction for lighting: YES
																																																  // needs world space view direction for lightmaps: no
																																																  // needs vertex color: no
																																																  // needs VFACE: no
																																																  // needs SV_IsFrontFace: no
																																																  // passes tangent-to-world matrix to pixel shader: no
																																																  // reads from normal: no
																																																  // 1 texcoords actually used
																																																  //   float2 _texcoord
																																																  #include "UnityCG.cginc"
																																																  #include "Lighting.cginc"
																																																  #include "UnityPBSLighting.cginc"

																																																  #define INTERNAL_DATA
																																																  #define WorldReflectionVector(data,normal) data.worldRefl
																																																  #define WorldNormalVector(data,normal) normal

																																																  // Original surface shader snippet:
																																																  #line 19 ""
																																																  #ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																																																  #endif
																																																  /* UNITY: Original start of shader */
																																																		  #include "UnityShaderVariables.cginc"
																																																		  //#pragma target 3.0
																																																		  //#pragma multi_compile_instancing
																																																		  //#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																																																		  struct Input
																																																		  {
																																																			  float2 uv_texcoord;
																																																			  float4 screenPosition;
																																																		  };

																																																		  uniform sampler2D _MainTexture;
																																																		  uniform float4 _ReplaceKey;
																																																		  uniform float _Cutoff = 0;

																																																		  UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																																																			  UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																																																  #define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																																																			  UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																																																  #define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																																																		  UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																																																		  inline float Dither8x8Bayer(int x, int y)
																																																		  {
																																																			  const float dither[64] = {
																																																				   1, 49, 13, 61,  4, 52, 16, 64,
																																																				  33, 17, 45, 29, 36, 20, 48, 32,
																																																				   9, 57,  5, 53, 12, 60,  8, 56,
																																																				  41, 25, 37, 21, 44, 28, 40, 24,
																																																				   3, 51, 15, 63,  2, 50, 14, 62,
																																																				  35, 19, 47, 31, 34, 18, 46, 30,
																																																				  11, 59,  7, 55, 10, 58,  6, 54,
																																																				  43, 27, 39, 23, 42, 26, 38, 22};
																																																			  int r = y * 8 + x;
																																																			  return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																																																		  }


																																																		  void vertexDataFunc(inout appdata_full v, out Input o)
																																																		  {
																																																			  UNITY_INITIALIZE_OUTPUT(Input, o);
																																																			  float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																																																			  o.screenPosition = ase_screenPos;
																																																		  }

																																																		  void surf(Input i , inout SurfaceOutputStandard o)
																																																		  {
																																																			  float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																																																			  float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																																																			  float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																																																			  float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																																																			  o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																																																			  o.Alpha = 1;
																																																			  float4 ase_screenPos = i.screenPosition;
																																																			  float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																																																			  ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																																																			  float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																																																			  float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																																																			  clip(dither19 - _Cutoff);
																																																		  }


																																																  #include "UnityMetaPass.cginc"

																																																		  // vertex-to-fragment interpolation data
																																																		  struct v2f_surf {
																																																			UNITY_POSITION(pos);
																																																			float2 pack0 : TEXCOORD0; // _texcoord
																																																			float3 worldPos : TEXCOORD1;
																																																			float4 custompack0 : TEXCOORD2; // screenPosition
																																																		  #ifdef EDITOR_VISUALIZATION
																																																			float2 vizUV : TEXCOORD3;
																																																			float4 lightCoord : TEXCOORD4;
																																																		  #endif
																																																			UNITY_VERTEX_INPUT_INSTANCE_ID
																																																			UNITY_VERTEX_OUTPUT_STEREO
																																																		  };
																																																		  float4 _texcoord_ST;

																																																		  // vertex shader
																																																		  v2f_surf vert_surf(appdata_full v) {
																																																			UNITY_SETUP_INSTANCE_ID(v);
																																																			v2f_surf o;
																																																			UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																																																			UNITY_TRANSFER_INSTANCE_ID(v,o);
																																																			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																																																			Input customInputData;
																																																			vertexDataFunc(v, customInputData);
																																																			o.custompack0.xyzw = customInputData.screenPosition;
																																																			o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
																																																		  #ifdef EDITOR_VISUALIZATION
																																																			o.vizUV = 0;
																																																			o.lightCoord = 0;
																																																			if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
																																																			  o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
																																																			else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
																																																			{
																																																			  o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
																																																			  o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
																																																			}
																																																		  #endif
																																																			o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																																																			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																																																			float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																																																			o.worldPos.xyz = worldPos;
																																																			return o;
																																																		  }

																																																		  // fragment shader
																																																		  fixed4 frag_surf(v2f_surf IN) : SV_Target {
																																																			UNITY_SETUP_INSTANCE_ID(IN);
																																																			UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																																																			// prepare and unpack data
																																																			Input surfIN;
																																																			#ifdef FOG_COMBINED_WITH_TSPACE
																																																			  UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																																																			#elif defined (FOG_COMBINED_WITH_WORLD_POS)
																																																			  UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																																																			#else
																																																			  UNITY_EXTRACT_FOG(IN);
																																																			#endif
																																																			UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																																																			surfIN.uv_texcoord.x = 1.0;
																																																			surfIN.screenPosition.x = 1.0;
																																																			surfIN.uv_texcoord = IN.pack0.xy;
																																																			surfIN.screenPosition = IN.custompack0.xyzw;
																																																			float3 worldPos = IN.worldPos.xyz;
																																																			#ifndef USING_DIRECTIONAL_LIGHT
																																																			  fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																																																			#else
																																																			  fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																																																			#endif
																																																			#ifdef UNITY_COMPILER_HLSL
																																																			SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																																																			#else
																																																			SurfaceOutputStandard o;
																																																			#endif
																																																			o.Albedo = 0.0;
																																																			o.Emission = 0.0;
																																																			o.Alpha = 0.0;
																																																			o.Occlusion = 1.0;
																																																			fixed3 normalWorldVertex = fixed3(0,0,1);

																																																			// call surface function
																																																			surf(surfIN, o);
																																																			UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																																																			UnityMetaInput metaIN;
																																																			UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
																																																			metaIN.Albedo = o.Albedo;
																																																			metaIN.Emission = o.Emission;
																																																		  #ifdef EDITOR_VISUALIZATION
																																																			metaIN.VizUV = IN.vizUV;
																																																			metaIN.LightCoord = IN.lightCoord;
																																																		  #endif
																																																			return UnityMetaFragment(metaIN);
																																																		  }


																																																		  #endif

																																																			  // -------- variant for: LOD_FADE_CROSSFADE INSTANCING_ON 
																																																			  #if defined(LOD_FADE_CROSSFADE) && defined(INSTANCING_ON)
																																																			  // Surface shader code generated based on:
																																																			  // vertex modifier: 'vertexDataFunc'
																																																			  // writes to per-pixel normal: no
																																																			  // writes to emission: no
																																																			  // writes to occlusion: no
																																																			  // needs world space reflection vector: no
																																																			  // needs world space normal vector: no
																																																			  // needs screen space position: no
																																																			  // needs world space position: no
																																																			  // needs view direction: no
																																																			  // needs world space view direction: no
																																																			  // needs world space position for lighting: YES
																																																			  // needs world space view direction for lighting: YES
																																																			  // needs world space view direction for lightmaps: no
																																																			  // needs vertex color: no
																																																			  // needs VFACE: no
																																																			  // needs SV_IsFrontFace: no
																																																			  // passes tangent-to-world matrix to pixel shader: no
																																																			  // reads from normal: no
																																																			  // 1 texcoords actually used
																																																			  //   float2 _texcoord
																																																			  #include "UnityCG.cginc"
																																																			  #include "Lighting.cginc"
																																																			  #include "UnityPBSLighting.cginc"

																																																			  #define INTERNAL_DATA
																																																			  #define WorldReflectionVector(data,normal) data.worldRefl
																																																			  #define WorldNormalVector(data,normal) normal

																																																			  // Original surface shader snippet:
																																																			  #line 19 ""
																																																			  #ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
																																																			  #endif
																																																			  /* UNITY: Original start of shader */
																																																					  #include "UnityShaderVariables.cginc"
																																																					  //#pragma target 3.0
																																																					  //#pragma multi_compile_instancing
																																																					  //#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
																																																					  struct Input
																																																					  {
																																																						  float2 uv_texcoord;
																																																						  float4 screenPosition;
																																																					  };

																																																					  uniform sampler2D _MainTexture;
																																																					  uniform float4 _ReplaceKey;
																																																					  uniform float _Cutoff = 0;

																																																					  UNITY_INSTANCING_BUFFER_START(WobblyLifePlayerWobblyClothes)
																																																						  UNITY_DEFINE_INSTANCED_PROP(float4, _MainTexture_ST)
																																																			  #define _MainTexture_ST_arr WobblyLifePlayerWobblyClothes
																																																						  UNITY_DEFINE_INSTANCED_PROP(float4, _ReplaceColor)
																																																			  #define _ReplaceColor_arr WobblyLifePlayerWobblyClothes
																																																					  UNITY_INSTANCING_BUFFER_END(WobblyLifePlayerWobblyClothes)


																																																					  inline float Dither8x8Bayer(int x, int y)
																																																					  {
																																																						  const float dither[64] = {
																																																							   1, 49, 13, 61,  4, 52, 16, 64,
																																																							  33, 17, 45, 29, 36, 20, 48, 32,
																																																							   9, 57,  5, 53, 12, 60,  8, 56,
																																																							  41, 25, 37, 21, 44, 28, 40, 24,
																																																							   3, 51, 15, 63,  2, 50, 14, 62,
																																																							  35, 19, 47, 31, 34, 18, 46, 30,
																																																							  11, 59,  7, 55, 10, 58,  6, 54,
																																																							  43, 27, 39, 23, 42, 26, 38, 22};
																																																						  int r = y * 8 + x;
																																																						  return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
																																																					  }


																																																					  void vertexDataFunc(inout appdata_full v, out Input o)
																																																					  {
																																																						  UNITY_INITIALIZE_OUTPUT(Input, o);
																																																						  float4 ase_screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
																																																						  o.screenPosition = ase_screenPos;
																																																					  }

																																																					  void surf(Input i , inout SurfaceOutputStandard o)
																																																					  {
																																																						  float4 _MainTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTexture_ST_arr, _MainTexture_ST);
																																																						  float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST_Instance.xy + _MainTexture_ST_Instance.zw;
																																																						  float4 tex2DNode2 = tex2D(_MainTexture, uv_MainTexture);
																																																						  float4 _ReplaceColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReplaceColor_arr, _ReplaceColor);
																																																						  o.Albedo = ((0.3 <= length(abs((tex2DNode2 - _ReplaceKey)))) ? tex2DNode2 : _ReplaceColor_Instance).rgb;
																																																						  o.Alpha = 1;
																																																						  float4 ase_screenPos = i.screenPosition;
																																																						  float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
																																																						  ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
																																																						  float2 clipScreen19 = ase_screenPosNorm.xy * _ScreenParams.xy;
																																																						  float dither19 = Dither8x8Bayer(fmod(clipScreen19.x, 8), fmod(clipScreen19.y, 8));
																																																						  clip(dither19 - _Cutoff);
																																																					  }


																																																			  #include "UnityMetaPass.cginc"

																																																					  // vertex-to-fragment interpolation data
																																																					  struct v2f_surf {
																																																						UNITY_POSITION(pos);
																																																						float2 pack0 : TEXCOORD0; // _texcoord
																																																						float3 worldPos : TEXCOORD1;
																																																						float4 custompack0 : TEXCOORD2; // screenPosition
																																																					  #ifdef EDITOR_VISUALIZATION
																																																						float2 vizUV : TEXCOORD3;
																																																						float4 lightCoord : TEXCOORD4;
																																																					  #endif
																																																						UNITY_VERTEX_INPUT_INSTANCE_ID
																																																						UNITY_VERTEX_OUTPUT_STEREO
																																																					  };
																																																					  float4 _texcoord_ST;

																																																					  // vertex shader
																																																					  v2f_surf vert_surf(appdata_full v) {
																																																						UNITY_SETUP_INSTANCE_ID(v);
																																																						v2f_surf o;
																																																						UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
																																																						UNITY_TRANSFER_INSTANCE_ID(v,o);
																																																						UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
																																																						Input customInputData;
																																																						vertexDataFunc(v, customInputData);
																																																						o.custompack0.xyzw = customInputData.screenPosition;
																																																						o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
																																																					  #ifdef EDITOR_VISUALIZATION
																																																						o.vizUV = 0;
																																																						o.lightCoord = 0;
																																																						if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
																																																						  o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
																																																						else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
																																																						{
																																																						  o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
																																																						  o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
																																																						}
																																																					  #endif
																																																						o.pack0.xy = TRANSFORM_TEX(v.texcoord, _texcoord);
																																																						float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
																																																						float3 worldNormal = UnityObjectToWorldNormal(v.normal);
																																																						o.worldPos.xyz = worldPos;
																																																						return o;
																																																					  }

																																																					  // fragment shader
																																																					  fixed4 frag_surf(v2f_surf IN) : SV_Target {
																																																						UNITY_SETUP_INSTANCE_ID(IN);
																																																						UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
																																																						// prepare and unpack data
																																																						Input surfIN;
																																																						#ifdef FOG_COMBINED_WITH_TSPACE
																																																						  UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
																																																						#elif defined (FOG_COMBINED_WITH_WORLD_POS)
																																																						  UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
																																																						#else
																																																						  UNITY_EXTRACT_FOG(IN);
																																																						#endif
																																																						UNITY_INITIALIZE_OUTPUT(Input,surfIN);
																																																						surfIN.uv_texcoord.x = 1.0;
																																																						surfIN.screenPosition.x = 1.0;
																																																						surfIN.uv_texcoord = IN.pack0.xy;
																																																						surfIN.screenPosition = IN.custompack0.xyzw;
																																																						float3 worldPos = IN.worldPos.xyz;
																																																						#ifndef USING_DIRECTIONAL_LIGHT
																																																						  fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
																																																						#else
																																																						  fixed3 lightDir = _WorldSpaceLightPos0.xyz;
																																																						#endif
																																																						#ifdef UNITY_COMPILER_HLSL
																																																						SurfaceOutputStandard o = (SurfaceOutputStandard)0;
																																																						#else
																																																						SurfaceOutputStandard o;
																																																						#endif
																																																						o.Albedo = 0.0;
																																																						o.Emission = 0.0;
																																																						o.Alpha = 0.0;
																																																						o.Occlusion = 1.0;
																																																						fixed3 normalWorldVertex = fixed3(0,0,1);

																																																						// call surface function
																																																						surf(surfIN, o);
																																																						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
																																																						UnityMetaInput metaIN;
																																																						UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
																																																						metaIN.Albedo = o.Albedo;
																																																						metaIN.Emission = o.Emission;
																																																					  #ifdef EDITOR_VISUALIZATION
																																																						metaIN.VizUV = IN.vizUV;
																																																						metaIN.LightCoord = IN.lightCoord;
																																																					  #endif
																																																						return UnityMetaFragment(metaIN);
																																																					  }


																																																					  #endif


																																																					  ENDCG

																																																					  }

																																										  // ---- end of surface shader generated code

																																									  #LINE 83

		}
			Fallback "Diffuse"
																																																						  CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
1913;230;1920;749;1367.231;48.0511;1;True;False
Node;AmplifyShaderEditor.ColorNode;1;-1136.135,173.7067;Inherit;False;Property;_ReplaceKey;ReplaceKey;2;0;Create;True;0;0;False;0;1,0,0.6,1;1,0,0.6,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1196.982,-47.35167;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;False;0;-1;None;0be10b2aa76469d418bb4ef0f5b733e9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-873.9336,-61.28453;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;4;-718.9336,-53.28453;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-1129.934,379.7155;Inherit;False;InstancedProperty;_ReplaceColor;ReplaceColor;3;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;5;-617.9336,-52.28453;Inherit;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-602.9336,-139.2845;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareLowerEqual;8;-358.2,3.473831;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DitheringNode;19;-371.5889,344.6443;Inherit;False;1;False;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WobblyLife/Player/WobblyClothes;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0;True;True;0;False;Opaque;;Background;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;4;0;3;0
WireConnection;5;0;4;0
WireConnection;8;0;6;0
WireConnection;8;1;5;0
WireConnection;8;2;2;0
WireConnection;8;3;7;0
WireConnection;0;0;8;0
WireConnection;0;10;19;0
ASEEND*/
//CHKSM=FA4C6ABB4B11CF06E918E4C203C78589C9C7A9EE