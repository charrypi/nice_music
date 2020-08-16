# 介绍

花生音乐一款音乐聚合播放器，作者本着对音乐的喜爱和技术的追求，所以开发出了这款APP。

**本项目采用Flutter+Dart语言开发，所用音乐请求API和素材文件均来源于网络，项目源码仅用于学习研究，切勿用于商业用途。相关资源如若侵权，请联系作者删除。**

---

## **目前开发的功能**

1. 主页

   <center><figure><img src="docs\images\home.png" alt="home" style="float:left;width:250px"/><img src="docs\images\home (2).png" alt="home (2)" style="float:left;width:250px" /></figure></center>

   

   

2. 音乐搜索

   <img src="docs\images\search.png" alt="search" style="float:left;width:250px" />

3. 播放列表

   <img src="docs\images\playlist.png" alt="playlist" style="float:left;width:250px" />

4. 收藏列表

   <img src="docs\images\favorite.png" alt="favorite" style="float:left;width:250px" />

5. 下载列表

   <img src="docs\images\download.png" alt="download" style="float:left;width:250px" />

6. 播放详情页面

   <center><figure><img src="docs\images\playview.png" alt="playview" style="float:left;width:250px" /><img src="docs\images\playlistInplayView.png" alt="playlistInplayView" style="float:left;width:250px"/></figure></center>

   

   ---

## **项目启动方法**

`flutter run`

**项目编译**(目前仅支持Android端编译)

`flutter build apk`

编译完成的apk文件在 **项目路径/build\app\outputs\apk\release** 目录下。中途如出现下载不到依赖的包，可多试几次或者科学上网再次编译。

## sqflite debug模式

项目已内置android debug-db依赖，可开启sqflite debug模式，在开启安卓模拟器运行程序后，执行以下命令：

`adb forward tcp:8080 tcp:8080`

开启完成后，打开浏览器访问  **http://localhost:8080**  即可访问app内部sqflite数据库。

