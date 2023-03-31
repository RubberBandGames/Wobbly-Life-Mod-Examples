// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WobblyLife/Custom/WobblyWater"
{
	Properties
	{
		_EdgeColour("Edge Colour", Color) = (0.514151,0.8549706,1,1)
		_FoamDistance("Foam Distance", Range( 0 , 1)) = 0.1
		_WaterDepth("Water Depth", Range( 0 , 8)) = 3
		_WaterDeepDepth("Water Deep Depth", Float) = 100
		_TilingSpeed1("Tiling Speed 1", Vector) = (0.2,0.4,0,0)
		_TilingSpeed2("Tiling Speed 2", Vector) = (-0.3,-0.3,0,0)
		_WaterColour("Water Colour", Color) = (0,0.4193513,0.8490566,1)
		_DeepWaterColour("Deep Water Colour", Color) = (0,0.4193513,0.8490566,1)
		_SurfaceNoiseCutoff("Surface Noise Cutoff", Range( 0 , 1)) = 0.72
		_FoamColour("Foam Colour", Color) = (0.6650944,0.8978254,1,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Water"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		BlendOp Add , Add
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPosition41;
			float4 screenPosition212;
			float3 worldPos;
			half3 worldNormal;
		};

		uniform half4 _EdgeColour;
		uniform half4 _WaterColour;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _WaterDepth;
		uniform half4 _DeepWaterColour;
		uniform half _WaterDeepDepth;
		uniform half _FoamDistance;
		uniform half _SurfaceNoiseCutoff;
		uniform half2 _TilingSpeed1;
		uniform half2 _TilingSpeed2;
		uniform half4 _FoamColour;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			half3 vertexPos41 = ase_vertex3Pos;
			float4 ase_screenPos41 = ComputeScreenPos( UnityObjectToClipPos( vertexPos41 ) );
			o.screenPosition41 = ase_screenPos41;
			half3 vertexPos212 = ase_vertex3Pos;
			float4 ase_screenPos212 = ComputeScreenPos( UnityObjectToClipPos( vertexPos212 ) );
			o.screenPosition212 = ase_screenPos212;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos41 = i.screenPosition41;
			half4 ase_screenPosNorm41 = ase_screenPos41 / ase_screenPos41.w;
			ase_screenPosNorm41.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm41.z : ase_screenPosNorm41.z * 0.5 + 0.5;
			float screenDepth41 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm41.xy ));
			half distanceDepth41 = saturate( abs( ( screenDepth41 - LinearEyeDepth( ase_screenPosNorm41.z ) ) / ( _WaterDepth ) ) );
			half4 lerpResult47 = lerp( _EdgeColour , _WaterColour , distanceDepth41);
			float4 ase_screenPos212 = i.screenPosition212;
			half4 ase_screenPosNorm212 = ase_screenPos212 / ase_screenPos212.w;
			ase_screenPosNorm212.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm212.z : ase_screenPosNorm212.z * 0.5 + 0.5;
			float screenDepth212 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm212.xy ));
			half distanceDepth212 = saturate( abs( ( screenDepth212 - LinearEyeDepth( ase_screenPosNorm212.z ) ) / ( _WaterDeepDepth ) ) );
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 ase_worldNormal = i.worldNormal;
			half3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			half dotResult221 = dot( ase_worldViewDir , ase_vertexNormal );
			half temp_output_225_0 = ( distanceDepth212 * dotResult221 );
			half4 lerpResult213 = lerp( lerpResult47 , _DeepWaterColour , temp_output_225_0);
			half FoamValue236 = ( saturate( ( distanceDepth41 / _FoamDistance ) ) * _SurfaceNoiseCutoff );
			half2 appendResult209 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 WorldPos2D239 = appendResult209;
			half2 panner71 = ( _Time.y * _TilingSpeed1 + ( WorldPos2D239 * half2( 0.5,0.5 ) ));
			half simplePerlin2D49 = snoise( panner71 );
			simplePerlin2D49 = simplePerlin2D49*0.5 + 0.5;
			half2 panner133 = ( _Time.y * _TilingSpeed2 + ( WorldPos2D239 * half2( 0.5,0.5 ) ));
			half simplePerlin2D134 = snoise( panner133 );
			simplePerlin2D134 = simplePerlin2D134*0.5 + 0.5;
			o.Albedo = ( lerpResult213 + ( step( FoamValue236 , ( simplePerlin2D49 * simplePerlin2D134 ) ) * _FoamColour ) ).rgb;
			half WaterDepthValue252 = distanceDepth41;
			half WaterDepth233 = _WaterDepth;
			half DeepDepthValue01230 = temp_output_225_0;
			o.Alpha = ( max( ( 1.0 - ( WaterDepthValue252 / WaterDepth233 ) ) , FoamValue236 ) + DeepDepthValue01230 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
509;403;1363;657;1119.749;596.5532;1.782805;True;False
Node;AmplifyShaderEditor.CommentaryNode;196;-3784.329,-685.4926;Inherit;False;732.3;419.6158;World Possition;3;158;209;239;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;197;-1835.156,-1794.277;Inherit;False;1099.575;1094.887;Depth Fade;17;225;221;212;211;210;1;46;41;43;38;222;220;230;233;47;213;252;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;158;-3733.359,-639.4926;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;198;-649.67,-1734.244;Inherit;False;1137.746;300.005;Foam Control;6;236;146;147;144;145;143;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1785.156,-1744.277;Inherit;False;Property;_WaterDepth;Water Depth;3;0;Create;True;0;0;0;False;0;False;3;7.15;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;209;-3544.212,-611.0818;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;38;-1683.781,-1601.774;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;181;-2786.365,138.7259;Inherit;False;1533.152;523.5169;Tileing Texture 2;7;128;130;135;129;133;134;241;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;195;-2826.39,-622.7524;Inherit;False;1379.098;531.5942;Tiling Texture 1;7;63;64;70;73;71;49;240;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;41;-1346.384,-1689.184;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;-3341.982,-578.8608;Inherit;False;WorldPos2D;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-599.67,-1658.479;Inherit;False;Property;_FoamDistance;Foam Distance;2;0;Create;True;0;0;0;False;0;False;0.1;0.434;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;63;-2776.39,-493.5912;Inherit;True;Constant;_TilingScale1;Tiling Scale 1;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;240;-2765.224,-583.722;Inherit;False;239;WorldPos2D;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-2618.322,171.5777;Inherit;False;239;WorldPos2D;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;145;-252.1789,-1683.641;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;128;-2753.144,193.8885;Inherit;True;Constant;_TilingScale2;Tiling Scale 2;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;73;-2400.641,-361.8519;Inherit;False;Property;_TilingSpeed1;Tiling Speed 1;5;0;Create;True;0;0;0;False;0;False;0.2,0.4;0.2,0.4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-2422.794,180.2454;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;144;-112.6348,-1683.924;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;135;-2586.421,551.243;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2539.007,-572.7524;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;130;-2441.352,410.8046;Inherit;False;Property;_TilingSpeed2;Tiling Speed 2;6;0;Create;True;0;0;0;False;0;False;-0.3,-0.3;-0.3,-0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;147;-168.5106,-1551.239;Inherit;False;Property;_SurfaceNoiseCutoff;Surface Noise Cutoff;9;0;Create;True;0;0;0;False;0;False;0.72;0.787;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;70;-2588.346,-202.1582;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;220;-1732.037,-901.3991;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;113.0761,-1684.244;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;252;-1081.468,-1732.692;Inherit;False;WaterDepthValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;133;-2053.43,400.8026;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;71;-2152.234,-368.7454;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-1798.177,-1406.116;Inherit;False;Property;_WaterDeepDepth;Water Deep Depth;4;0;Create;True;0;0;0;False;0;False;100;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;256;-370.7115,150.586;Inherit;False;845.3984;540.4734;Calculate Alpha;8;235;200;202;229;255;237;253;231;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;233;-1484.214,-1746.387;Inherit;False;WaterDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;222;-1794.395,-1164.827;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;253;-320.7115,371.9586;Inherit;False;252;WaterDepthValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;221;-1538.078,-933.024;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;212;-1532.063,-1157.178;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;-297.8324,287.0428;Inherit;False;233;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;49;-1711.292,-511.7734;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;134;-1628.672,247.4908;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;236;287.1685,-1667.292;Inherit;False;FoamValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;-1390.329,-1054.032;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-1219.098,-1531.341;Inherit;False;Property;_EdgeColour;Edge Colour;1;0;Create;True;0;0;0;False;0;False;0.514151,0.8549706,1,1;0.240566,0.6592652,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;238;-848.63,-389.1168;Inherit;False;236;FoamValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;-1211.094,-1360.972;Inherit;False;Property;_WaterColour;Water Colour;7;0;Create;True;0;0;0;False;0;False;0,0.4193513,0.8490566,1;0,0.4232625,0.8509805,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;200;-76.55365,308.7478;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1245.3,-228.4386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;-998.7895,-1625.158;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;211;-1213.177,-1187.116;Inherit;False;Property;_DeepWaterColour;Deep Water Colour;8;0;Create;True;0;0;0;False;0;False;0,0.4193513,0.8490566,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;142;-463.4189,-201.0105;Inherit;False;Property;_FoamColour;Foam Colour;10;0;Create;True;0;0;0;False;0;False;0.6650944,0.8978254,1,0;0.4,0.6039216,0.7490196,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;237;70.15078,575.0594;Inherit;False;236;FoamValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;254;-592.2197,-352.3649;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;202;119.9496,356.9998;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;230;-1163.212,-920.0955;Inherit;False;DeepDepthValue01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;213;-929.4645,-1310.384;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;255;274.8579,544.6199;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-303.9124,-349.5619;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;231;74.00961,216.1415;Inherit;False;230;DeepDepthValue01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;25.50332,-725.1993;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;229;322.6869,200.586;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;711.8971,-129.2056;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WobblyLife/Custom/WobblyWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;Water;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;209;0;158;1
WireConnection;209;1;158;3
WireConnection;41;1;38;0
WireConnection;41;0;43;0
WireConnection;239;0;209;0
WireConnection;145;0;41;0
WireConnection;145;1;143;0
WireConnection;129;0;241;0
WireConnection;129;1;128;0
WireConnection;144;0;145;0
WireConnection;64;0;240;0
WireConnection;64;1;63;0
WireConnection;146;0;144;0
WireConnection;146;1;147;0
WireConnection;252;0;41;0
WireConnection;133;0;129;0
WireConnection;133;2;130;0
WireConnection;133;1;135;0
WireConnection;71;0;64;0
WireConnection;71;2;73;0
WireConnection;71;1;70;0
WireConnection;233;0;43;0
WireConnection;221;0;222;0
WireConnection;221;1;220;0
WireConnection;212;1;38;0
WireConnection;212;0;210;0
WireConnection;49;0;71;0
WireConnection;134;0;133;0
WireConnection;236;0;146;0
WireConnection;225;0;212;0
WireConnection;225;1;221;0
WireConnection;200;0;253;0
WireConnection;200;1;235;0
WireConnection;140;0;49;0
WireConnection;140;1;134;0
WireConnection;47;0;1;0
WireConnection;47;1;46;0
WireConnection;47;2;41;0
WireConnection;254;0;238;0
WireConnection;254;1;140;0
WireConnection;202;0;200;0
WireConnection;230;0;225;0
WireConnection;213;0;47;0
WireConnection;213;1;211;0
WireConnection;213;2;225;0
WireConnection;255;0;202;0
WireConnection;255;1;237;0
WireConnection;141;0;254;0
WireConnection;141;1;142;0
WireConnection;54;0;213;0
WireConnection;54;1;141;0
WireConnection;229;0;255;0
WireConnection;229;1;231;0
WireConnection;0;0;54;0
WireConnection;0;9;229;0
ASEEND*/
//CHKSM=E4CEC9B4CC7CFE99363F801609C4DA08B77190D1