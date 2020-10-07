import 'package:flutter/material.dart';
import 'package:assignment_2/utils/validators.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/insta_post_requests/addPost.dart';
import 'package:assignment_2/insta_post_requests/addImageToPost.dart';

const int MAX_POST_LENGTH = 144;

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _postFormKey = new GlobalKey<FormState>();
  String _postDescription;
  TextEditingController postDescriptionController = TextEditingController(text: '');
  Status _createPostStatus = Status.NotRequested;
  AddInstaPost addPostHandle;

  @override
  void initState() {
    addPostHandle = AddInstaPost((Status registrationState) {
      setState(() {
        _createPostStatus = registrationState;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    postDescriptionController.dispose();
    super.dispose();
  }

  var showSnackBar = (text, context) => {
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${text}'),
          duration: Duration(seconds: 3),
        )
    )
  };

  @override
  Widget build(BuildContext context) {

    var uploadPost = () {
      final form = _postFormKey.currentState;
      if (form.validate()) {
        form.save();
        List<String> hashTags = getHashTags(_postDescription);
        addPostHandle.createInstaPost(_postDescription, hashTags).then((Map<String, dynamic> response) {
          print(response);
          if(!response['status']) {
            showSnackBar(response['message']??'Failed to register!!', context);
          }
          else {
            // Post created successfully. Now reset the state to upload image
            setState(() {
              _createPostStatus = Status.RequestInProcess;
            });
          }
        });
      }
    };

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _postFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Create Post",
                    style: TextStyle(
                        fontSize: 40,
                        color: getThemeColor()
                    )
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Say something with hashtags..",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                    ),
                    controller: postDescriptionController,
                    validator: validatePost,
                    onSaved: (value) => setState(() { _postDescription = postDescriptionController.text; }),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    maxLength: MAX_POST_LENGTH,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 10.0),
                Ink(
                  decoration: const ShapeDecoration(
                    color: const Color(0xfff4267B2),
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Colors.white,
                    onPressed: uploadPost,
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}