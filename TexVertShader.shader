Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor("Base Color",Color) = (1,0.25,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
             HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #pragma vertex vert
            #pragma fragment frag

            CBUFFER_START(UnityPerMaterial)

            float4 _BaseColor;

            CBUFFER_END

           

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct vertexOutput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.uv = v.uv;
                float4 xMod = SAMPLE_TEXTURE2D_LOD(_MainTex,sampler_MainTex,v.uv,0);
                xMod = xMod * 2 - 1;
                float3 vert = v.vertex.xyz;                
                o.uv.x = sin(xMod * 10 - _Time.y);
                vert.y = o.uv.x * 0.5;
                o.vertex = TransformObjectToHClip(vert);
                return o;
            }

            float4 frag (vertexOutput i) : SV_Target
            {
                // sample the texture
                float4 col = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex,i.uv);
                float4 tess = float4(i.uv.x,0,0.10,1);
                return col * tess;
            }
            ENDHLSL

        }
    }
}
