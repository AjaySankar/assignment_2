import 'package:flutter/material.dart';
import 'package:assignment_2/utils/validators.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/utils/input_decoration.dart';

enum Status {
  PostNotCreated,
  UploadingPost,
  PostUploadSuccess,
  PostUploadFailed
}

const int MAX_POST_LENGTH = 144;

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _postFormKey = new GlobalKey<FormState>();
  String _postDescription;
  TextEditingController postDescriptionController = TextEditingController(text: '');

  @override
  void dispose() {
    postDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var uploadPost = () {
      final form = _postFormKey.currentState;
      if (form.validate()) {
        form.save();
        print("All good");
        print(_postDescription);
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
                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Say something..",
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