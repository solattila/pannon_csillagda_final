import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pannoncsillagda/screens/multi_player.dart';
import 'package:pannoncsillagda/screens/photo_album_screen.dart';
import 'package:pannoncsillagda/screens/single_player_screen.dart';
import 'package:pannoncsillagda/widgets/texts.dart';
import 'package:pannoncsillagda/widgets/buttons.dart';

// ignore: camel_case_types
class mainMenu extends StatefulWidget {
  static const routeName = '/main_menu';

  @override
  _mainMenuState createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  void toMultiPlayer(context) {
    Navigator.of(context).pushReplacementNamed(MultiPlayer.routeName);
  }

  void toSinglePlayer(context) {
    Navigator.of(context).pushReplacementNamed(SinglePlayerScreen.routeName);
  }

  void toPhotoAlbum(context) {
    Navigator.of(context).pushNamed(PhotoAlbumScreen.routeName);
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xff191970), Color(0xff0000ff)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    var welcome = tr('welcome');
    var single = tr('single');
    var multi = tr('multi');
    var photo_main = tr('photo_main');
    var info_main = tr('info_main');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'app_name',
          style: new TextStyle(
              foreground: Paint()..shader = linearGradient, fontSize: 30),
        ).tr(),
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
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/festisite_nasa.png',
                  height: MediaQuery.of(context).size.height * 0.23,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Texts(welcome),
            ),
            Buttons(
              buttonText: single,
              buttonFunc: () => toSinglePlayer(context),
            ),
            Buttons(
              buttonText: multi,
              buttonFunc: () => toMultiPlayer(context),
            ),
            Buttons(
              buttonText: photo_main,
              buttonFunc: () => toPhotoAlbum(context),
            ),
            Buttons(
              buttonText: info_main,
              buttonFunc: () => infoScreen(context),
            ),
          ],
        ),
      ),
    );
  }

  void infoScreen(BuildContext context) {
    Dialog dialogWithImage = Dialog(
      child: Container(
        color: Colors.blueAccent,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.8,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Text(
                "info_main",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ).tr(),
            ),
            Container(
              margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height*0.6,
                child: SingleChildScrollView(
                    child: Text('information', style: TextStyle(fontSize: 20),).tr())),
            RaisedButton(
              color: Colors.indigoAccent,
              onPressed: () => Navigator.pop(context),
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

}
