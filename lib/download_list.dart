import 'package:flutter/material.dart';
import 'package:nicemusic/components/download_item.dart';
import 'package:nicemusic/components/download_completed_list.dart';
import 'package:nicemusic/model/download_file.dart';
import 'package:nicemusic/store/downloading_files_notifier.dart';
import 'package:nicemusic/store/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'components/empty_container.dart';

class DownLoadList extends StatefulWidget {
  @override
  _DownLoadListState createState() => _DownLoadListState();
}

enum _FuncValue { F1, F2 }

class _DownLoadListState extends State<DownLoadList>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollCtl = ScrollController();

  TabController _tabCtl;

  // 是否全部加载完成
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _listenListScroll();
    _initTabController();
  }

  void _initTabController() {
    _tabCtl = TabController(length: 2, vsync: this);
  }

  // 监听列表滚动
  _listenListScroll() {
    _scrollCtl.addListener(() {
      if (_scrollCtl.position.pixels >= _scrollCtl.position.maxScrollExtent &&
          !this.isFinished) {
        // 加载更多
//        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: _scrollCtl,
          headerSliverBuilder: (context, scrolled) {
            return <Widget>[
              SliverAppBar(
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                actions: <Widget>[
                  PopupMenuButton(
                    elevation: 0,
                    tooltip: '功能列表',
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                            height: 40,
                            value: _FuncValue.F1, child: Text('删除已下载完成任务')),
                        PopupMenuItem(
                            height: 40,
                            value: _FuncValue.F2, child: Text('删除下载失败任务'))
                      ];
                    },
                    onSelected: _funcSelect,
                  )
                ],
                expandedHeight: 150,
                pinned: true,
                centerTitle: true,
                title: Text('下载列表', style: TextStyle(color: Colors.white)),
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Image.asset(
                      "icons/downloadlist_bg.png",
                      fit: BoxFit.fill,
                    )),
                bottom: TabBar(
                    indicatorColor:
                        Color(Provider.of<ThemeNotifier>(context).primaryColor),
                    controller: _tabCtl,
                    tabs: <Tab>[
                      Tab(
                        child: Text('下载中',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      Tab(
                        child: Text('已下载',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      )
                    ]),
              )
            ];
          },
          body: TabBarView(controller: _tabCtl, children: [
            _buildDownloadingListView(),
            _buildDownLoadedListView()
          ])),
    );
  }

  Widget _buildDownloadingListView() {
    List<DownloadFile> files =
        Provider.of<DownLoadingFilesNotifier>(context).files;
    if (files.length == 0) {
      return EmptyContainer(
          assetName: 'icons/cute_pumpkin.svg', tips: '当前没有下载任务');
    }
    return ListView.builder(
        itemCount: files.length,
        cacheExtent: 10,
        itemBuilder: (context, index) {
          DownloadFile file = files[index];
          return DownLoadItem(index: index + 1, file: file);
        });
  }

  Widget _buildDownLoadedListView() {
    return DownloadedListView();
  }

  _funcSelect(value) {
    if (value == _FuncValue.F1) {
      Provider.of<DownLoadingFilesNotifier>(context, listen: false)
          .removeDownloadFilesByStatus(DownloadStatus.COMPLETED);
    } else if (value == _FuncValue.F2) {
      Provider.of<DownLoadingFilesNotifier>(context, listen: false)
          .removeDownloadFilesByStatus(DownloadStatus.ERROR);
    }
  }
}
