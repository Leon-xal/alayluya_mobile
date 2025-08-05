//import 'package:color_dart/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../components/custom_navbar/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/Icon.dart';
import '../../utils/global.dart';

class TermsOfUse extends StatefulWidget {
  TermsOfUse({Key key}) : super(key: key);
  @override
  createState() => _TermsOfUseState();
}


class _TermsOfUseState extends State<TermsOfUse> {

  int userid = 0;
  ScrollController scrollController = ScrollController();
  String content_html = '';

  @override
  void initState() {
    super.initState();
    UserDataModel userData = G.user.data;
    if(userData != null){
        userid = userData.id;
    }
//    print('aaaaa===>${userData}');

    content_html = """
<p>1.     本網站提供所有正統基督信仰教會機構免費e-Land，由機構安排人員進行管理。</p>

<p>2.     機構有責任提供正確和必要之資料予網站方。機構有責任在e-Land提供正確和必要之資料予公眾瀏覽。</p>

<p>3.     機構有資料更新時需及時在網站更新和知會網站方。</p>

<p>4.     機構e-Land 在網站不得提供侵犯他人知識產權之資料。網站方若經他人投訴該機構有侵權行為，網站方有權利要求其及時撤回相關資料及做其他善後處理。若不聽從所提供之服務將會被停止。</p>

<p>5.     未得機構同意網站方不會將該機構的資料出賣給其他第三方；但相關資料可在合宜隱私保護條件下供本網站的事工推廣、宣傳使用。</p>

<p>6.     網站方另行制定合乎基督教道德倫理的網絡內容規範(包括網絡時代基督徒知識產權保護之建議和規則)，機構方所提供的一切內容將受該條款所規範。</p>

<p>7.     所有機構先自行在本網站上註冊、使用e-Land，惟權限有一定限制，並在其e-Land首頁和賬戶資料上註明『驗證中』，若機構提供足夠資料並通過驗證後，使用權限將得擴展。</p>

<p>8.     本網站不在任何機構的e-Land上提供任何形式的廣告；只會在公開區域劃定特別板塊予以有宣傳推廣需要的用戶以合宜方式發放資料。</p>

<p>9.     網站方將對任何假冒其他機構之行為主體予以必要的公示和嚴肅處理。</p>

<p>10.  本網站會定期出版全部機構/教會名錄類出版物，自行或與其他主內機構出版發行。出版前將知會各機構，若未按時收到反對被納入名錄的，將視為同意。若有更新資料，需及時提供。</p>

<p>11.  以上條款之解釋權歸哈利路亞國際事工有限公司；各機構可提供條款修改建議，本網站將在廣泛收集反饋之後，適時作出修改；若有任何條款之更新或修改，本網站將及時知會各機構，以使機構自行決定是否繼續使用本網站提供之服務。</p>

<p>12.  此使用條款不斷更新中，歡迎會員提出寶貴修改意見。</p>
    """;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: hex('#ccc'),
        appBar: customAppbar(context: context,title: '主內教會機構用戶條款 Terms and Conditions for Church/Organization Users'),
        body: Container(
          margin: const EdgeInsets.only(left: 10.0,right:10.0,top:10.0,bottom:10.0),
          padding: const EdgeInsets.only(left: 20.0,right:20.0,top:20.0,),
          color: hex('#fff'),
          width: G.screenWidth(),
          height: G.screenHeight(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: new Border(bottom: BorderSide(width: 1.0, color: hex('#cacbd1'))),
                    ),
                    padding: const EdgeInsets.only(bottom:15.0,),
                    margin: const EdgeInsets.only(bottom:10.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('主內教會機構用戶條款 Terms and Conditions for Church/Organization Users', style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 20.0,)),
//                          new Text(article.time, style: new TextStyle(color: Colors.black,fontWeight: FontWeight.normal, fontSize: 14.0,height:2)),
                      ],
                    ),
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom:15.0,),
//                    decoration: BoxDecoration(
//                      border: new Border(bottom: BorderSide(width: 1.0, color: hex('#cacbd1'))),
//                    ),
                    child: Html(
                        data: content_html,
                        onLinkTap: (url) {
                          // open url in a webview
                          print('url=====>${url}');
                        },
                        onImageTap: (src) {
                          // Display the image in large form.
                          print('src=====>${src}');
                        }
                    ),
                  ),
                ]),
          ),
        ),
        bottomNavigationBar: (userid > 0)?CustomNavbar(onTap:(index) {
          G.pushNamed(G.toobarRouteNameList[index]);
        }):null,
      );
  }



}

