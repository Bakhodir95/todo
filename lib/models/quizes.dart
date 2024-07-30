class Quiz {
  String id;
  String question;
  List<String> options;
  int correctOptionIndex;
  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });
}
