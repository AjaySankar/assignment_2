import 'package:flutter/material.dart';
import 'package:assignment_2/utils/validators.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/utils/image_io.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/insta_post_requests/addPost.dart';
import 'package:assignment_2/insta_post_requests/addImageToPost.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
  AddImageToPost addImageToPostHandle;
  File _image;
  final picker = ImagePicker();
  Uint8List _encodedImage;

  Future getImage() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    Uint8List encodedImage = image.readAsBytesSync();
    setState(() {
      _image = image;
      _encodedImage = encodedImage;
    });
  }

  @override
  void initState() {
    Function setRequestStateCallBack = (Status requestState) {
      setState(() {
        _createPostStatus = requestState;
      });
    };
    addPostHandle = AddInstaPost(setRequestStateCallBack);
    addImageToPostHandle = AddImageToPost(setRequestStateCallBack);
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImage();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        }
    );
  }

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
            // Post created successfully. Now reset the state to indicate upload image is in process.
            setState(() {
              _createPostStatus = Status.RequestInProcess;
            });
            String imageAsString = readImageAsBase64Encode(_image);
            addImageToPostHandle.uploadImage(imageAsString, response['body']['id']).then((value) {
              print(response);
              if(!response['status']) {
                showSnackBar(response['message']??'Failed to register!!', context);
              }
              else{
                print("Image Upload successful");
              }
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
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: _image != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        _image,
                        width: 200,
                        height: 200,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15)),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
                  )
                ),
                SizedBox(height: 30.0),
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