import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSingInService {
  UserCredential? user;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  static Future singInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      final googleKey = await account?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleKey?.accessToken, idToken: googleKey?.idToken);

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return authResult.additionalUserInfo?.profile!.length;
    } catch (e) {
      return null;
    }
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }
}
