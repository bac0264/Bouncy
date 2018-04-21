﻿Shader "Custom/VertexColors" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
	}

	SubShader 
	{
		Tags { "RenderType"="Transparent" "RenderQueue"="Transparent+1" }
		LOD 100

		Pass 
		{
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f 
				{
					half4 color : COLOR;
					float4 vertex : SV_POSITION;
					UNITY_FOG_COORDS(0)
					UNITY_VERTEX_OUTPUT_STEREO
				};

				fixed4 _Color;

				v2f vert (appdata_full v)
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					o.vertex = UnityObjectToClipPos(v.vertex);
					UNITY_TRANSFER_FOG(o,o.vertex);

					o.color = v.color;

					return o;
				}

				fixed4 frag (v2f i) : COLOR
				{
					fixed4 col = i.color * _Color;
					UNITY_APPLY_FOG(i.fogCoord, col);
					UNITY_OPAQUE_ALPHA(col.a);
					return col;
				}
			ENDCG
		}
	}
}