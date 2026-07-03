import 'package:flutter/material.dart';
import 'package:depi_project/core/constant/app_color.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 15),

            _buildFAQTile(
              "How can I book a new tour?",
              "You can book a tour by going to the Home screen, selecting your destination, choosing the date and available tour guide, and clicking 'Book Now'.",
            ),
            _buildFAQTile(
              "How do I change my account password?",
              "Go to Profile > Privacy & Security, then select 'Change Password' to update your credentials securely.",
            ),
            _buildFAQTile(
              "Can I cancel a booking?",
              "Yes, bookings can be cancelled up to 24 hours before the tour starts through the 'My Tours' section.",
            ),
            _buildFAQTile(
              "How to contact my assigned Tour Guide?",
              "Once your trip is confirmed, a direct chat option and contact phone number will appear inside your trip details in 'My Tours'.",
            ),

            const SizedBox(height: 40),

            const Text(
              "Still Need Help? Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 15),

            _buildContactCard(
              title: "Email Support",
              subtitle: "support@depiproject.com",
              icon: Icons.email_outlined,
              color: Appcolor.kred,
              onTap: () {
              },
            ),
            const SizedBox(height: 12),

            _buildContactCard(
              title: "WhatsApp Live Chat",
              subtitle: "+20 123 456 7890",
              icon: Icons.chat_bubble_outline_rounded,
              color: Colors.green,
              onTap: () {
                // هنا مستقبلاً نربط بـ url_launcher لفتح الواتساب مباشرة
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        shape: Border.all(color: Colors.transparent), // لإخفاء الخط الافتراضي عند الفتح
        collapsedShape: Border.all(color: Colors.transparent),
        title: Text(
          question,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        iconColor: Appcolor.kred,
        collapsedIconColor: Colors.grey,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(
              answer,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}