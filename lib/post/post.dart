class Post {

  List<String> comments = [];
  int ratingsCount = 0;
  List<String> hashTags = [];
  String description = '';
  int id = -1;
  int image = -1;

  Post(
       {this.comments,
        this.ratingsCount,
        this.description,
        this.id,
        this.image,
        this.hashTags}
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