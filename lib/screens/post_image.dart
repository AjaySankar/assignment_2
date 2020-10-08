import 'package:flutter/material.dart';
import 'package:assignment_2/network/getPostImage.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/image_io.dart';

class PostImage extends StatefulWidget {
  PostImage(this.imageId);
  final int imageId;

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {

  GetPostImage getPostImageHandle;

  @override
  void initState() {
    getPostImageHandle = GetPostImage((Status requestState) => {});
  }

  @override
  Widget build(BuildContext context) {

    var placeHolderImage = (IconData icon, [Color color = Colors.blue]) {
      return new FittedBox(
        fit: BoxFit.fitHeight,
        child: Icon(
          icon,
          color: color,
          size: 60,
        ),
      );
    };

    var getImageFromResponse = (response) {
      if(response['status']) {
        final base64EncodedImage = response['body']['image'];
        return Image.memory(
          base64Decode(base64EncodedImage),
          fit: BoxFit.fitHeight,
        );
      }
      return placeHolderImage(Icons.broken_image, Colors.red);
    };

    if(widget.imageId == -1) {
      return placeHolderImage(Icons.image);
    }

    Future<Map<String, dynamic>> _fetchPostImage = getPostImageHandle.getInstaPost(widget.imageId);
    return FutureBuilder<Map<String, dynamic>>(
        future: _fetchPostImage,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          Widget image;
          if(snapshot.hasData) {
            image = getImageFromResponse(snapshot.data);
          }
          else if(snapshot.hasError) {
            print(snapshot.data);
            image = placeHolderImage(Icons.broken_image, Colors.red);
          }
          else {
            image = SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            );
          }
          return image;
        }
    );
  }
}