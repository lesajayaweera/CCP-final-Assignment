import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/widget/profilePage/CertificateCard.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificateBanner extends StatelessWidget {
  final List<Map<String, dynamic>> certificates;

  const CertificateBanner({super.key, required this.certificates});

  @override
  Widget build(BuildContext context) {
    if (certificates.isEmpty) {
      return const Text('No approved certificates found.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Certificates and Competition',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...certificates.map((cert) {
          final createdAt = cert['createdAt'];
          String date = 'Unknown Date';
          if (createdAt != null) {
            date = (createdAt as Timestamp).toDate().toLocal().toString().split(
              ' ',
            )[0];
          }

          return CredentialCard(
            imageUrl: cert['certificateImageUrl'] ?? '',
            title: cert['title'] ?? 'Untitled',
            issuer: cert['issuedBy'] ?? 'Unknown',
            issueDate: date,
            onViewPressed: () {
              final url = cert['certificateImageUrl'];
              if (url != null) {
                // open in browser or use `url_launcher`
                launchUrl(Uri.parse(url));
              }
            },
          );
        }),
      ],
    );
  }
}
