// This class is a singleton that can be used to store user data globally in the app.
class UserData {
  static final UserData userData = UserData.internal();
  factory UserData() => userData;
  UserData.internal();

  double? dailyCalories;

  void reset() {
    dailyCalories = null;
  }
  
}
