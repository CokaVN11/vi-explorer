import 'package:flutter/material.dart';
import 'PassportScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenApp extends StatelessWidget {
  const ProfileScreenApp({super.key});

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This will clear all data stored in SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    clearSharedPreferences();
    return const MaterialApp(
      title: 'Profile Screen',
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profilePic.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hackathon Team: KocaKola',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to edit profile
              },
              child: const Text('Edit Profile'),
            ),
            ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PassportScreen()));
            }, child: const Text('MY PASSPORT')),
          ],
        ),
      ),
    );
  }
}
