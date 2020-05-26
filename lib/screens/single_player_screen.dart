import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_button/awesome_button.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pannoncsillagda/helpers/dbhelper.dart';
import 'package:pannoncsillagda/models/photo.dart';
import 'package:pannoncsillagda/providers/questions.dart';
import 'package:pannoncsillagda/widgets/buttons.dart';
import 'package:pannoncsillagda/widgets/images.dart';
import 'package:pannoncsillagda/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import './main_menu_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'photo_album_screen.dart';

var _questionCounter = 0;
bool isQuestion = false;
bool isPda = true;
var pdaCounter = 0;

class SinglePlayerScreen extends StatefulWidget {
  static const routeName = '/single-player';

  @override
  _SinglePlayerScreenState createState() => _SinglePlayerScreenState();
}

class _SinglePlayerScreenState extends State<SinglePlayerScreen> {
  void toPhotoAlbum(context) {
    Navigator.of(context).pushNamed(PhotoAlbumScreen.routeName);
  }

  @override
  initState() {
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
      appName: 'Easy Permission Validator',
    );
    var result = await permissionValidator.camera();
    if (result) {
      setState(() => _result = 'Permission accepted');
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<Questions>(context);
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xff191970), Color(0xff0000ff)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    var pdaLength = questions.items[_questionCounter].pda.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'app_name',
          style: new TextStyle(foreground: Paint()..shader = linearGradient),
        ).tr(),
        actions: <Widget>[
          IconButton(
              icon: FaIcon(FontAwesomeIcons.photoVideo),
              onPressed: () => toPhotoAlbum(context)),
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
                  currentStep: (_questionCounter ~/ 2),
                  size: 20,
                  selectedColor: Colors.black26,
                  unselectedColor: Colors.black12,
                  unselectedSize: 20,
                  customStep: (index, color, _) => color == Colors.black26
                      ? Container(
                          color: color,
                          child: FaIcon(
                            FontAwesomeIcons.rocket,
                            color: Colors.blue,
                          ),
                        )
                      : Container(
                          color: color,
                          child: FaIcon(
                            FontAwesomeIcons.rocket,
                            color: Colors.grey[200],
                          ),
                        )),
            ),
            AnimatedSwitcher(
              child: isPda
                  ? Images(questions.items[_questionCounter].pdaImageAsset)
                  : Images(
                      questions.items[_questionCounter].questionImageAsset),
              duration: Duration(seconds: 1),
            ),
            AnimatedSwitcher(
              child: isQuestion
                  ? Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Texts(questions.items[_questionCounter].question),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: FlareActor(
                                "assets/animations/robot.flr",
                                animation: "think",
                              ),
                            )
                          ],
                        ),
                        Buttons(
                          buttonText: questions.items[_questionCounter].answer1,
                          buttonFunc: () =>
                              questions.items[_questionCounter].isAnswer1
                                  ? changeQuestion()
                                  : showWrongToast(),
                        ),
                        Buttons(
                          buttonText: questions.items[_questionCounter].answer2,
                          buttonFunc: () =>
                              questions.items[_questionCounter].isAnswer2
                                  ? changeQuestion()
                                  : showWrongToast(),
                        ),
                        Buttons(
                          buttonText: questions.items[_questionCounter].answer3,
                          buttonFunc: () =>
                              questions.items[_questionCounter].isAnswer3
                                  ? changeQuestion()
                                  : showWrongToast(),
                        ),
                        Buttons(
                          buttonText: questions.items[_questionCounter].answer4,
                          buttonFunc: () =>
                              questions.items[_questionCounter].isAnswer4
                                  ? changeQuestion()
                                  : showWrongToast(),
                        ),
                      ],
                    )
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: FlareActor(
                              "assets/animations/robot.flr",
                              animation: "stand",
                            ),
                          ),
                          AwesomeButton(
                            blurRadius: 15.0,
                            splashColor: Color.fromRGBO(255, 255, 255, .4),
                            borderRadius: BorderRadius.circular(37.5),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            onTap: () => changePda(pdaLength),
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.01),
                              child: AutoSizeText(
                                questions.items[_questionCounter].pda[pdaCounter],
                                style: TextStyle(
                                  foreground: Paint()..shader = linearGradient,
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              duration: Duration(seconds: 1),
            )
          ],
        ),
      ),
    );
  }

  void changeQuestion() {
    setState(() {
      if (_questionCounter < 19) {
        _questionCounter++;
      } else {
        endQuiz(context);
      }
      isQuestion = false;
      isPda = true;
    });
  }

  void tapped() {
    print("button tapped!");
  }

  void showWrongToast() {
    Fluttertoast.showToast(
        msg: "Ezen még gondolkodjunk!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 25.0);
    print('Show toast');
  }

  void changePda(int pdaLen) {
    setState(() {
      if (pdaCounter < pdaLen - 1) {
        pdaCounter++;
      } else {
        pdaCounter = 0;
        isQuestion = true;
        isPda = false;
      }
    });
  }

  void endQuiz(BuildContext context) {
    Dialog dialogWithImage = Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ).tr(),
            ),
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
            Texts(tr('succes')),
            RaisedButton(
              color: Colors.blue,
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
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(mainMenu.routeName);
  }
}
