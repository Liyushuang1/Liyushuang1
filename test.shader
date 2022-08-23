Shader "Unlit/test"                    //目标、名称
{

    //Shader 界面变量
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} 
    }

    // shader 材质球。可以多个，对应不同平台
    SubShader
    {
        //标签。 渲染模式，次序
        Tags { "RenderType"="Opaque" }

        LOD 100        //双面，叠加模式

        Pass
        {

            //cg模块
            CGPROGRAM

            //定义结构
            //定义顶点片段程序（改模型）自定义函数名 vert
            #pragma vertex vert

            //定义表面渲染程序段（改颜色） 自定义，表面函数
            #pragma fragment frag
            // make fog work

            //环境雾程序集
            #pragma multi_compile_fog

            //cg函数程序集合
            #include "UnityCG.cginc"


            //模型源数据
            struct appdata
            {
                float4 vertex : POSITION;   //顶点坐标
                float2 uv : TEXCOORD0;      //uv坐标
            };

            //定义顶点片段数据结构
            struct v2f
            {
                float2 uv : TEXCOORD0;    //输出修改后的UV
                UNITY_FOG_COORDS(1)       // 输出环境雾
                float4 vertex : SV_POSITION;  //输出修改后的顶点
            };

            // 获取变量
            sampler2D _MainTex;   //颜色贴图
            float4 _MainTex_ST;   // 贴图重复与偏移

            //顶点程序块
            v2f vert (appdata v)
            {
                v2f o;    //初始化输出变量
                o.vertex = UnityObjectToClipPos(v.vertex);   //物体顶点转裁切空间
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);    // 默认uv进行重复与偏移修改
                UNITY_TRANSFER_FOG(o,o.vertex);          //输出环境雾颜色
                return o;                                //输出结果
            }

            //表面程序块
            fixed4 frag (v2f i) : SV_Target             
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);    //设置输出颜色 = 获取贴图，依据修改后的UV坐标
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);    // 给颜色添加雾
                return col;                          // 输出颜色
            }
            ENDCG
        }
    }
}
