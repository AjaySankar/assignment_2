import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/network/getHashTags.dart';

final int NO_HASHTAGS_PER_ROW = 3;

class HashTags extends StatefulWidget {
  const HashTags({Key key}) : super(key: key);

  @override
  _HashTagsState createState() => _HashTagsState();
}

class _HashTagsState extends State<HashTags> with AutomaticKeepAliveClientMixin<HashTags>{
  List<String> hashTags = [];
  Status _getHashTagCountRequestState = Status.NotRequested;
  Status _getHashTagsRequestedState = Status.NotRequested;
  int totalHashTagCount = 0;
  int startIndex = 0;
  final int hashtagBatchSize = 10;


  Future<int> _getHashTagCount() async {
    // await Future.delayed(Duration(seconds: 2));
    return await HashTagGetter((Status requestState) => {
      _getHashTagCountRequestState = requestState
    }).fetchHashTagCount();
  }

  @override
  void initState() {
    _getHashTagCount().then((data) =>
        setState(() {
          totalHashTagCount = data;
        }));
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    return Center(
      child: Text("$totalHashTagCount"),
    );
  }
}