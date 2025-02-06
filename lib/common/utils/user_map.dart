import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_spot/models/user_model.dart';

class UserMap {
  static Future setUserMap(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', user.id);
    prefs.setString('userName', user.name);
    prefs.setString('userEmail', user.email);
    prefs.setInt('userRole', user.role);
    prefs.setString('userPhoto', user.photo?.path ?? "");
    prefs.setString('userCellphone', user.cellphone);
    prefs.setString('userDocument', user.document);
    prefs.setBool('userApproved', user.is_approved);
    prefs.setBool('userStatus', user.status);
    prefs.setString("userCreateAt", user.created_at.toString());
    prefs.setString("userUpdateAt", user.updated_at.toString());
  }

  static Future<UserModel> getUserMap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auxCreate = prefs.getString("userCreateAt");
    DateTime createAt =
        auxCreate == null ? DateTime.now() : DateTime.parse(auxCreate);
    var auxUpdate = prefs.getString("userCreateAt");
    DateTime updateAt =
        auxUpdate == null ? DateTime.now() : DateTime.parse(auxUpdate);

    return UserModel(
      id: prefs.getInt('userId') ?? 0,
      name: prefs.getString('userName') ?? "",
      email: prefs.getString('userEmail') ?? "",
      role: prefs.getInt('userRole') ?? 0,
      photo: prefs.getString('userPhoto') != null &&
              prefs.getString('userPhoto')!.isNotEmpty
          ? File(prefs.getString('userPhoto')!)
          : null,
      cellphone: prefs.getString('userCellphone') ?? "",
      document: prefs.getString('userDocument') ?? "",
      is_approved: prefs.getBool('userApproved') ?? false,
      status: prefs.getBool('userStatus') ?? true,
      created_at: createAt,
      updated_at: updateAt,
    );
  }

  static Future<void> removeUserMap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
    await prefs.remove('userPhoto');
    await prefs.remove('userCellphone');
    await prefs.remove('userDocument');
    await prefs.remove('userApproved');
    await prefs.remove('userStatus');
    await prefs.remove('userCellphone');
    await prefs.remove('userCreateAt');
    await prefs.remove('userUpdateAt');
  }
}
