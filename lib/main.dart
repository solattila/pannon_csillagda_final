import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pannoncsillagda/providers/questions.dart';
import 'package:pannoncsillagda/screens/main_menu_screen.dart';
import 'package:pannoncsillagda/screens/multi_player.dart';
import 'package:pannoncsillagda/screens/photo_album_screen.dart';
import 'package:pannoncsillagda/screens/single_player_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: [Locale('en'), Locale('hu')],
      path: 'lang',
      fallbackLocale: Locale('en'),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Questions(),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Pannon Observatory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'nasalization',
          primarySwatch: Colors.blue,
        ),
        home: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover
              )
            ),
            child: MyHomePage()),
        routes: {
          mainMenu.routeName: (ctx) => mainMenu(),
          SinglePlayerScreen.routeName: (ctx) => SinglePlayerScreen(),
          MultiPlayer.routeName: (ctx) => MultiPlayer(),
          PhotoAlbumScreen.routeName: (ctx) => PhotoAlbumScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final introkey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacementNamed(mainMenu.routeName);
  }

  Widget _buildImage(String assetname) {
    return Align(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 10),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            'assets/images/$assetname',
            width: MediaQuery.of(context).size.width * 0.9,
            alignment: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget buildRobot(){
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      width: MediaQuery.of(context).size.width*0.8,
      child: FlareActor("assets/animations/robot.flr",
        animation: "stand",),
    );


  }

  Widget buildIcon(){
    return Container(
      child: Center(child: FaIcon(FontAwesomeIcons.camera, color: Colors.white, size: 200,)),
    );


  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = const PageDecoration(
      boxDecoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
      ),
      titleTextStyle: TextStyle(
          fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white, backgroundColor: Colors.black38, ),
      bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white, backgroundColor: Colors.black54),
      descriptionPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      imagePadding: EdgeInsets.zero,

    );

    return IntroductionScreen(
      key: introkey,
      pages: [
        PageViewModel(
          title: 'introt1'.tr(),
          body: 'intro1'.tr(),
          image: buildRobot(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'introt2'.tr(),
          body: 'intro2'.tr(),
          image: _buildImage('singleintro.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'introt3'.tr(),
          body: 'intro3'.tr(),
          image: _buildImage('multiintro.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'introt4'.tr(),
          body: 'intro4'.tr(),
          image: buildIcon(),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('skip', style: TextStyle(color: Colors.white),).tr(),
      next: FaIcon(FontAwesomeIcons.arrowRight),
      done: const Text(
        'done',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ).tr(),
      dotsDecorator: const DotsDecorator(
          size: Size(10, 10),
          color: Colors.blue,
          activeSize: Size(22, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          )),
    );
  }
}

