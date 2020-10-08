import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getNickNames.dart';
import 'package:assignment_2/utils/circularProgress.dart';
import 'package:assignment_2/utils/errorScreen.dart';

final int NO_NAMES_PER_ROW = 3;

class NickNames extends StatefulWidget {
  @override
  _NickNamesState createState() => _NickNamesState();
}

class _NickNamesState extends State<NickNames> {
  GetNickNames getNickNamesHandle;

  @override
  void initState() {
    getNickNamesHandle = GetNickNames((Status requestState) => {});
  }

  Widget build(BuildContext context) {

    var buildNickNames = (response) {
      if(response['status']) {
        List<String> nickNames = [];
        response['body']['nicknames'].forEach((name) => nickNames.add(name.toString()));
        return _NickNameGrid(nickNames.sublist(1, 20));
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
    return GridView.count(
      crossAxisCount: NO_NAMES_PER_ROW,
      children: List.generate(nickNames.length, (index) {
        return _NickName(nickNames[index]);
      })
    );
  }
}

class _NickName extends StatelessWidget {
  final String nickName;

  _NickName(this.nickName);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        nickName,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}