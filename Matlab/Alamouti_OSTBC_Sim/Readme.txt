homework_final.m 是最终版本，里面整合了2x2,8x4,4x4的编码矩阵的STBC
2x2是最基础的Alamouti OSTBC，分别弄了1、2条接收天线的性能曲线
8x4是4条发射天线的OSTBC，也分别弄了1、2条接收天线的性能曲线
4x4是4条发射天线的Jafarkhani Q-OSTBC，只弄了1条接收天线的性能曲线

homework_temp1.m 是最初版本，就是实现了简单的2x2 Alamouti OSTBC，而且是2条接收天线
homework_temp2.m 是开发8x4 OSTBC并整合2x2的版本，实现了8x4 OSTBC,1条接收天线进行测试，简单的2x2 Alamouti OSTBC，调成1条接收天线
homework_temp3.m 是开发中途的某版本，就是实现了4x4 Jafarkhani Q-OSTBC，1条接收天线
homework_fail.m 是开发4x4 Jafarkhani Q-OSTBC的失败版本，还没找到失败理由，存个档到时查看

refer里面是两个借鉴的源码

