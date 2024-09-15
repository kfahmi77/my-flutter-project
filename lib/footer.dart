import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.black,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(FontAwesomeIcons.github, 'https://github.com/yourusername'),
              const SizedBox(width: 20),
              _buildSocialIcon(FontAwesomeIcons.linkedin, 'https://www.linkedin.com/in/yourprofile'),
              const SizedBox(width: 20),
              _buildSocialIcon(FontAwesomeIcons.twitter, 'https://twitter.com/yourusername'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} Khoirul Fahmi. All rights reserved.',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          const Text(
            'Made with 🩵 using Flutter',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
      child: FaIcon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}