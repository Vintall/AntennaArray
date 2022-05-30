Shader "Custom/InterferenceShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        CGPROGRAM
        #pragma surface surf Standard //fullforwardshadows
        #pragma target 3.0

        float2 _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        float2 _Sheet_position;
        float _Sheet_size;

        int _Antenna_count;
        float2 _Antenna_position[100];
        
        float _Phase_shift;
        float _Wave_length;
        float _Wave_frequency;
        

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            const float pi = 3.1415926;
            float s_all = 0;
            float2 uv = -(IN.uv_MainTex - 0.5) * _Sheet_size + _Sheet_position;
            for (int i = 0; i < 100; i+=1)
            {
                if (i >= _Antenna_count)
                    break;

                half2 buff = _Antenna_position[i];
                float2 xx = uv - buff;
                float r = length(xx);

                float sin_clear = sin(r * 2 * pi / _Wave_length + i * (_Phase_shift * pi / 180) - _Time * _Wave_frequency);
                float sin_handled = sin_clear * 2 / _Antenna_count;

                s_all += sin_handled;
            }
            o.Albedo = float3(s_all, 0, -s_all);
        }
        ENDCG
    }
    FallBack "Diffuse"
}