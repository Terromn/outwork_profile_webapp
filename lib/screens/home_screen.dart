import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outwork_mx_profile_webapp/assets/app_color_palette.dart';
import 'package:outwork_mx_profile_webapp/utils/te_media_query.dart';
import 'package:outwork_mx_profile_webapp/widgets/te_spacer.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = FirebaseStorage.instance;
  // ignore: unused_field
  late Reference _storageRef;

  late User _user;
  String _userName = '';
  String _userUsername = '';
  String _membershipText = '';
  int _creditsAvailable = 0;
  late String _uid;
  late String _profilePicturePath = '';

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _uid = _user.uid;
    _getUserData();
  }

  Widget _profilePicture(String profilePic, Reference reference) {
    return FutureBuilder<String>(
      future: reference.child(profilePic).getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TeAppColorPalette.green),
          );
        } else if (snapshot.hasError) {
          // print(snapshot.error);
          return const Text('Error');
        } else {
          final imageUrl = snapshot.data;
          return CircleAvatar(
            backgroundColor: TeAppColorPalette.blackLight,
            backgroundImage: NetworkImage(imageUrl!),
            radius: 90,
          );
        }
      },
    );
  }

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();

      setState(() {
        _userName = userDoc['name'];
        _userUsername = userDoc['userName'];
        _membershipText = userDoc['membership'] == 'fullAccess'
            ? 'Membresía Full Access'
            : 'Membresía Por Sesiones';
        _creditsAvailable = userDoc['creditsAvailable'];
        _profilePicturePath =
            userDoc['profilePicture']; // Assign the profile picture URL
      });
    } catch (e) {
      // print('Error retrieving user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _storageRef = _storage.ref().child('/defaultProfilePictures');

    return Scaffold(
      body: ListView(
        reverse: true,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _profilePicture(_profilePicturePath, _storageRef),
                Text(
                  textAlign: TextAlign.center,
                  _userName.split(" ").take(2).join(
                      " "), // Splits by space and takes the first two words
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                Text(
                  '@$_userUsername',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _membershipText,
                      style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: TeAppColorPalette.green),
                    )),
                const TeSpacer(width: 0, height: 20),
                Container(
                  decoration: const BoxDecoration(
                    color: TeAppColorPalette.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  width: TeMediaQuery.getPercentageWidth(context, 80),
                  height: TeMediaQuery.getPercentageWidth(context, 80),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: QrImageView(
                        data: _uid,
                        // ignore: deprecated_member_use
                        foregroundColor: TeAppColorPalette.black,
                        version: QrVersions.auto,
                        size: double.infinity,
                      ),
                    ),
                  ),
                ),
                const TeSpacer(width: 0, height: 20),
                Text(
                  _membershipText == 'Membresía Full Access'
                      ? 'Full Access, Días restantes $_creditsAvailable'
                      : '$_creditsAvailable Sesiones Restantes',
                  style: const TextStyle(
                      fontSize: 18, color: TeAppColorPalette.green),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
