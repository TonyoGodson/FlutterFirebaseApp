import 'package:firebase_flutter_app/screens/user_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/utils.dart';
import '../widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
        body: SafeArea(
        child: isLoading == true ? const Center(
            child: CircularProgressIndicator(color: Colors.black38))
                : Center(
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
    child: Expanded(
        child:Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back),),
          ),
          Container(
            width: 400,
            height: 200,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.transparent.withOpacity(0.0)
            ),
            child: Image.asset("assets/img.png",
              height: 50,),
          ),
          const SizedBox(height: 20,),
          const Text("Verification",
            style: TextStyle(fontSize: 22,
                fontWeight: FontWeight.bold),),
          const Text("Enter the OTP sent to your phone number",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
          const SizedBox(height: 20,),
          Pinput(
            length: 6,
            showCursor: true,
            defaultPinTheme: PinTheme(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all( color: Colors.black38)
                ),
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                )
            ),
            onCompleted: (value){
              setState(() {
                otpCode = value;
              });
              },
          ),
          const SizedBox(height:  25,),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: CustomButton(text: "Verify", onPressed: () {
                if(otpCode != null){
                  verifyUserOtp(context, otpCode!);
                } else {
                  showSnackBar(context, "Enter 6 - Digit code");
                }
              },)
          ),
          const SizedBox(height: 20,),
          const Text("Didn't receive any code?",
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
          ),
          const SizedBox(height: 12,),
          const Expanded(child: Text("Resend Code",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
          )
          ),
    ]))))));
  }
  void verifyUserOtp(BuildContext context, String userOtp) {
      final ap = Provider.of<AuthProvider>(context, listen: false);
      ap.verifyOtp(context: context,
          verificationId: widget.verificationId,
          userOtp: userOtp,
          onSuccess: () {
            ap.checkExistingUser().then((value) async {
              if(value ==  true) {

              } else {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) => const UserInformationScreen()), (route) => false);
              }
            });
          });
  }
}
