import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_share/simple_share.dart';
import 'dart:io';
import '../helpers/dbhelper.dart';
import '../models/photo.dart';
import 'dart:async';

class PhotoAlbumScreen extends StatefulWidget {
  static const routeName = '/photo-album';

  PhotoAlbumScreen() : super();

  @override
  _PhotoAlbumScreenState createState() => _PhotoAlbumScreenState();
}

class _PhotoAlbumScreenState extends State<PhotoAlbumScreen> {
  String _result = '';
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xff191970), Color(0xff0000ff)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  File pickedImage;

  Future<File> imageFile;
  Image image;
  DBHelper dbHelper;
  List<Photo> images;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _permissionRequest();
    images = [];
    dbHelper = DBHelper();
    refreshImages();
  }

  pickImageFromGallery() {
    _permissionRequest();
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      var filePath = imgFile.path;
      Photo photo = Photo(0, filePath);
      dbHelper.save(photo);
      refreshImages();
    });
  }

  refreshImages() {
    dbHelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Permission Validator',
    );
    var result = await permissionValidator.camera();
    if (result) {
      setState(() => _result = 'Permission accepted');
    }
  }



  @override
  Widget build(BuildContext context) {



    gridView() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: images.map((photo) {
            return GestureDetector(
              onTap: () => showImage(context, photo.photo_name),
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      File(photo.photo_name),
                      scale: 1.0,
                      width: MediaQuery.of(context).size.width * 0.4,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  )),
            );
          }).toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'app_name',
          style: new TextStyle(foreground: Paint()..shader = linearGradient),
        ).tr(),
        actions: <Widget>[
          IconButton(
              icon: FaIcon(FontAwesomeIcons.camera),
              onPressed: pickImageFromGallery)
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[Flexible(child: gridView())],
            ),
          ),
        ),
      ),
    );
  }

  void showImage(BuildContext context, String filepath) {
    Dialog dialogWithImage = Dialog(
      backgroundColor: Colors.black12.withOpacity(0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context, false),
        child: Container(
          height: MediaQuery.of(context).size.height*0.8,
          width: MediaQuery.of(context).size.width*0.9,
          child: DecoratedBox(
              position: DecorationPosition.background,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black38,
                image: DecorationImage(
                  image: FileImage(
                    File(filepath),
                    scale: 1.0,
                  ),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        final uri = Uri.file(filepath);
                        SimpleShare.share(uri: uri.toString(), msg: 'A Pannon Csillagdában Jártam!' );
                      } ,
                      icon: FaIcon(FontAwesomeIcons.share, color: Colors.white, size: 30,),
                      label: Text('Share').tr(), textColor: Colors.white,),
                ],
              )),
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => dialogWithImage);
  }







}
