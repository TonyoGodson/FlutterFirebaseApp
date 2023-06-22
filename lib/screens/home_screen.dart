import 'package:firebase_flutter_app/provider/auth_provider.dart';
import 'package:firebase_flutter_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: const Text("Flutter Phone Auth"),
          actions: [
            IconButton(
                onPressed: () {
                  ap.userSignOut().then((value) => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen())));
                },
                icon: const Icon(Icons.exit_to_app)),
          ],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black26,
              backgroundImage: NetworkImage(ap.userModel.profilePic),
              radius: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(ap.userModel.name),
            Text(ap.userModel.phoneNumber),
            Text(ap.userModel.email),
            Text(ap.userModel.bio),
          ],
        )));
  }
}
