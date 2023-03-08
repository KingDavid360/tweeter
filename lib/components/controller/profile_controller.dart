import 'package:get/get.dart';
import 'package:twitter_app/components/controller/authentication.dart';
import 'package:twitter_app/components/controller/user.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _auth = Get.put(Authentication());
  final _user = Get.put(User());

  getUserData() {
    final email = _auth.firebaseUser.value?.email;
    if (email != null) {
      return _user.getUserDetails(email);
    } else {
      Get.snackbar("Error", "login to continue");
    }
  }
}
