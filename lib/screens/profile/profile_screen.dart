import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Replace this with actual Firebase user data
    final userName = "John Doe";
    final email = "john@example.com";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                "https://www.w3schools.com/howto/img_avatar.png",
              ),
            ),
            const SizedBox(height: 16),
            Text(userName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: const Text("My Favorites"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
  