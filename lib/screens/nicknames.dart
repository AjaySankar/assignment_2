import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getNickNames.dart';
import 'package:assignment_2/utils/circularProgress.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/screens/friend_feed.dart';

final int NO_NAMES_PER_ROW = 3;

class NickNames extends StatefulWidget {
  @override
  _NickNamesState createState() => _NickNamesState();
}

class _NickNamesState extends State<NickNames> {
  GetNickNames getNickNamesHandle;

  @override
  void initState() {
    super.initState();
    getNickNamesHandle = GetNickNames((Status requestState) => {});
  }

  Widget build(BuildContext context) {

    var buildNickNames = (response) {
      if(response['status']) {
        List<String> nickNames = [];
        response['body']['nicknames'].forEach((name) => nickNames.add(name.toString()));
        return _NickNameGrid(nickNames);
      }
      return getErrorScreen(response['message']);
    };

    Future<Map<String, dynamic>> _fetchNickNames = getNickNamesHandle.getNickNames();
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchNickNames,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Widget widget;
        if(snapshot.hasData) {
          widget = buildNickNames(snapshot.data);
        }
        else if(snapshot.hasError) {
          widget = getErrorScreen(snapshot.error);
        }
        else {
          widget = getCircularProgress();
        }
        return widget;
      },
    );
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