// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WobblyLife/Custom/WobblyBoundary"
{
	Properties
	{
		[NoScaleOffset]_BoundaryStripes2("Boundary Stripes 2", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (0.1090691,0.3610032,0.5377358,0)
		[NoScaleOffset]_BoundaryStripes1("Boundary Stripes 1", 2D) = "white" {}
		_Tile("Tile", Vector) = (1,1,0,0)
		_Mindistance("Min distance", Float) = 20
		_Maxdistance("Max distance", Float) = 6
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _Color;
		uniform sampler2D _BoundaryStripes1;
		uniform float2 _Tile;
		uniform sampler2D _BoundaryStripes2;
		uniform float _Mindistance;
		uniform float _Maxdistance;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord11 = i.uv_texcoord * _Tile;
			float2 panner12 = ( 1.0 * _Time.y * float2( 0.05,0 ) + uv_TexCoord11);
			float2 uv_TexCoord7 = i.uv_texcoord * _Tile;
			float2 panner13 = ( 1.0 * _Time.y * float2( -0.05,0 ) + uv_TexCoord7);
			float temp_output_10_0 = ( tex2D( _BoundaryStripes1, panner12 ).a + tex2D( _BoundaryStripes2, panner13 ).a );
			float2 panner22 = ( 0.1 * _Time.y * float2( 1,1 ) + float2( 1,1 ));
			float simplePerlin2D18 = snoise( panner22 );
			simplePerlin2D18 = simplePerlin2D18*0.5 + 0.5;
			float clampResult64 = clamp( simplePerlin2D18 , 0.6 , 0.8 );
			float3 ase_worldPos = i.worldPos;
			float temp_output_33_0 = distance( _WorldSpaceCameraPos , ase_worldPos );
			float ifLocalVar41 = 0;
			if( temp_output_33_0 >= _Mindistance )
				ifLocalVar41 = 0.0;
			else
				ifLocalVar41 = ( 1.0 - ( ( temp_output_33_0 - _Maxdistance ) / ( _Mindistance - _Maxdistance ) ) );
			float4 temp_output_49_0 = ( ( ( _Color * temp_output_10_0 ) * clampResult64 ) * ifLocalVar41 );
			o.Albedo = temp_output_49_0.rgb;
			o.Emission = temp_output_49_0.rgb;
			float clampResult50 = clamp( ifLocalVar41 , 0.0 , 0.6 );
			o.Alpha = ( temp_output_10_0 * clampResult50 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
0;6.285715;1920;1013.286;2816.458;691.421;1.927114;True;True
Node;AmplifyShaderEditor.CommentaryNode;29;-3100.687,-1477.597;Inherit;False;2387.311;895.6761;Stripes;10;15;11;7;13;12;8;2;10;4;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;35;-1539.385,824.3599;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;34;-1584.676,631.9026;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;15;-3050.687,-1267.22;Inherit;False;Property;_Tile;Tile;3;0;Create;True;0;0;False;0;1,1;4,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-2796.832,-1399.644;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-1345.072,1154.558;Inherit;False;Property;_Maxdistance;Max distance;5;0;Create;True;0;0;False;0;6;-5.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;33;-1305.482,742.6263;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1347.527,1046.889;Inherit;False;Property;_Mindistance;Min distance;4;0;Create;True;0;0;False;0;20;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-2839.632,-1156.531;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;13;-2562.446,-1155.446;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.05,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;12;-2484.764,-1400.013;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-1104.518,1222.145;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;42;-1094.379,1089.02;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-2166.651,-315.1724;Inherit;False;1194.907;649.6764;Emmission;4;31;18;22;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-2344.298,-1184.553;Inherit;True;Property;_BoundaryStripes2;Boundary Stripes 2;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;44;-918.5173,1122.145;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;22;-1706.514,-120.4597;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;1,1;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;8;-2238.749,-1427.597;Inherit;True;Property;_BoundaryStripes1;Boundary Stripes 1;2;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;48;-780.139,1151.957;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1580.964,995.0895;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1982.372,-1194.766;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1522.738,-135.7877;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-1642.101,-1405.786;Inherit;False;Property;_Color;Color;1;1;[HDR];Create;True;0;0;False;0;0.1090691,0.3610032,0.5377358,0;0.713508,3.338198,4.867144,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;41;-1014.275,740.9311;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1464.341,-1214.095;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;64;-1332.112,139.0364;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.6;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;50;-420.0298,247.7369;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1206.746,-108.2186;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-377.7422,-38.30814;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-231.9131,120.5418;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WobblyLife/Custom/WobblyBoundary;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;15;0
WireConnection;33;0;34;0
WireConnection;33;1;35;0
WireConnection;7;0;15;0
WireConnection;13;0;7;0
WireConnection;12;0;11;0
WireConnection;43;0;37;0
WireConnection;43;1;40;0
WireConnection;42;0;33;0
WireConnection;42;1;40;0
WireConnection;2;1;13;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;8;1;12;0
WireConnection;48;0;44;0
WireConnection;10;0;8;4
WireConnection;10;1;2;4
WireConnection;18;0;22;0
WireConnection;41;0;33;0
WireConnection;41;1;37;0
WireConnection;41;2;45;0
WireConnection;41;3;45;0
WireConnection;41;4;48;0
WireConnection;3;0;4;0
WireConnection;3;1;10;0
WireConnection;64;0;18;0
WireConnection;50;0;41;0
WireConnection;31;0;3;0
WireConnection;31;1;64;0
WireConnection;49;0;31;0
WireConnection;49;1;41;0
WireConnection;55;0;10;0
WireConnection;55;1;50;0
WireConnection;0;0;49;0
WireConnection;0;2;49;0
WireConnection;0;9;55;0
ASEEND*/
//CHKSM=44DEA4D06970DC61F17BA481911E0D27494F4186