import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
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
      appBar: AppBar(title: Text('User profile'), centerTitle: true),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
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
            Expanded(
              flex: 3,
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
                      const SizedBox(width: 10,),
                      OutlinedButton(
                        onPressed: (){},
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
                              'Yuor Dashboard',
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
                              StatItem(value: '279,545', label: 'Total Matches'),
                              VerticalDivider(),
                              StatItem(value: '279,545', label: '100 s'),
                            ],
                          ),
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
    );

    // return Scaffold(
    //   body: Column(
    //     children: [
    //       _topHeader(context),
    //       SizedBox(height: 60),
    //       Center(
    //         child: Text(
    //           "KUMAR SANGAKKAR · 3rd",
    //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       Center(child: Text("Cricketer")),
    //       Center(
    //         child: Text(
    //           "Central College Anuradhapura\nAnuradhapura, Sri Lanka",
    //           textAlign: TextAlign.center,
    //           style: TextStyle(color: Colors.grey[700]),
    //         ),
    //       ),
    //       SizedBox(height: 8),
    //       Center(
    //         child: Text(
    //           "2,900 followers • 1,300 connections",
    //           style: TextStyle(color: Colors.blue),
    //         ),
    //       ),
    //       SizedBox(height: 10),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           OutlinedButton(
    //             onPressed: _showAddCertificatesDialog,
    //             child: Text("Add Certificates"),
    //           ),
    //         ],
    //       ),
    //       if (submittedCertificates.isNotEmpty)
    //         Padding(
    //           padding: const EdgeInsets.all(12.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Divider(),
    //               Text(
    //                 "Certificates",
    //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //               ),
    //               ...submittedCertificates.map(_buildCertificateCard).toList(),
    //             ],
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }
}

class CertificateInput {
  String title = '';
  String issuer = '';
  Uint8List? referenceLetterImage;
  Uint8List? certificateImage;
}

Widget _topHeader(BuildContext context) {
  return Stack(
    fit: StackFit.expand,
    children: [
      Container(
        margin: const EdgeInsets.only(bottom: 50),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xff0043ba), Color(0xff006df1)],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    ],
  );
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
