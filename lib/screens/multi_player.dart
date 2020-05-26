import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pannoncsillagda/helpers/dbhelper.dart';
import 'package:pannoncsillagda/models/photo.dart';
import 'package:pannoncsillagda/screens/main_menu_screen.dart';
import 'package:pannoncsillagda/screens/photo_album_screen.dart';
import 'package:pannoncsillagda/widgets/images.dart';
import 'package:pannoncsillagda/widgets/texts.dart';
import 'package:provider/provider.dart';
import '../providers/questions.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/buttons.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flare_flutter/flare_actor.dart';

var _score = 0;
var _questionCounter = 0;

class MultiPlayer extends StatefulWidget {
  static const routeName = '/multi-player';

  @override
  _MultiPlayerState createState() => _MultiPlayerState();
}

class _MultiPlayerState extends State<MultiPlayer> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _permissionRequest();
    dbHelper = DBHelper();
  }

  DBHelper dbHelper;
  String _result = '';

  pickImageFromGallery() {
    _permissionRequest();
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      var filePath = imgFile.path;
      Photo photo = Photo(0, filePath);
      dbHelper.save(photo);
    });
  }

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Pannon Csillagda',
    );
    var result = await permissionValidator.camera();
    if (result) {
      setState(() => _result = 'Permission accepted');
    }
  }

  void toPhotoAlbum(context){
    Navigator.of(context).pushNamed(PhotoAlbumScreen.routeName);
  }



  @override
  Widget build(BuildContext context) {


    final questions = Provider.of<Questions>(context);
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xff191970), Color(0xff0000ff)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'app_name',
          style: new TextStyle(foreground: Paint()
            ..shader = linearGradient),
        ).tr(),
        actions: <Widget>[
          IconButton(icon: FaIcon(FontAwesomeIcons.photoVideo), onPressed:() =>
          toPhotoAlbum(context)),
          IconButton(
              icon: FaIcon(FontAwesomeIcons.camera),
              onPressed: pickImageFromGallery)
        ],
      ),
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: StepProgressIndicator(
                totalSteps: 10,
                currentStep: (_questionCounter ~/ 2)+1,
                size: 20,
                selectedColor: Colors.black26,
                unselectedColor: Colors.black12,
                unselectedSize: 20,
                customStep: (index, color, _) => color == Colors.black26

                ? Container(
                  color: color,
                  child: FaIcon(FontAwesomeIcons.rocket, color: Colors.blue,),
                ) : Container(
                  color: color,
                  child: FaIcon(FontAwesomeIcons.rocket, color: Colors.grey[200],),
                )
              ),
            ),
            Images(questions.items[_questionCounter].questionImageAsset),
            Row(
              children: <Widget>[
                Texts(questions.items[_questionCounter].question),
                Container(
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width*0.25,
                  child: FlareActor("assets/animations/robot.flr",
                  animation: "think",),
                )
              ],
            ),
            Buttons(
              buttonText: questions.items[_questionCounter].answer1,
              buttonFunc: () =>
                  changeQuestion(questions.items[_questionCounter].isAnswer1),
            ),
            Buttons(
              buttonText: questions.items[_questionCounter].answer2,
              buttonFunc: () =>
                  changeQuestion(questions.items[_questionCounter].isAnswer2),
            ),
            Buttons(
              buttonText: questions.items[_questionCounter].answer3,
              buttonFunc: () =>
                  changeQuestion(questions.items[_questionCounter].isAnswer3),
            ),
            Buttons(
              buttonText: questions.items[_questionCounter].answer4,
              buttonFunc: () =>
                  changeQuestion(questions.items[_questionCounter].isAnswer4),
            ),
          ],
        ),
      ),
    );
  }

  void changeQuestion(bool isanswer) {
    if (isanswer) {
      _score++;
    }
    print(_score);

    setState(() {
      if (_questionCounter < 19) {
        _questionCounter++;
      } else {
        endQuiz(context);
      }
    });
    print(_questionCounter);
  }

  void endQuiz(BuildContext context) {
    Dialog dialogWithImage = Dialog(
      child: Container(
        color: Colors.blueAccent,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.6,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Text(
                "congrat",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ).tr(),
            ),
            Texts(tr('succespoint', args: [_score.toString()])),
            Container(
              height: 200,
              width: 300,
              child: Align(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/images/astronaut.gif',
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            RaisedButton(
              color: Colors.indigoAccent,
              onPressed: () => endQuizScreen(context),
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ).tr(),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialogWithImage);
  }

  void endQuizScreen(context) {
    _questionCounter = 0;
    _score = 0;
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(mainMenu.routeName);
  }
}
