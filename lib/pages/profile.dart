// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sport_ignite/model/Athlete.dart';
import 'package:sport_ignite/model/CertificateInput.dart';
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

  Map<String, dynamic>? athleteData;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    var data = await Athlete.getAthleteDetails(context);
    setState(() {
      athleteData = data;
    });
  }

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

                  _isSaving
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            bool allValid = certificateInputs.every(
                              (c) =>
                                  c.title.trim().isNotEmpty &&
                                  c.issuer.trim().isNotEmpty &&
                                  c.referenceLetterImage != null &&
                                  c.certificateImage != null,
                            );

                            if (!allValid) {
                              showDialog(
                                context: context,
                                useRootNavigator: true,
                                builder: (context) => AlertDialog(
                                  title: const Text("Incomplete Fields"),
                                  content: const Text(
                                    "Please fill out all fields and upload both files for each certificate.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            // ✅ Show loading
                            setState(() {
                              _isSaving = true;
                            });
                            setStateDialog(() {}); // ✅ Rebuild dialog

                            try {
                              setState(() {
                                submittedCertificates.addAll(certificateInputs);
                              });

                              await Athlete.uploadCertificates(
                                context,
                                certificateInputs,
                              );

                              Navigator.of(context).pop(); // Close dialog
                            } finally {
                              // ✅ Hide loading
                              setState(() {
                                _isSaving = false;
                              });
                              setStateDialog(() {});
                            }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LinkedInAppBar(page: true, role: widget.role),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        color:
                            (athleteData?['background'] != null &&
                                athleteData!['background']
                                    .toString()
                                    .isNotEmpty)
                            ? null
                            : Colors.blueGrey,
                        image:
                            (athleteData?['background'] != null &&
                                athleteData!['background']
                                    .toString()
                                    .isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(athleteData!['background']),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child:
                          (athleteData?['background'] != null &&
                              athleteData!['background'].toString().isNotEmpty)
                          ? null
                          : const Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
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
                                width: 100, // adjust size as needed
                                height: 100,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.grey.shade300, // gray background
                                  shape: BoxShape.circle,
                                  image:
                                      (athleteData?['profile'] != null &&
                                          athleteData!['profile']
                                              .toString()
                                              .isNotEmpty)
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            athleteData!['profile'],
                                          ),
                                        )
                                      : null,
                                ),
                                child:
                                    (athleteData?['profile'] == null ||
                                        athleteData!['profile']
                                            .toString()
                                            .isEmpty)
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white70,
                                      )
                                    : null,
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
                                  athleteData?['name'] ?? "Guest",
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
                          Text(athleteData?['sport'] ?? ''),
                          Text(
                            "${athleteData?['city'] ?? 'city'}\n${athleteData?['province'] ?? 'province'}, Sri Lanka",
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
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
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
                                StatItem(
                                  value: '2,279,545',
                                  label: 'Total Runs',
                                ),
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
                          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          CredentialCard(
            title: '100m Long Run',
            platformLogoUrl: 'asset/image/governmentLogo.png',
            issuer: 'Government',
            issueDate: 'Today',
          ),
          CredentialCard(
            title: '100m Long Run',
            platformLogoUrl: 'asset/image/governmentLogo.png',
            issuer: 'Government',
            issueDate: 'Today',
          ),
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
