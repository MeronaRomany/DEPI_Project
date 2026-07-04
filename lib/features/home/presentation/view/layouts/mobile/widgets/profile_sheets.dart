import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:depi_project/core/constant/app_color.dart';

class ProfileSheets {
  //Bottom sheet of personal info
  static void showPersonalInformation(BuildContext context, String name, String email) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
              //   child: Container(
              //     width: 40,
              //     height: 4,
              //     decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              //   ),
              // ),
              const SizedBox(height: 16),
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.person_outline_rounded, 'Full Name', name),
              _buildInfoRow(Icons.email_outlined, 'Email Address', email),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

   //Bottom sheet of privacy&security
  static void showPrivacySecurity(BuildContext context, User? currentUser) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Privacy & Security',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.lock_reset_rounded, color: Appcolor.kred),
                title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Send reset link to your email'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () {
                  Navigator.pop(context);
                  if (currentUser?.email != null) {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: currentUser!.email!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset link sent to your email.')),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on_outlined, color: Appcolor.kred),
                title: const Text('Location Permissions', style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Manage map tracking for your tours'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location features are managed by your device settings.')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                title: const Text('Delete Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.red),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 22),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}