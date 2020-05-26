import 'package:flutter/foundation.dart';

class Question with ChangeNotifier {
  @required
  final String question;
  @required
  final String answer1;
  @required
  final bool isAnswer1;
  @required
  final String answer2;
  @required
  final bool isAnswer2;
  @required
  final String answer3;
  @required
  final bool isAnswer3;
  @required
  final String answer4;
  @required
  final bool isAnswer4;
  @required
  final List<dynamic> pda;
  @required
  final String questionImageAsset;
  @required
  final String pdaImageAsset;

  Question(
      this.question,
      this.answer1,
      this.isAnswer1,
      this.answer2,
      this.isAnswer2,
      this.answer3,
      this.isAnswer3,
      this.answer4,
      this.isAnswer4,
      this.pda,
      this.questionImageAsset,
      this.pdaImageAsset);
}
