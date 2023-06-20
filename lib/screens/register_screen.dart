import 'package:firebase_flutter_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
      phoneCode: "234",
      countryCode: "NG",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Nigeria",
      example: "Nigeria",
      displayName: "Nigeria",
      displayNameNoCountryCode: "NG",
      e164Key: ""
  );
  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length)
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Expanded(
                child:Column(children: [
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
                const Text("Register",
                  style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.bold),),
                const Text("Add your phone number, we will send you a verification code",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                TextFormField(
                  keyboardType:TextInputType.number,
                  style: const TextStyle(fontSize: 22),
                  cursorColor: Colors.black,
                  controller: phoneController,
                  onChanged: (value){
                    setState(() {
                      phoneController.text = value;
                    });
                    },
                  decoration: InputDecoration(
                    hintText: "Enter Phone number",
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade600),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12)
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          showCountryPicker(
                              countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 450),
                              context: context,
                              onSelect: (value){
                                setState(() {
                                  selectedCountry = value;
                                });
                              });
                          },
                        child: Text("${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.normal
                          ),),
                      ),
                    ),
                    suffixIcon: phoneController.text.length > 9 ? Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      child: const Icon(Icons.done,
                        color: Colors.white,
                        size: 20,),
                    ) : null,
                  ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(text: "Login", onPressed: () => sendPhoneNumber()),
              )
            ],)),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
