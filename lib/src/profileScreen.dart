import 'package:flutter/material.dart';
import 'PassportScreen.dart';

class ProfileScreenApp extends StatelessWidget {
  const ProfileScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Profile Screen',
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
