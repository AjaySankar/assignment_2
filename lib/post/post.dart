class Post {

  List<String> comments;
  int ratingsCount;
  List<String> hashTags;
  String description;
  int id;
  int image;

  Post(
       {
         this.comments = const [],
        this.ratingsCount = 0,
        this.description = 'Default description',
        this.id = -1,
        this.image = -1,
        this.hashTags = const []
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
    );
  }
}