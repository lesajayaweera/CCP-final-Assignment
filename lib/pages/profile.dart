// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sport_ignite/model/Athlete.dart';
import 'package:sport_ignite/model/CertificateInput.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/pages/veiwAthletes.dart';
import 'package:sport_ignite/widget/common/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String role;
  late String? uid;
  ProfilePage({super.key, required this.role, this.uid});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<CertificateInput> certificateInputs = [CertificateInput()];
  List<CertificateInput> submittedCertificates = [];

  Map<String, dynamic>? userData;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    if (widget.uid != null) {
      var data = await Users().getUserDetailsByUIDAndRole(
        context,
        widget.uid!,
        widget.role,
      );
      setState(() {
        userData = data;
      });
    } else {
      var data = await Users().getUserDetails(context, widget.role);
      setState(() {
        userData = data;
      });
    }
    // var data = await Users().getUserDetails(context, widget.role);
    // setState(() {
    //   userData = data;
    // });
  }

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
                          Image.memory(
                            certificateInputs[index].referenceLetterImage!,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        if (certificateInputs[index].certificateImage != null)
                          Image.memory(
                            certificateInputs[index].certificateImage!,
                            height: 80,
                            fit: BoxFit.cover,
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
                                builder: (context) => AlertDialog(
                                  title: Text("Incomplete Fields"),
                                  content: Text(
                                    "Please fill out all fields and upload both files for each certificate.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            setState(() {
                              _isSaving = true;
                            });
                            setStateDialog(() {});

                            try {
                              setState(() {
                                submittedCertificates.addAll(certificateInputs);
                              });

                              await Athlete.uploadCertificates(
                                context,
                                certificateInputs,
                              );

                              Navigator.of(context).pop();
                            } finally {
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
                        color: Colors.blueGrey,
                        image:
                            (userData?['background'] != null &&
                                userData!['background'].toString().isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(userData!['background']),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child:
                          (userData?['background'] == null ||
                              userData!['background'].toString().isEmpty)
                          ? const Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                  image:
                                      (userData?['profile'] != null &&
                                          userData!['profile']
                                              .toString()
                                              .isNotEmpty)
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            userData!['profile'],
                                          ),
                                        )
                                      : null,
                                ),
                                child:
                                    (userData?['profile'] == null ||
                                        userData!['profile'].toString().isEmpty)
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userData?['name'] ?? "Guest",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text('Ignited'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    widget.role == 'Sponsor'
                        ? Text(
                            "${userData?['company']} - ${userData?['role']}" ??
                                '',
                          )
                        : Text(userData?['sport'] ?? ''),
                    Text(
                      "${userData?['city'] ?? 'city'}\n${userData?['province'] ?? 'province'}, Sri Lanka",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),
                    if (widget.role != 'Sponsor')
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
                    if (widget.role == 'Sponsor')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AthletesScreen(),
                                ),
                              );
                            },
                            child: Text("View Athlete"),
                          ),
                          const SizedBox(width: 10),

                          OutlinedButton(
                            onPressed: () {},
                            child: Text("Add Sections"),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: widget.role != 'Sponsor'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StatItem(
                                  value: 'Rs.0.00',
                                  label: 'Total Sponsored',
                                ),
                                VerticalDivider(),
                                StatItem(value: '0', label: 'Total Athletes'),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.role != 'Sponsor')
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: Athlete.getApprovedCertificates(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('No certificates found.');
                          }

                          return CertificateBanner(
                            certificates: snapshot.data!,
                          );
                        },
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
        }).toList(),
      ],
    );
  }
}

class CredentialCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String issuer;
  final String issueDate;
  final VoidCallback? onViewPressed;

  const CredentialCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.issuer,
    required this.issueDate,
    this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
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
              onPressed: onViewPressed,
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
