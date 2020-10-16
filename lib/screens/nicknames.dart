import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getNickNames.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/screens/friend_feed.dart';

const int NO_NAMES_PER_ROW = 3;

class NickNames extends StatefulWidget {
  const NickNames({Key key}) : super(key: key);

  @override
  _NickNamesState createState() => _NickNamesState();
}

class _NickNamesState extends State<NickNames> with AutomaticKeepAliveClientMixin<NickNames>{
  List<String> nickNames = [];
  Status _getNickNamesRequestState = Status.NotRequested;
  Future<List<String>> _getNickNames() async {
    // await Future.delayed(Duration(seconds: 2));
    return await GetNickNames((Status requestState) {
      if(!this.mounted) return;
      setState(() {
        _getNickNamesRequestState = requestState;
      });
    }).fetchNickNames();
  }


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _getNickNames().then((data) {
      if(!this.mounted) return;
      setState(() {
        nickNames = data;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    super.build(context);
    Widget widget;
    switch(_getNickNamesRequestState) {
      case Status.RequestSuccessful:
        widget = _NickNameGrid(nickNames);
        break;
      case Status.RequestFailed:
        widget =  getErrorScreen('Failed to load nicknames');
        break;
      default:
      widget = Center(child: CircularProgressIndicator());
    }
    return widget;
  }
}

class _NickNameGrid extends StatelessWidget {
  final List<String> nickNames;

  _NickNameGrid(this.nickNames);

  @override
  Widget build(BuildContext context) {

    var goToFriendFeed = ([String nickName = '']) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendFeed(nickName),
          )
      );
    };

    return GridView.count(
      crossAxisCount: NO_NAMES_PER_ROW,
      children: List.generate(nickNames.length, (index) {
        return _NickName(nickNames[index], goToFriendFeed);
      })
    );
  }
}

class _NickName extends StatelessWidget {
  final String nickName;
  final Function goToMyFeedPage;
  _NickName(this.nickName, this.goToMyFeedPage);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          child: InkWell(
            splashColor: getThemeColor().withAlpha(30),
            onTap: () {
              this.goToMyFeedPage(nickName);
            },
            child: Center(
                child: Text(
                    nickName
                )
            ),
          ),
        ),
      ),
    );
  }
}