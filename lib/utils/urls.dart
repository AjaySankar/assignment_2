// URLs used in the InstaPost App

class Urls {
  static const String queryBaseURL = "https://bismarck.sdsu.edu/api/instapost-query";
  static const String uploadBaseURL = "https://bismarck.sdsu.edu/api/instapost-upload";
  static const String register = uploadBaseURL + "/newuser";
  static const String addPost = uploadBaseURL + "/post";
  static const String uploadImage = uploadBaseURL + "/image";
  static const String getPost = queryBaseURL + "/post";
  static const String getImage = queryBaseURL + "/image";
  static const String ratePost = uploadBaseURL + "/rating";
  static const String commentPost = uploadBaseURL + "/comment";
  static const String getNickNames = queryBaseURL + "/nicknames";
  static const String getFriendPostIds = queryBaseURL + "/nickname-post-ids";
  static const String getHashTagCount = queryBaseURL + "/hashtag-count";
}