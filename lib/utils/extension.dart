extension ExtString on String {
  bool get isValidTitle {
    final titleRegExp = RegExp(r'^[A-Za-z0-9].{7,}$');
    return titleRegExp.hasMatch(this);
  }

  bool get isValidPoints {
    final pointsRegExp = RegExp(r'^\d{1,2}$');
    return pointsRegExp.hasMatch(this);
  }

  bool get isValidOption {
    final optionsRegExp = RegExp(r'^.{2,}$');
    return optionsRegExp.hasMatch(this);
  }
}
