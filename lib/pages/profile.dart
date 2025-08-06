import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/Athlete.dart';
import 'package:sport_ignite/model/CertificateInput.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/pages/dashboard.dart';
import 'package:sport_ignite/pages/manageMyNetwork.dart';
import 'package:sport_ignite/pages/settings.dart';
import 'package:sport_ignite/pages/veiwAthletes.dart';
import 'package:sport_ignite/widget/common/appbar.dart';
import 'package:sport_ignite/widget/profilePage/CertificateBanner.dart';
import 'package:sport_ignite/widget/profilePage/StarItem.dart';

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
    var data = await Users().getUserDetails(context, widget.role);
    setState(() {
      userData = data;
    });
  }

  void _showAddCertificatesDialog() {
    certificateInputs = [CertificateInput()];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 16,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade50,
                      Colors.white,
                      Colors.indigo.shade50,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade600,
                            Colors.indigo.shade600,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.workspace_premium,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Add Certificates",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Maximum 10 certificates allowed",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    SizedBox(
                      width: double.maxFinite,
                      height: 400,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: certificateInputs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Certificate header
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue.shade400,
                                              Colors.indigo.shade400,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${index + 1}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Certificate ${index + 1}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Input fields
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: "Certificate Title",
                                      prefixIcon: Icon(
                                        Icons.title,
                                        color: Colors.blue.shade600,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                    onChanged: (value) =>
                                        certificateInputs[index].title = value,
                                  ),
                                  const SizedBox(height: 16),

                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: "Issued By",
                                      prefixIcon: Icon(
                                        Icons.business,
                                        color: Colors.blue.shade600,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                    onChanged: (value) =>
                                        certificateInputs[index].issuer = value,
                                  ),
                                  const SizedBox(height: 20),

                                  // Upload buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildUploadButton(
                                          "Reference Letter",
                                          Icons.description,
                                          Colors.green,
                                          certificateInputs[index]
                                                  .referenceLetterImage !=
                                              null,
                                          () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                      type: FileType.image,
                                                      withData: true,
                                                    );
                                            if (result != null) {
                                              setStateDialog(() {
                                                certificateInputs[index]
                                                        .referenceLetterImage =
                                                    result.files.single.bytes;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildUploadButton(
                                          "Certificate",
                                          Icons.verified,
                                          Colors.orange,
                                          certificateInputs[index]
                                                  .certificateImage !=
                                              null,
                                          () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                      type: FileType.image,
                                                      withData: true,
                                                    );
                                            if (result != null) {
                                              setStateDialog(() {
                                                certificateInputs[index]
                                                        .certificateImage =
                                                    result.files.single.bytes;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Image previews
                                  if (certificateInputs[index]
                                              .referenceLetterImage !=
                                          null ||
                                      certificateInputs[index]
                                              .certificateImage !=
                                          null)
                                    Row(
                                      children: [
                                        if (certificateInputs[index]
                                                .referenceLetterImage !=
                                            null)
                                          Expanded(
                                            child: _buildImagePreview(
                                              certificateInputs[index]
                                                  .referenceLetterImage!,
                                              "Reference Letter",
                                            ),
                                          ),
                                        if (certificateInputs[index]
                                                    .referenceLetterImage !=
                                                null &&
                                            certificateInputs[index]
                                                    .certificateImage !=
                                                null)
                                          const SizedBox(width: 12),
                                        if (certificateInputs[index]
                                                .certificateImage !=
                                            null)
                                          Expanded(
                                            child: _buildImagePreview(
                                              certificateInputs[index]
                                                  .certificateImage!,
                                              "Certificate",
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Actions
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            label: const Text("Cancel"),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade600,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),

                          Column(
                            children: [
                              if (certificateInputs.length < 10)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setStateDialog(() {
                                      certificateInputs.add(CertificateInput());
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("Add Another"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 12),

                              _isSaving
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue.shade600,
                                            Colors.indigo.shade600,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Saving...",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ElevatedButton.icon(
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
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.warning_amber_rounded,
                                                    color:
                                                        Colors.orange.shade600,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Text(
                                                    "Incomplete Fields",
                                                  ),
                                                ],
                                              ),
                                              content: const Text(
                                                "Please fill out all fields and upload both files for each certificate.",
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue.shade600,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          return;
                                        }

                                        try {
                                          setState(() {
                                            _isSaving = true;
                                          });
                                          setStateDialog(() {});

                                          setState(() {
                                            submittedCertificates.addAll(
                                              certificateInputs,
                                            );
                                          });

                                          await Athlete.uploadCertificates(
                                            context,
                                            certificateInputs,
                                          );

                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                            
                                            showSnackBar(
                                              context,
                                              'Certificates uploaded successfully!',
                                              Colors.green,
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            showSnackBar(
                                              context,
                                              'Upload failed: $e',
                                              Colors.red,
                                            );
                                          }
                                        } finally {
                                          if (context.mounted) {
                                            setState(() {
                                              _isSaving = false;
                                            });
                                            setStateDialog(() {});
                                          }
                                        }
                                      },

                                      icon: const Icon(Icons.save),
                                      label: const Text("Save Certificates"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade600,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 3,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadButton(
    String label,
    IconData icon,
    Color color,
    bool hasFile,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(hasFile ? Icons.check_circle : icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: hasFile
            ? Colors.green.shade100
            : color.withOpacity(0.1),
        foregroundColor: hasFile ? Colors.green.shade700 : Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: hasFile ? Colors.green.shade300 : color.withOpacity(0.3),
            width: 1,
          ),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildImagePreview(Uint8List imageBytes, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              imageBytes,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
  // void _showAddCertificatesDialog() {
  //   certificateInputs = [CertificateInput()];
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setStateDialog) => Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           elevation: 16,
  //           child: SingleChildScrollView(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                   colors: [
  //                     Colors.blue.shade50,
  //                     Colors.white,
  //                     Colors.indigo.shade50,
  //                   ],
  //                 ),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Header
  //                   Container(
  //                     padding: const EdgeInsets.all(24),
  //                     decoration: BoxDecoration(
  //                       borderRadius: const BorderRadius.only(
  //                         topLeft: Radius.circular(20),
  //                         topRight: Radius.circular(20),
  //                       ),
  //                       gradient: LinearGradient(
  //                         colors: [Colors.blue.shade600, Colors.indigo.shade600],
  //                       ),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: Colors.white.withOpacity(0.2),
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: const Icon(
  //                             Icons.workspace_premium,
  //                             color: Colors.white,
  //                             size: 24,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 16),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const Text(
  //                                 "Add Certificates",
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 22,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 4),
  //                               Text(
  //                                 "Maximum 10 certificates allowed",
  //                                 style: TextStyle(
  //                                   color: Colors.white.withOpacity(0.8),
  //                                   fontSize: 14,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),

  //                   // Content
  //                   SizedBox(
  //                     width: double.maxFinite,
  //                     height: 400,
  //                     child: ListView.builder(
  //                       padding: const EdgeInsets.all(16),
  //                       itemCount: certificateInputs.length,
  //                       itemBuilder: (context, index) {
  //                         return Container(
  //                           margin: const EdgeInsets.only(bottom: 16),
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(16),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.black.withOpacity(0.05),
  //                                 blurRadius: 10,
  //                                 offset: const Offset(0, 2),
  //                               ),
  //                             ],
  //                             border: Border.all(
  //                               color: Colors.grey.shade200,
  //                               width: 1,
  //                             ),
  //                           ),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(20),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 // Certificate header
  //                                 Row(
  //                                   children: [
  //                                     Container(
  //                                       width: 32,
  //                                       height: 32,
  //                                       decoration: BoxDecoration(
  //                                         gradient: LinearGradient(
  //                                           colors: [
  //                                             Colors.blue.shade400,
  //                                             Colors.indigo.shade400,
  //                                           ],
  //                                         ),
  //                                         borderRadius: BorderRadius.circular(8),
  //                                       ),
  //                                       child: Center(
  //                                         child: Text(
  //                                           "${index + 1}",
  //                                           style: const TextStyle(
  //                                             color: Colors.white,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 16,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 12),
  //                                     Text(
  //                                       "Certificate ${index + 1}",
  //                                       style: TextStyle(
  //                                         fontSize: 18,
  //                                         fontWeight: FontWeight.w600,
  //                                         color: Colors.grey.shade800,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(height: 20),

  //                                 // Input fields
  //                                 TextField(
  //                                   decoration: InputDecoration(
  //                                     labelText: "Certificate Title",
  //                                     prefixIcon: Icon(
  //                                       Icons.title,
  //                                       color: Colors.blue.shade600,
  //                                     ),
  //                                     border: OutlineInputBorder(
  //                                       borderRadius: BorderRadius.circular(12),
  //                                       borderSide: BorderSide(
  //                                         color: Colors.grey.shade300,
  //                                       ),
  //                                     ),
  //                                     focusedBorder: OutlineInputBorder(
  //                                       borderRadius: BorderRadius.circular(12),
  //                                       borderSide: BorderSide(
  //                                         color: Colors.blue.shade600,
  //                                         width: 2,
  //                                       ),
  //                                     ),
  //                                     filled: true,
  //                                     fillColor: Colors.grey.shade50,
  //                                   ),
  //                                   onChanged: (value) =>
  //                                       certificateInputs[index].title = value,
  //                                 ),
  //                                 const SizedBox(height: 16),

  //                                 TextField(
  //                                   decoration: InputDecoration(
  //                                     labelText: "Issued By",
  //                                     prefixIcon: Icon(
  //                                       Icons.business,
  //                                       color: Colors.blue.shade600,
  //                                     ),
  //                                     border: OutlineInputBorder(
  //                                       borderRadius: BorderRadius.circular(12),
  //                                       borderSide: BorderSide(
  //                                         color: Colors.grey.shade300,
  //                                       ),
  //                                     ),
  //                                     focusedBorder: OutlineInputBorder(
  //                                       borderRadius: BorderRadius.circular(12),
  //                                       borderSide: BorderSide(
  //                                         color: Colors.blue.shade600,
  //                                         width: 2,
  //                                       ),
  //                                     ),
  //                                     filled: true,
  //                                     fillColor: Colors.grey.shade50,
  //                                   ),
  //                                   onChanged: (value) =>
  //                                       certificateInputs[index].issuer = value,
  //                                 ),
  //                                 const SizedBox(height: 20),

  //                                 // Upload buttons
  //                                 Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: _buildUploadButton(
  //                                         "Reference Letter",
  //                                         Icons.description,
  //                                         Colors.green,
  //                                         certificateInputs[index]
  //                                                 .referenceLetterImage !=
  //                                             null,
  //                                         () async {
  //                                           FilePickerResult? result =
  //                                               await FilePicker.platform
  //                                                   .pickFiles(
  //                                                     type: FileType.image,
  //                                                     withData: true,
  //                                                   );
  //                                           if (result != null) {
  //                                             setStateDialog(() {
  //                                               certificateInputs[index]
  //                                                       .referenceLetterImage =
  //                                                   result.files.single.bytes;
  //                                             });
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 12),
  //                                     Expanded(
  //                                       child: _buildUploadButton(
  //                                         "Certificate",
  //                                         Icons.verified,
  //                                         Colors.orange,
  //                                         certificateInputs[index]
  //                                                 .certificateImage !=
  //                                             null,
  //                                         () async {
  //                                           FilePickerResult? result =
  //                                               await FilePicker.platform
  //                                                   .pickFiles(
  //                                                     type: FileType.image,
  //                                                     withData: true,
  //                                                   );
  //                                           if (result != null) {
  //                                             setStateDialog(() {
  //                                               certificateInputs[index]
  //                                                       .certificateImage =
  //                                                   result.files.single.bytes;
  //                                             });
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(height: 16),

  //                                 // Image previews
  //                                 if (certificateInputs[index]
  //                                             .referenceLetterImage !=
  //                                         null ||
  //                                     certificateInputs[index].certificateImage !=
  //                                         null)
  //                                   Row(
  //                                     children: [
  //                                       if (certificateInputs[index]
  //                                               .referenceLetterImage !=
  //                                           null)
  //                                         Expanded(
  //                                           child: _buildImagePreview(
  //                                             certificateInputs[index]
  //                                                 .referenceLetterImage!,
  //                                             "Reference Letter",
  //                                           ),
  //                                         ),
  //                                       if (certificateInputs[index]
  //                                                   .referenceLetterImage !=
  //                                               null &&
  //                                           certificateInputs[index]
  //                                                   .certificateImage !=
  //                                               null)
  //                                         const SizedBox(width: 12),
  //                                       if (certificateInputs[index]
  //                                               .certificateImage !=
  //                                           null)
  //                                         Expanded(
  //                                           child: _buildImagePreview(
  //                                             certificateInputs[index]
  //                                                 .certificateImage!,
  //                                             "Certificate",
  //                                           ),
  //                                         ),
  //                                     ],
  //                                   ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),

  //                   // Actions
  //                   Container(
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey.shade50,
  //                       borderRadius: const BorderRadius.only(
  //                         bottomLeft: Radius.circular(20),
  //                         bottomRight: Radius.circular(20),
  //                       ),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         TextButton.icon(
  //                           onPressed: () => Navigator.of(context).pop(),
  //                           icon: const Icon(Icons.close),
  //                           label: const Text("Cancel"),
  //                           style: TextButton.styleFrom(
  //                             foregroundColor: Colors.grey.shade600,
  //                             padding: const EdgeInsets.symmetric(
  //                               horizontal: 20,
  //                               vertical: 12,
  //                             ),
  //                           ),
  //                         ),

  //                         Column(
  //                           children: [
  //                             if (certificateInputs.length < 10)
  //                               ElevatedButton.icon(
  //                                 onPressed: () {
  //                                   setStateDialog(() {
  //                                     certificateInputs.add(CertificateInput());
  //                                   });
  //                                 },
  //                                 icon: const Icon(Icons.add),
  //                                 label: const Text("Add Another"),
  //                                 style: ElevatedButton.styleFrom(
  //                                   backgroundColor: Colors.grey.shade600,
  //                                   foregroundColor: Colors.white,
  //                                   padding: const EdgeInsets.symmetric(
  //                                     horizontal: 20,
  //                                     vertical: 12,
  //                                   ),
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                   ),
  //                                 ),
  //                               ),
  //                             const SizedBox(width: 12),

  //                             _isSaving
  //                                 ? Container(
  //                                     padding: const EdgeInsets.symmetric(
  //                                       horizontal: 24,
  //                                       vertical: 12,
  //                                     ),
  //                                     decoration: BoxDecoration(
  //                                       gradient: LinearGradient(
  //                                         colors: [
  //                                           Colors.blue.shade600,
  //                                           Colors.indigo.shade600,
  //                                         ],
  //                                       ),
  //                                       borderRadius: BorderRadius.circular(10),
  //                                     ),
  //                                     child: const Row(
  //                                       mainAxisSize: MainAxisSize.min,
  //                                       children: [
  //                                         SizedBox(
  //                                           width: 16,
  //                                           height: 16,
  //                                           child: CircularProgressIndicator(
  //                                             strokeWidth: 2,
  //                                             valueColor:
  //                                                 AlwaysStoppedAnimation<Color>(
  //                                                   Colors.white,
  //                                                 ),
  //                                           ),
  //                                         ),
  //                                         SizedBox(width: 8),
  //                                         Text(
  //                                           "Saving...",
  //                                           style: TextStyle(
  //                                             color: Colors.white,
  //                                             fontWeight: FontWeight.w600,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   )
  //                                 : ElevatedButton.icon(
  //                                     onPressed: () async {
  //                                       bool allValid = certificateInputs.every(
  //                                         (c) =>
  //                                             c.title.trim().isNotEmpty &&
  //                                             c.issuer.trim().isNotEmpty &&
  //                                             c.referenceLetterImage != null &&
  //                                             c.certificateImage != null,
  //                                       );

  //                                       if (!allValid) {
  //                                         showDialog(
  //                                           context: context,
  //                                           builder: (context) => AlertDialog(
  //                                             shape: RoundedRectangleBorder(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(16),
  //                                             ),
  //                                             title: Row(
  //                                               children: [
  //                                                 Icon(
  //                                                   Icons.warning_amber_rounded,
  //                                                   color: Colors.orange.shade600,
  //                                                 ),
  //                                                 const SizedBox(width: 8),
  //                                                 const Text("Incomplete Fields"),
  //                                               ],
  //                                             ),
  //                                             content: const Text(
  //                                               "Please fill out all fields and upload both files for each certificate.",
  //                                             ),
  //                                             actions: [
  //                                               ElevatedButton(
  //                                                 onPressed: () =>
  //                                                     Navigator.of(context).pop(),
  //                                                 style: ElevatedButton.styleFrom(
  //                                                   backgroundColor:
  //                                                       Colors.blue.shade600,
  //                                                   shape: RoundedRectangleBorder(
  //                                                     borderRadius:
  //                                                         BorderRadius.circular(
  //                                                           8,
  //                                                         ),
  //                                                   ),
  //                                                 ),
  //                                                 child: const Text(
  //                                                   "OK",
  //                                                   style: TextStyle(
  //                                                     color: Colors.white,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         );
  //                                         return;
  //                                       }

  //                                       setState(() {
  //                                         _isSaving = true;
  //                                       });
  //                                       setStateDialog(() {});

  //                                       try {
  //                                         setState(() {
  //                                           submittedCertificates.addAll(
  //                                             certificateInputs,
  //                                           );
  //                                         });

  //                                         await Athlete.uploadCertificates(
  //                                           context,
  //                                           certificateInputs,
  //                                         );

  //                                         Navigator.of(context).pop();
  //                                       } finally {
  //                                         setState(() {
  //                                           _isSaving = false;
  //                                         });
  //                                         setStateDialog(() {});
  //                                       }
  //                                     },
  //                                     icon: const Icon(Icons.save),
  //                                     label: const Text("Save Certificates"),
  //                                     style: ElevatedButton.styleFrom(
  //                                       backgroundColor: Colors.blue.shade600,
  //                                       foregroundColor: Colors.white,
  //                                       padding: const EdgeInsets.symmetric(
  //                                         horizontal: 24,
  //                                         vertical: 12,
  //                                       ),
  //                                       shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(10),
  //                                       ),
  //                                       elevation: 3,
  //                                     ),
  //                                   ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildUploadButton(
  //   String label,
  //   IconData icon,
  //   Color color,
  //   bool hasFile,
  //   VoidCallback onPressed,
  // ) {
  //   return ElevatedButton.icon(
  //     onPressed: onPressed,
  //     icon: Icon(hasFile ? Icons.check_circle : icon, size: 18),
  //     label: Text(
  //       label,
  //       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  //     ),
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: hasFile
  //           ? Colors.green.shade100
  //           : color.withOpacity(0.1),
  //       foregroundColor: hasFile ? Colors.green.shade700 : Colors.grey.shade700,
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         side: BorderSide(
  //           color: hasFile ? Colors.green.shade300 : color.withOpacity(0.3),
  //           width: 1,
  //         ),
  //       ),
  //       elevation: 0,
  //     ),
  //   );
  // }

  // Widget _buildImagePreview(Uint8List imageBytes, String label) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.w500,
  //           color: Colors.grey.shade600,
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       Container(
  //         height: 80,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.1),
  //               blurRadius: 4,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: Image.memory(
  //             imageBytes,
  //             height: 80,
  //             width: double.infinity,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
                                    ? Center(
                                        child: const Icon(
                                          Icons.person,
                                          size: 150,
                                          color: Colors.white70,
                                        ),
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
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            // Navigate to edit profile page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsScreen(),
                              ),
                            );
                          },
                        ),
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 2,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Dashboard(role: widget.role, initialIndex: 2),
                                ),
                              );
                            },
                            child: Text("Connect with Athletes"),
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
                                  builder: (context) => Dashboard(role: widget.role, initialIndex: 4),
                                ),
                              );
                            },
                            child: Text("View Athlete"),
                          ),
                          const SizedBox(width: 10),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 2,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Dashboard(role: widget.role, initialIndex: 1),
                                ),
                              );
                            },
                            child: Text("Discover People"),
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
