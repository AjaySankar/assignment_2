// Shows list of hashtags from an API call.
// Fetch hashtags batchwise on demand(on clicking a fab).
import 'dart:math';
import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/network/getHashTags.dart';
import 'package:assignment_2/screens/hashtag_feed.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const int MAX_HASHTAG_BATCH_SIZE = 100;

class HashTagsTab extends StatefulWidget {
  const HashTagsTab({Key key}) : super(key: key);

  @override
  _HashTagsState createState() => _HashTagsState();
}

class _HashTagsState extends State<HashTagsTab> with AutomaticKeepAliveClientMixin<HashTagsTab>{
  List<String> hashTags = [];
  Status _getHashTagsRequestedState = Status.NotRequested;
  int totalHashTagCount;
  int startIndex = 0;
  HashTagGetter hashTagGetter;

  // Fetch hashtags withing a range.
  Future<List<String>> _getHashTags(int endHashTagsIndex) async {
    return await hashTagGetter.fetchHashTags(startIndex, endHashTagsIndex);
  }

  // Add fetched hashtags to current list.
  void addMoreHashTags(List<String> fetchedHashTags) {
    if(_getHashTagsRequestedState == Status.RequestSuccessful) {
      if(!this.mounted) return;
      setState(() {
        hashTags = [...hashTags, ...fetchedHashTags];
        startIndex = startIndex+MAX_HASHTAG_BATCH_SIZE;
      });
    }
  }

  @override
  void initState() {
    hashTagGetter = HashTagGetter((Status requestState) {
      if(!this.mounted) return;
      setState(() {
        _getHashTagsRequestedState = requestState;
      });
    });
    getMoreHashTags();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  // Adjust batch size and request for hashtags.
  void getMoreHashTags() async {
    int totalHashTagCount = await hashTagGetter.fetchHashTagCount();
    int endHashTagIndex = min(startIndex+MAX_HASHTAG_BATCH_SIZE, totalHashTagCount);
    if(totalHashTagCount >= 0 && startIndex < endHashTagIndex && endHashTagIndex <= totalHashTagCount) {
      _getHashTags(endHashTagIndex).then(addMoreHashTags);
    }
  }

  Widget getFAB() {
    // FAB to get more hashtags on demand.
    if(_getHashTagsRequestedState == Status.RequestInProcess) {
      // Show circular loader when fetching more hashtags.
      return FloatingActionButton(
          heroTag: "Hashtag feed fab",
          backgroundColor: getThemeColor(),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(getThemeColor()),
            backgroundColor: Colors.white,
          ),
      );
    }
    return FloatingActionButton(
      heroTag: "Hashtag feed fab",
      backgroundColor: getThemeColor(),
      child: Icon(FontAwesomeIcons.getPocket),
        onPressed: getMoreHashTags
    );
  }

  // Go to hashtag feed on clicking on a hashtag.
  void goToHashTagFeed(BuildContext context, [String hashTag = '']) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HashTagFeed(hashTag),
        )
    );
  }

  // Build list of fetched hashtags
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

  //Bottom navigation bar.
  //Apparently, the bottom nav bar needs at least one icon. So added an invisible iconbutton.
  Widget getBottonNavigationBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        children: [
          Spacer(),
          Opacity(
            opacity: 0.0,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: (){},
            ),
          )
        ],
      ),
    );
  }

  Widget getBody(BuildContext context) {
    Widget body;
    switch(_getHashTagsRequestedState) {
      case Status.RequestSuccessful:
        body = buildHashTags(context);
        break;
      case Status.RequestFailed:
        body = getErrorScreen('Failed to load hashtags');
        break;
      default:
        body = Center(child: CircularProgressIndicator());
    }
    return body;
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