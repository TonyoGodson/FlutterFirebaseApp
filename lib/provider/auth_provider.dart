import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_app/screens/otp_screen.dart';
import 'package:firebase_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider extends ChangeNotifier{

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _userId;
  String get userId => _userId!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthProvider(){
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
        try{
          await _firebaseAuth.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
                await _firebaseAuth.signInWithCredential(phoneAuthCredential);
              },
              verificationFailed: (error) {
                throw Exception(error.message);
              },
              codeSent: (verificationId, forceResendingToken) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(verificationId: verificationId)));
              },
              codeAutoRetrievalTimeout: (verificationId){}
          );
        } on FirebaseAuthException catch (e){
          showSnackBar(context, e.message.toString());
        }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;

      if(user != null){
        _userId = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e){
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}