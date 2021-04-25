Shader "Custom/PBR-spec"
{
     Properties
    {
        _MainTex1 ("Main texture 1", 2D) = "white" {}
        _MainTex2 ("Main texture 2", 2D) = "white" {}
        _MainTex3 ("Main texture 3", 2D) = "white" {}
        _MaskTex ("Mask texture", 2D) = "black" {}
        _EmissionMaskTex ("Emission texture", 2D) = "black" {}

        _EmissionColor ("Emission", Color) = (1, 1, 1, 1)
        _VectorParam ("Vector parameter", Vector) = (1.0, 0.5, 0.1, 0.0)

        _FloatParam ("Intensity", Float) = 1.0
        _IntParam ("Intensity", Int) = 1.0
        _EmisionAppearance ("Emission Appearence", Range(0, 1)) = 1

        _BumpMap ("Normal Map", 2D) = "bump" {}

        _Shiness1 ("Shiness 1", Range(0, 1)) = 0.07
        _Shiness2 ("Shiness 2", Range(0, 1)) = 0.07
        _Shiness3 ("Shiness 3", Range(0, 1)) = 0.07

        _Specularity1 ("_Specularity 1", Range(0, 1)) = 0.5
        _Specularity2 ("_Specularity 2", Range(0, 1)) = 0.5
        _Specularity3 ("_Specularity 3", Range(0, 1)) = 0.5

        _SpecColor1 ("Specular Color 1", Color) = (1, 1, 1, 1)
        _SpecColor2 ("Specular Color 2", Color) = (1, 1, 1, 1)
        _SpecColor3 ("Specular Color 3", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        CGPROGRAM
        
        #pragma surface surf StandardSpecular 


        sampler2D _MainTex1,
                  _MainTex2,
                  _MainTex3,
                  _MaskTex,
                  _EmissionMaskTex,
                  _BumpMap;

        fixed3 _EmissionColor,
               _SpecColor1,
               _SpecColor2,
               _SpecColor3;
        fixed _EmisionAppearance,
              _Specularity1,
              _Specularity2,
              _Specularity3;
        half _Shiness1,
             _Shiness2,
             _Shiness3;

        struct Input
        {
            half2 uv_MainTex1;
            half2 uv_MaskTex;
        };

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed3 masks = tex2D(_MaskTex, IN.uv_MaskTex).rgb;
            fixed3 clr = tex2D(_MainTex1, IN.uv_MainTex1).rgb * masks.r;
            clr += tex2D(_MainTex2, IN.uv_MainTex1) * masks.g;
            clr += tex2D(_MainTex3, IN.uv_MainTex1) * masks.b;
            o.Albedo = clr;

            fixed3 emTex = tex2D(_EmissionMaskTex, IN.uv_MaskTex).rgb;

            half appearMask = emTex.b;
            appearMask = smoothstep(_EmisionAppearance * 1.2, _EmisionAppearance * 1.2 -0.2, appearMask);

            o.Emission = appearMask * emTex.g * _EmissionColor;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MaskTex));

            o.Specular = (_Specularity1 * masks.r * _SpecColor1 + _Specularity2 * masks.g * _SpecColor2 + _Specularity3 * masks.b * _SpecColor3) * clr;
            o.Smoothness = _Shiness1 * masks.r + _Shiness2 * masks.g + _Shiness3 * masks.b;
            
          
        }
        ENDCG
    }
    FallBack "Diffuse"
}
