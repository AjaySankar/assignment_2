// State provider of an insta post.
import 'package:flutter/cupertino.dart';
import 'package:assignment_2/post/post.dart';

class PostModel extends ChangeNotifier {
  /// Internal, private state of the post.
  Post _post = Post();

  PostModel(Post initPost) {
    _post = Post.fromPost(initPost);
  }

  List<String> get comments => _post.comments;
  String get description => _post.description;
  List<String> get hashTags => _post.hashTags;
  int get postId => _post.id;
  int get userRating => _post.userRating;
  int get imageId => _post.image;

  void setPostId(int postId) {
    _post.setPostId(postId);
  }

  void addComment(String comment) {
    _post.addComment(comment);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void setUserRating(int rating) {
    _post.setUserRating(rating);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}