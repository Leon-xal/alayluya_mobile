//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../utils/global.dart';

/// 通用appbar
///
/// ```
/// @param {BuildContext} - context 如果context存在：左边有返回按钮，反之没有
/// @param {String} title - 标题
/// @param {bool} borderBottom - 是否显示底部border
/// ```
///
///
class CustomNavbar extends StatefulWidget {
  final ValueChanged<int> onTap;

  CustomNavbar({Key? key, required this.onTap}) : super(key: key);
  // 通过 routeName 获取对应页面的索引
  getPageIndex(routeName) {
    // print('ssss1====>${routeName}');
    switch (routeName) {
      case '/home':
        return 0;
      case '/today':
        return 1;
      case '/article':
        return 2;
      case '/membercenter':
        return 3;
      default:
        return -1;
    }
  }

  @override
  _CustomNavbarState createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  int currentIndex = 0;
  int tempCurrentIndex = 0;
  bool isnotInNavpage = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      String? routeName;
      if (ModalRoute.of(context) == null) {
        // 如果 ModalRoute 不存在，可能是因为当前页面没有路由
        routeName = '/home'; // 默认设置为首页
      } else {
        routeName = ModalRoute.of(context)!.settings.name;
      }
      //String routeName = ModalRoute.of(context).settings.name;
      // print('ssss2====>${routeName}');
      tempCurrentIndex = widget.getPageIndex(routeName);
      setState(() {
        if (tempCurrentIndex == -1) {
          currentIndex = 0;
          isnotInNavpage = true;
        } else {
          currentIndex = tempCurrentIndex;
          isnotInNavpage = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        //            canvasColor: rgba(247,247,247,1),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Container(
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 247, 247, 247),
          //          backgroundColor: rgba(0,0,0,1),
          type: BottomNavigationBarType.fixed,
          items: [
            // BottomNavigationBarItem(icon: icon_home(),title: Text('個人關注'),),
            // BottomNavigationBarItem(icon: icon_friendcircle(),title: Text('AA推介'),),
            // BottomNavigationBarItem(icon: icon_article(),title: Text('文章總覽'),),
            // BottomNavigationBarItem(icon: icon_member(),title: Text('個人中心'),),
            BottomNavigationBarItem(icon: icon_home(), label: '個人關注'),
            BottomNavigationBarItem(icon: icon_friendcircle(), label: 'AA推介'),
            BottomNavigationBarItem(icon: icon_article(), label: '文章總覽'),
            BottomNavigationBarItem(icon: icon_member(), label: '個人中心'),
          ],
          unselectedFontSize: 10, // 未选中字体大小
          selectedFontSize: 10, // 选中字体大小
          unselectedItemColor: Color(0xff333333),
          selectedItemColor: (isnotInNavpage == true)
              ? Color.fromARGB(179, 0, 0, 0)
              : Color.fromARGB(255, 28, 141, 160), // 选中字体颜色
          currentIndex: currentIndex,
          onTap: (index) {
            if (G.isLogin == false) {
              G.toast('重新登錄');
              Navigator.of(context).pushReplacementNamed('/login_start');
              return;
            }

            setState(() {
              currentIndex = index;
              isnotInNavpage = false;
              // print('currentIndex1====>${currentIndex}');
              widget.onTap(currentIndex);
            });
          },
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 247, 247, 247),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
