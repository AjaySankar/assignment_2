import 'package:flutter/material.dart';
import 'package:assignment_2/utils/validators.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/utils/image_io.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/addPost.dart';
import 'package:assignment_2/network/addImageToPost.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

const int MAX_POST_LENGTH = 144;

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _postFormKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); // Hack to show snack bar -> https://bit.ly/2SslerY
  String _postDescription;
  TextEditingController postDescriptionController = TextEditingController(text: '');
  Status _createPostStatus = Status.NotRequested;
  Status _uploadPostImageStatus = Status.NotRequested;
  AddInstaPost addPostHandle;
  AddImageToPost addImageToPostHandle;
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    Function setRequestStateCallBack = (Status requestState) {
      setState(() {
        _createPostStatus = requestState;
      });
    };
    Function setUploadImageStateCallBack = (Status requestState) {
      setState(() {
        _uploadPostImageStatus = requestState;
      });
    };
    addPostHandle = AddInstaPost(setRequestStateCallBack);
    addImageToPostHandle = AddImageToPost(setUploadImageStateCallBack);
  }

  @override
  void dispose() {
    postDescriptionController.dispose();
    super.dispose();
  }

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

    var showSnackBar = (text, context) => {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: text,
            duration: Duration(seconds: 3),
          )
      )
    };


    var getLoadingText = () {
      String _loadingMsg = '';
      if(_createPostStatus == Status.RequestInProcess) {
        _loadingMsg = 'Creating Post...';
      }
      if(_uploadPostImageStatus == Status.RequestInProcess) {
        _loadingMsg = 'Uploading Image...';
      }
      return _loadingMsg;
    };

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(getLoadingText())
      ],
    );

    var uploadImage = (int postId) {
      if(!(_image == null)) {
        try {
          String imageAsString = readImageAsBase64Encode(_image);
          addImageToPostHandle.uploadImage(
              imageAsString, postId).then((Map response) {
            print(response);
            if (!response['status']) {
              showSnackBar(
                  response['message'] ?? 'Failed to upload image!!',
                  context);
            }
            else {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          });
        }
        catch(e) {
          showSnackBar('Failed to upload image!!', context);
        }
      }
      else {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    };

    var uploadPost = () {
      final form = _postFormKey.currentState;
      if (form.validate()) {
        form.save();
        List<String> hashTags = getHashTags(_postDescription);
        addPostHandle.createInstaPost(_postDescription, hashTags).then((Map<String, dynamic> response) {
          // print(response);
          if(!response['status']) {
            showSnackBar(response['message']??'Failed to create post!!', context);
            return;
          }
          // Post created successfully.
          uploadImage(response['body']['id']);
        });
      }
    };

    var getAppBar = () {
      return AppBar(
        title: Text("InstaPost"),
        backgroundColor: getThemeColor(),
      );
    };

    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(),
      body: SafeArea(
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
                          Icons.add_photo_alternate,
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  ),
                  SizedBox(height: 20.0),
                  _createPostStatus == Status.RequestInProcess
                      || _uploadPostImageStatus == Status.RequestInProcess
                      ? loading :
                  Ink(
                    decoration: const ShapeDecoration(
                      color: const Color(0xfff4267B2),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.file_upload),
                      color: Colors.white,
                      onPressed: uploadPost,
                      tooltip: "Upload post",
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}