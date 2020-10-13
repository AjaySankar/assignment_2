import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/network/getHashTags.dart';
import 'package:assignment_2/screens/hashtag_feed.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const int MAX_HASHTAG_BATCH_SIZE = 20;

class HashTagsTab extends StatefulWidget {
  const HashTagsTab({Key key}) : super(key: key);

  @override
  _HashTagsState createState() => _HashTagsState();
}

class _HashTagsState extends State<HashTagsTab> with AutomaticKeepAliveClientMixin<HashTagsTab>{
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

  var goToHashTagFeed = (BuildContext context, [String hashTag = '']) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HashTagFeed(hashTag),
        )
    );
  };

  Widget buildHashTags(BuildContext context) {
    return ListView.separated(
      itemCount: hashTags.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            margin: const EdgeInsets.only(right: 20),
            child: const Icon(FontAwesomeIcons.hashtag),
          ),
          title: Text('${hashTags[index]}'),
          onTap: () {
            goToHashTagFeed(context, hashTags[index]);
          }
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget getBottonNavigationBar() {
    return BottomAppBar(
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
    );
  }

  Widget getBody(BuildContext context) {
    if(_getHashTagCountRequestState == Status.RequestSuccessful) {
      return buildHashTags(context);
    }
    if(_getHashTagCountRequestState == Status.RequestFailed || _getHashTagsRequestedState == Status.RequestFailed) {
      return getErrorScreen('Failed to load hashtags');
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: getBody(context),
      bottomNavigationBar: getBottonNavigationBar(),
      floatingActionButton: getFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}