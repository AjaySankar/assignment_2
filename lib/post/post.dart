// Post model
class Post {

  List<String> comments;
  int ratingsCount;
  List<String> hashTags;
  String description;
  int id;
  int image;
  int userRating;

  Post(
       {
         this.comments = const [],
         this.ratingsCount = 0,
         this.description = 'Default description',
         this.id = -1,
         this.image = -1,
         this.hashTags = const [],
         this.userRating = 0
       }
    );

  factory Post.fromJSON(Map postData) {
    return Post(
      comments: List<String>.from(postData['comments']),
      ratingsCount: postData['ratings-count'] ?? 0,
      description: postData['text'] ?? '',
      id: postData['id'] ?? -1,
      image: postData['image'] ?? -1,
      hashTags: List<String>.from(postData['hashtags']) ?? [],
      userRating: 0
    );
  }

  factory Post.fromPost(Post post) {
    return Post(
      comments: [...post.comments],
      ratingsCount: post.ratingsCount ?? 0,
      description: post.description ?? '',
      id: post.id ?? -1,
      image: post.image ?? -1,
      hashTags: post.hashTags ?? [],
      userRating: 0
    );
  }

  void addComment(String comment) {
    this.comments.add(comment);
  }

  void setPostId(int postId) {
    this.id = postId;
  }

  void setUserRating(int rating) {
    this.userRating = rating;
  }
}