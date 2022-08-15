import 'package:lemarirapi/constant_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Penyimpanan keadaan ketika aplikasi pertama kali dibuka maka akan menampilkan intro page
class SaveSetting {
  Future<bool> setFirstTimeOpenApp(bool isFirstTimeValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstTime, isFirstTimeValue);
    return true;
  }

  Future<bool> getFirstTimeOpenApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(isFirstTime) ?? true;
    return boolValue;
  }
}
