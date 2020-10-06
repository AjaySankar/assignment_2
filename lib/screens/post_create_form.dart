import 'package:flutter/material.dart';
import 'package:assignment_2/utils/validators.dart';
import 'package:assignment_2/utils/theme.dart';

enum Status {
  PostNotCreated,
  UploadingPost,
  PostUploadSuccess,
  PostUploadFailed
}

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final formKey = new GlobalKey<FormState>();
  String _postDescription;
  TextEditingController postDescriptionController = TextEditingController(text: '');

  @override
  void dispose() {
    postDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                    controller: postDescriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    maxLength: 144,
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
                    onPressed: () {},
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