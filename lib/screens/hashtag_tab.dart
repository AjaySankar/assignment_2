import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/network/getHashTags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final int NO_HASHTAGS_PER_ROW = 3;
const int MAX_HASHTAG_BATCH_SIZE = 10;

class HashTags extends StatefulWidget {
  const HashTags({Key key}) : super(key: key);

  @override
  _HashTagsState createState() => _HashTagsState();
}

class _HashTagsState extends State<HashTags> with AutomaticKeepAliveClientMixin<HashTags>{
  List<String> hashTags = [];
  Status _getHashTagCountRequestState = Status.NotRequested;
  Status _getHashTagsRequestedState = Status.NotRequested;
  int totalHashTagCount;
  int startIndex = 0;

  Future<int> _getHashTagCount() async {
    // await Future.delayed(Duration(seconds: 2));
    return await HashTagGetter((Status requestState) => {
      setState(() {
        _getHashTagCountRequestState = requestState;
      })
    }).fetchHashTagCount();
  }

  Future<List<String>> _getHashTags([int startIndex = 0, int requestedBatchSize = MAX_HASHTAG_BATCH_SIZE]) async {
    return await HashTagGetter((Status requestState) {
      setState(() {
        _getHashTagsRequestedState = requestState;
      });
    }).fetchHashTags(startIndex, startIndex+requestedBatchSize);
  }

  void addMoreHashTags(List<String> fetchedHashTags) {
    if(_getHashTagsRequestedState == Status.RequestSuccessful) {
      setState(() {
        hashTags = [...hashTags, ...fetchedHashTags];
        startIndex = startIndex+MAX_HASHTAG_BATCH_SIZE;
        _getHashTagsRequestedState = Status.NotRequested;
      });
    }
  }

  @override
  void initState() {
    _getHashTagCount().then((data) {
      setState(() {
        totalHashTagCount = data;
      });
      if(data > 0) {
        _getHashTags(startIndex).then(addMoreHashTags);
      }
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void getMoreHashTags() {
    _getHashTags(startIndex).then(addMoreHashTags);
  }

  Widget getFAB() {
    if(_getHashTagsRequestedState == Status.RequestInProcess) {
      return FloatingActionButton(
          backgroundColor: getThemeColor(),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(getThemeColor()),
            backgroundColor: Colors.white,
          ),
          onPressed: getMoreHashTags
      );
    }
    return FloatingActionButton(
      backgroundColor: getThemeColor(),
      child: Icon(FontAwesomeIcons.getPocket),
        onPressed: getMoreHashTags
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(hashTags.join(',')),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            Spacer(),
            Opacity(
              opacity: 0.0,
              child: IconButton(icon: Icon(Icons.search)),
            )
          ],
        ),
      ),
      floatingActionButton: getFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}