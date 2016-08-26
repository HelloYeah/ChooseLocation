# ChooseLocation
高仿京东选择收货地址


###导读
目前大多数APP的地址选择是用系统的picker View,也不乏用tableview自定义的.
这里分享一个高仿京东的地址选择给大家.
源码地址:https://github.com/HelloYeah/ChooseLocation
欢迎大家checkout,Star...

#####下面是京东收货地址的一些交互以及代码思路分析

>1.刚打开选择地址视图时,底部ScrollView的滚动范围只有一屏宽.

>2.点击某个省时,增加对应的市级列表,底部ScrollView横向滚动区域增加一屏宽.

![1.gif](http://upload-images.jianshu.io/upload_images/1338042-16ffa01913c5ccf6.gif?imageMogr2/auto-orient/strip)

>1.当重新选择省的时候,移除后面的市级别列表,区级别列表

>2.移除顶部的市按钮,区按钮.

>3.并且底部ScrollView的滚动范围减少至两屏宽.

![2.gif](http://upload-images.jianshu.io/upload_images/1338042-7bc0307bf43ebf45.gif?imageMogr2/auto-orient/strip)



>1.当重新选择省市的时候,对应顶部按钮的宽度跟着改变,对应下级的按钮的x值要相应调整
>2.按钮底部的指示条的长度和位置跟着相应变化

![tmp5deefbb7.png](http://upload-images.jianshu.io/upload_images/1338042-78137181ccaaad4e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#####其他注意点
>1.点击灰色区域,取消地址选择,回到主界面

>2.京东用的是网络请求获取省市区信息,每点击一个cell,向服务器发送请求,获取下级信息.这里用的是本地plist表

下面是plist表的格式


![tmp4fa6b8b2.png](http://upload-images.jianshu.io/upload_images/1338042-0634bafac585c0db.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




源码地址:https://github.com/HelloYeah/ChooseLocation
欢迎大家checkout,Star...
