import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:typed_data';

import 'package:sport_ignite/widget/common/appbar.dart';

class ProfilePage extends StatefulWidget {

  final String role;
  const ProfilePage({required this.role});



  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<CertificateInput> certificateInputs = [CertificateInput()];
  List<CertificateInput> submittedCertificates = [];



  // method to show the Certification add  Dialog Box
  void _showAddCertificatesDialog() {
    certificateInputs = [CertificateInput()];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text("Add Certificates (Max 10)"),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: certificateInputs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Certificate ${index + 1}"),
                        TextField(
                          decoration: InputDecoration(labelText: "Title"),
                          onChanged: (value) =>
                              certificateInputs[index].title = value,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: "Issued By"),
                          onChanged: (value) =>
                              certificateInputs[index].issuer = value,
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                  type: FileType.image,
                                  withData: true,
                                );
                            if (result != null) {
                              setStateDialog(() {
                                certificateInputs[index].referenceLetterImage =
                                    result.files.single.bytes;
                              });
                            }
                          },
                          icon: Icon(Icons.upload_file),
                          label: Text("Upload Reference Letter"),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                  type: FileType.image,
                                  withData: true,
                                );
                            if (result != null) {
                              setStateDialog(() {
                                certificateInputs[index].certificateImage =
                                    result.files.single.bytes;
                              });
                            }
                          },
                          icon: Icon(Icons.upload_file),
                          label: Text("Upload Certificate"),
                        ),
                        if (certificateInputs[index].referenceLetterImage !=
                            null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reference Letter Preview:",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 4),
                                Image.memory(
                                  certificateInputs[index]
                                      .referenceLetterImage!,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        if (certificateInputs[index].certificateImage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Certificate Preview:",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 4),
                                Image.memory(
                                  certificateInputs[index].certificateImage!,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel"),
                  ),
                  if (certificateInputs.length < 10)
                    TextButton(
                      onPressed: () {
                        setStateDialog(() {
                          certificateInputs.add(CertificateInput());
                        });
                      },
                      child: Text("Add Another"),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        submittedCertificates.addAll(
                          certificateInputs.where(
                            (c) =>
                                c.title.isNotEmpty &&
                                c.issuer.isNotEmpty &&
                                c.referenceLetterImage != null &&
                                c.certificateImage != null,
                          ),
                        );
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCertificateCard(CertificateInput cert) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${cert.title}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text("Issued by: ${cert.issuer}"),
            SizedBox(height: 8),
            if (cert.referenceLetterImage != null) ...[
              Text(
                "Reference Letter:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Image.memory(cert.referenceLetterImage!, height: 100),
            ],
            if (cert.certificateImage != null) ...[
              SizedBox(height: 12),
              Text(
                "Certificate:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Image.memory(cert.certificateImage!, height: 100),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LinkedInAppBar(page: false,role: widget.role,),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 190,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('asset/image/background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('asset/image/profile.jpg'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Richie Lorie",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text('Ignited'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text("Cricketer"),
                          Text(
                            "Central College Anuradhapura\nAnuradhapura, Sri Lanka",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                              
                      children: [
                        OutlinedButton(
                          onPressed: _showAddCertificatesDialog,
                          child: Text("Add Certificates"),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text("Add Sections"),
                        ),
                      ],
                    ),
                    if (submittedCertificates.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text(
                              "Certificates",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...submittedCertificates
                                .map(_buildCertificateCard)
                                .toList(),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your Dashboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.star, size: 18, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    'ALL-STAR',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Stats card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                StatItem(value: '2,279,545', label: 'Total Runs'),
                                VerticalDivider(),
                                StatItem(
                                  value: '279,545',
                                  label: 'Total Matches',
                                ),
                                VerticalDivider(),
                                StatItem(value: '279,545', label: '100 s'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16,),
                          CertificateBanner(
                            issuedBy: 'Government',
                            competition: "100 Meters run",
                            date: DateTime.now(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CertificateInput {
  String title = '';
  String issuer = '';
  Uint8List? referenceLetterImage;
  Uint8List? certificateImage;
}

class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({required this.value, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}

// to display the certificates
class CertificateBanner extends StatelessWidget {
  final String issuedBy;
  // final Image logo;
  final String competition;
  final DateTime date;
  const CertificateBanner({
    required this.issuedBy,
    required this.competition,
    required this.date,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Certificates and Competition',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16,),
          CredentialCard(title: '100m Long Run',platformLogoUrl: 'asset/image/governmentLogo.png',issuer: 'Government', issueDate: 'Today',),
          CredentialCard(title: '100m Long Run',platformLogoUrl: 'asset/image/governmentLogo.png',issuer: 'Government', issueDate: 'Today',)
        ],
      ),
    );
  }
}

class CredentialCard extends StatelessWidget {
  final String platformLogoUrl;
  final String title;
  final String issuer;
  final String issueDate;

  const CredentialCard({
    super.key,
    required this.platformLogoUrl,
    required this.title,
    required this.issuer,
    required this.issueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(platformLogoUrl, width: 32, height: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(issuer, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              'Issued $issueDate',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new),
              label: const Text('Show credential'),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
