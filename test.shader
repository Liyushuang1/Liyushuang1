Shader "Unlit/test"                    //Ŀ�ꡢ����
{

    //Shader �������
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} 
    }

    // shader �����򡣿��Զ������Ӧ��ͬƽ̨
    SubShader
    {
        //��ǩ�� ��Ⱦģʽ������
        Tags { "RenderType"="Opaque" }

        LOD 100        //˫�棬����ģʽ

        Pass
        {

            //cgģ��
            CGPROGRAM

            //����ṹ
            //���嶥��Ƭ�γ��򣨸�ģ�ͣ��Զ��庯���� vert
            #pragma vertex vert

            //���������Ⱦ����Σ�����ɫ�� �Զ��壬���溯��
            #pragma fragment frag
            // make fog work

            //���������
            #pragma multi_compile_fog

            //cg�������򼯺�
            #include "UnityCG.cginc"


            //ģ��Դ����
            struct appdata
            {
                float4 vertex : POSITION;   //��������
                float2 uv : TEXCOORD0;      //uv����
            };

            //���嶥��Ƭ�����ݽṹ
            struct v2f
            {
                float2 uv : TEXCOORD0;    //����޸ĺ��UV
                UNITY_FOG_COORDS(1)       // ���������
                float4 vertex : SV_POSITION;  //����޸ĺ�Ķ���
            };

            // ��ȡ����
            sampler2D _MainTex;   //��ɫ��ͼ
            float4 _MainTex_ST;   // ��ͼ�ظ���ƫ��

            //��������
            v2f vert (appdata v)
            {
                v2f o;    //��ʼ���������
                o.vertex = UnityObjectToClipPos(v.vertex);   //���嶥��ת���пռ�
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);    // Ĭ��uv�����ظ���ƫ���޸�
                UNITY_TRANSFER_FOG(o,o.vertex);          //�����������ɫ
                return o;                                //������
            }

            //��������
            fixed4 frag (v2f i) : SV_Target             
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);    //���������ɫ = ��ȡ��ͼ�������޸ĺ��UV����
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);    // ����ɫ�����
                return col;                          // �����ɫ
            }
            ENDCG
        }
    }
}
