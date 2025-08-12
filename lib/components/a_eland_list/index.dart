//import '../../model/user_model/data.dart';
import '../../main.dart';
import '../../provider/do_like_method.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
//import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:shimmer/shimmer.dart'; //Import shimmer
//import '../../utils/Icon.dart';
import '../../utils/global.dart';
import '../../components/a_button/index.dart';
import '../../model/eland_list_model/data.dart';

class AElandList extends StatefulWidget {
  final int? uid; //用戶id
  final String? searchByName;
  final bool? isShowCenterload; //是否顯示加載數據的中間loading圖標
  final bool? isLoadMore; //是否支持下拉刷新數,前提是有開啟isSmartRefresher
  final int? pageLimit; //顯示文章數量
  final bool? isReload; //開啟AutomaticKeepAliveClientMixin支持，tab效果支持會有緩存效果
  final Widget? topChild; //上節點插糟
  final Widget? bottomChild; //下節點插糟
  final bool? isSmartRefresher;
  final int? cateId; //eland分類id
  final String? type;

  const AElandList({
    Key? key,
    this.uid = 0,
    this.searchByName = '',
    this.isShowCenterload = true,
    this.isLoadMore = true,
    this.pageLimit = 10,
    this.isReload = true,
    this.topChild = const SizedBox.shrink(),
    this.bottomChild = const SizedBox.shrink(),
    this.isSmartRefresher = true,
    this.cateId = 0,
    this.type = 'all',
  }) : super(key: key);

  @override
  _AElandListState createState() => _AElandListState();
}

class _AElandListState extends State<AElandList>
    with RouteAware, AutomaticKeepAliveClientMixin {
  final List<dynamic> dataItems = []; // Use a typed list
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  int pageId = 1;
  bool isLoading = false; //More descriptive variable name
  bool isLoadComplete = false; //More descriptive variable name

  @override
  bool get wantKeepAlive => widget.isReload!;

  @override
  void initState() {
    super.initState();
    _loadListData(context, showLoading: widget.isShowCenterload!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(
      this,
      ModalRoute.of(context)! as PageRoute<dynamic>,
    );
  }

  @override
  void didPopNext() {
    super.didPopNext();
    final doLikeMethod = Provider.of<DoLikeMethod>(context, listen: false);
    final popMap = doLikeMethod.popIsLike;
    final pushMap = doLikeMethod.pushLike;

    if (pushMap['isLike'] != popMap['isLike']) {
      setState(() {
        final updatedItem = dataItems.firstWhere(
          (item) => item.elandId == popMap['id'],
        );
        updatedItem.ifollow = popMap['isLike'];
        updatedItem.follow += popMap['isLike'] ? 1 : -1;
      });
    }
  }

  void _clickFollow(item) async {
    final uid = G.user.data.id;
    final itemid = item.eland_id;

    try {
      final res = await G.req.eland.dofollow(
        eland_id: itemid,
        userid: uid!,
      ); //More descriptive variable names
      final result = res.data;
      if (result['code'] == 200) {
        setState(() {
          item.follow += item.ifollow ? -1 : 1;
          item.ifollow = !item.ifollow;
        });
      }
    } catch (e) {
      print('_clickFollow===>${e}');
      // Show error message to the user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating follow status')));
    }
  }

  Widget _buildContent(item, int index) {
    //Added index parameter
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: BorderDirectional(
          bottom: BorderSide(color: Colors.black12, width: 1.0),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
        ),
        onPressed: () {
          final map = {"isLike": item.ifollow, "id": item.elandId};
          Provider.of<DoLikeMethod>(context, listen: false).getPushIsLike(map);
          G.pushNamed('/eland_info', arguments: {'id': item.elandId});
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 15.0),
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 28, 141, 160),
                backgroundImage: NetworkImage(item.elandPic),
                radius: 11.0,
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, right: 4.0),
                    child: Text(
                      item.elandName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        height: 1.1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              '${item.follow}用戶',
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '關注',
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: item.ifollow
                            ? AButton.icon(
                                width: 70,
                                height: 25,
                                borderColor: Color.fromARGB(255, 28, 141, 160),
                                bgColor: Color.fromARGB(255, 28, 141, 160),
                                plain: true,
                                textChild: Text(
                                  '已關注',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 13,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(40),
                                icon: icon_star(
                                  size: 13,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                onPressed: () => _clickFollow(item),
                              )
                            : AButton.icon(
                                width: 70,
                                height: 25,
                                borderColor: Color.fromARGB(255, 28, 141, 160),
                                bgColor: Color.fromARGB(255, 255, 255, 255),
                                plain: true,
                                textChild: Text(
                                  '關注',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 13,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(40),
                                icon: icon_star_border(
                                  size: 13,
                                  color: Color(0xff333333),
                                ),
                                onPressed: () => _clickFollow(item),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    pageId = 1;
    dataItems.clear();
    await _loadListData(context, showLoading: false);
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    if (isLoadComplete) return; // Prevent loading if already complete
    await _loadListData(context, showLoading: false, pageId: ++pageId);
    _refreshController.loadComplete();
  }

  Future<void> _loadListData(
    BuildContext context, {
    bool showLoading = true,
    int pageId = 1,
  }) async {
    if (showLoading) G.loading.show(context);
    setState(() => isLoading = true); // Indicate loading state

    try {
      final getElandList = widget.type == 'all'
          ? G.req.eland.list
          : G.req.eland.my_follow_list; //Improved readability
      final res = await getElandList(
        userid: widget.uid!,
        pageid: pageId,
        limit: widget.pageLimit!,
        search_by_name: widget.searchByName!,
        cateid: widget.cateId!,
      );
      final result = res.data;
      final elandList = ElandListModel.fromJson(result);

      setState(() {
        isLoadComplete = elandList.list == null || elandList.list!.isEmpty;
        //isLoadComplete = elandList.list.isEmpty;
        dataItems.addAll(elandList.list!);
        isLoading = false; // Update loading state after data is received
      });
    } catch (e) {
      print('articleCatch===>${e}');
      // Show user-friendly error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data')));
    } finally {
      if (showLoading) G.loading.hide(context);
    }
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _buildShimmerItem(),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80,
                          height: 15,
                          color: Colors.grey[300],
                        ),
                        Container(
                          width: 70,
                          height: 25,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to maintain state
    return widget.isSmartRefresher!
        ? SmartRefresher(
            enablePullDown: true,
            enablePullUp: widget.isLoadMore!,
            header: WaterDropHeader(
              refresh: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 28, 141, 160),
                  ),
                ),
              ),
              complete: const Text('√ 加載完成'),
            ),
            footer: G.pullToRefresh.footer(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: isLoading
                ? _buildShimmerLoading()
                : dataItems.isEmpty
                ? Center(
                    child: Image.asset(
                      "lib/assets/images/empty_img.png",
                      fit: BoxFit.fill,
                    ),
                  )
                : ListView.builder(
                    itemCount: dataItems.length,
                    itemBuilder: (context, index) =>
                        _buildContent(dataItems[index], index),
                  ),
          )
        : Column(
            children: [
              widget.topChild!,
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataItems.length,
                itemBuilder: (context, index) =>
                    _buildContent(dataItems[index], index),
              ),
              widget.bottomChild!,
            ],
          );
  }
}
