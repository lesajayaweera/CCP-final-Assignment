// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:sport_ignite/model/Athlete.dart';
import 'package:sport_ignite/model/ConnectionService.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/widget/common/appbar.dart';
import 'package:sport_ignite/widget/profilePage/CertificateBanner.dart';

import 'package:sport_ignite/widget/profilePage/StarItem.dart';

class ProfileView extends StatefulWidget {
  final String role;
  final String? uid;

  ProfileView({super.key, required this.role, required this.uid});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, dynamic>? userData;

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
  }

  Future<List<Map<String, dynamic>>> loadCertificates() async {
    if (widget.uid != null) {
      try {
        return await Athlete.getApprovedCertificatesBYuid(widget.uid!);
      } catch (e) {
        print('Error loading certificates: $e');
      }
    }
    return [];
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
              // Background and profile image section
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

              // Name, city, and other info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData?['name'] ?? "Guest",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    widget.role == 'Sponsor'
                        ? Text("${userData?['company']} - ${userData?['role']}")
                        : Text(userData?['sport'] ?? ''),
                    Text(
                      "${userData?['city'] ?? 'city'}\n${userData?['province'] ?? 'province'}, Sri Lanka",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      child: Row(children: [
                        ElevatedButton(onPressed: () {
                          ConnectionService.sendConnectionRequestUsingUID(context, widget.uid!);
                        }, child: const Text("Connect"))
                      ]),
                    ),

                    // Stats
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
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
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

                    // Certificates
                    if (widget.role != 'Sponsor')
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: loadCertificates(),
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

// Stat display widget
