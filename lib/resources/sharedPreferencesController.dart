import "package:shared_preferences/shared_preferences.dart";

class SharedPreferencesController {
  //Each preference in a individual object to know where is each preference
  static final email = "email";
  static final cellPhone = "cellPhone";
  static final fixedPhone = "fixedPhone";
  static final address = "address";
  static final username = "username";
  static final fullname = "fullname";
  static final avatarUrl = "avatarUrl";
  static final cart = "cart";
  static final logged = "logged";
  static final authKey = "authKey";

  //Logged
  static Future<bool> getPrefLogged() async {
    var result = await getBool(logged);
    if (result == null) {
      return false;
    }
    return result;
  }

  static Future<bool> setPrefLogged(bool value) async {
    return setBool(logged, value);
  }

  //Cart
  static Future<List<String>> getPrefCart() async {
    var result = await getStringList(cart);
    if (result == null) {
      return List();
    } else {
      return result;
    }
  }

  static Future<bool> setPrefCart(List<String> value) async {
    return setStringList(cart, value);
  }

  //Address
  static Future<String> getPrefAddress() async {
    return getString(address);
  }

  static Future<bool> setPrefAddress(String value) async {
    return setString(address, value);
  }

  //MainPhone
  static Future<String> getPrefCellPhone() async {
    return getString(cellPhone);
  }

  static Future<bool> setPrefCellPhone(String value) async {
    return setString(cellPhone, value);
  }

  //SecondaryPhone
  static Future<String> getPrefFixedPhone() async {
    return getString(fixedPhone);
  }

  static Future<bool> setPrefFixedPhone(String value) async {
    return setString(fixedPhone, value);
  }

  //Email
  static Future<String> getPrefEmail() async {
    return getString(email);
  }

  static Future<bool> setPrefEmail(String value) async {
    return setString(email, value);
  }

  //UserName
  static Future<String> getPrefUsername() async {
    return getString(username);
  }

  static Future<bool> setPrefUsername(String value) async {
    return setString(username, value);
  }

  //FullName
  static Future<String> getPrefFullname() async {
    return getString(fullname);
  }

  static Future<bool> setPrefFullname(String value) async {
    return setString(fullname, value);
  }

  //AuthKey
  static Future<String> getPrefAuthKey() async {
    return getString(authKey);
  }

  static Future<bool> setPrefAuthKey(String value) async {
    return setString(authKey, value);
  }

  //Avatar
  static Future<String> getPrefAvatarUrl() async {
    return getString(avatarUrl);
  }

  static Future<bool> setPrefAvatarUrl(String value) async {
    return setString(avatarUrl, value);
  }

  //GeneralActions
  static Future<String> getString(String key) async {
    var preference = await SharedPreferences.getInstance();
    var result = preference.getString(key);
    return result;
  }

  static Future<bool> setString(String key, String value) async {
    var preference = await SharedPreferences.getInstance();
    var result = await preference.setString(key, value);
    return result;
  }

  //GeneralActions
  static Future<bool> getBool(String key) async {
    var preference = await SharedPreferences.getInstance();
    var result = preference.getBool(key);
    return result;
  }

  static Future<bool> setBool(String key, bool value) async {
    var preference = await SharedPreferences.getInstance();
    var result = await preference.setBool(key, value);
    return result;
  }

  //GeneralActions
  static Future<double> getDouble(String key) async {
    var preference = await SharedPreferences.getInstance();
    var result = preference.getDouble(key);
    return result;
  }

  static Future<bool> setDouble(String key, double value) async {
    var preference = await SharedPreferences.getInstance();
    var result = await preference.setDouble(key, value);
    return result;
  }

  //GeneralActions
  static Future<List<String>> getStringList(String key) async {
    var preference = await SharedPreferences.getInstance();
    var result = preference.getStringList(key);
    return result;
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    var preference = await SharedPreferences.getInstance();
    var result = await preference.setStringList(key, value);
    return result;
  }

  static Future<bool> cleanAll() async {
    var preference = await SharedPreferences.getInstance();
    var result = await preference.clear();
    return result;
  }
}
