// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';
import 'package:users_app/widgets/custom_text_field.dart';
import 'package:users_app/widgets/loading_dialog.dart';

import '../sellersScreens/home_screen.dart';

class RegistrationTabPage extends StatefulWidget {
  const RegistrationTabPage({super.key});

  @override
  State<RegistrationTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<RegistrationTabPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  String downloadUrl = "";
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();
  void getImageFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image;
    });
  }

  formValidation() async
  {
    if(imageFile == null) //image is not selected
    {
      Fluttertoast.showToast(msg: "Please select an image.");
    }
    else //image is already selected
    {
      //password is equal to confirm password
      if(passwordTextEditingController.text == confirmPasswordTextEditingController.text)
      {
        //check email, pass, confirm password & name text fields
        if(nameTextEditingController.text.isNotEmpty
            && emailTextEditingController.text.isNotEmpty
            && passwordTextEditingController.text.isNotEmpty
            && confirmPasswordTextEditingController.text.isNotEmpty)
        {
          showDialog(
            context: context, 
            builder: (context) => LoadingDialog(message: "Registering your account!!\n",)
            );

          //1.upload image to storage
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          final storageRef = FirebaseStorage.instance.ref().child("usersImages").child(fileName);
          final uploadTask = storageRef.putFile(File(imageFile!.path));
          downloadUrl = await (await uploadTask).ref.getDownloadURL();

          //2. save the user info to firestore database
            saveInformationToDatabase();
          
        }
        else
        {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Please complete the form. Do not leave any text field empty.");
        }
      }
      else //password is NOT equal to confirm password
      {
        Fluttertoast.showToast(msg: "Password and Confirm Password do not match.");
      }
    }
  }

  saveInformationToDatabase() async
  {
    //authenticate the user first
    User? currentUser;

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
    ).then((auth)
    {
      currentUser = auth.user;
    }).catchError((errorMessage)
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred: \n $errorMessage");
    });

    if(currentUser != null)
    {
      //save info to database and save locally
      saveInfoToFirestoreAndLocally(currentUser!);
    }
  }


  saveInfoToFirestoreAndLocally(User currentUser) async{
    await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
        "uid": currentUser.uid,
        "name": nameTextEditingController.text,
        "email": emailTextEditingController.text,
        "password": passwordTextEditingController.text,
        "photoUrl": downloadUrl,
        "status": 'approved',
        "userCart": [],
        "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
      }).then((value) {
        Fluttertoast.showToast(msg: "User has been registered successfully.");
        //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
      }).catchError((error) {
        Fluttertoast.showToast(msg: error.toString());
      });

      // save user info to shared preferences/local storage
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("name", nameTextEditingController.text);
        await sharedPreferences!.setString("email", emailTextEditingController.text);
        await sharedPreferences!.setString("photoUrl", downloadUrl);
        await sharedPreferences!.setStringList("userCart", []);
        await sharedPreferences!.setString("createdAt", DateTime.now().millisecondsSinceEpoch.toString());

        //navigate to home screen
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                getImageFromGallery();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
                backgroundColor: Colors.white,
                backgroundImage:
                    imageFile == null ? null : FileImage(File(imageFile!.path)),
                child: imageFile==null? Icon(
                  Icons.add_photo_alternate,
                  color: Colors.grey,
                  size: MediaQuery.of(context).size.width * 0.2,
                ):null,
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            // input form fields
            Form(
                key: formKey,
                child: Column(children: [
                  // name
                  CustomTextField(
                    textEditingController: nameTextEditingController,
                    icon: Icons.person,
                    hintText: 'Name',
                    isObscure: false,
                    enabled: true,
                  ),
                  // email
                  CustomTextField(
                    textEditingController: emailTextEditingController,
                    icon: Icons.email,
                    hintText: 'Email',
                    isObscure: false,
                    enabled: true,
                  ),
                  // password
                  CustomTextField(
                    textEditingController: passwordTextEditingController,
                    icon: Icons.lock,
                    hintText: 'Password',
                    isObscure: true,
                    enabled: true,
                  ),
                  // confirm password
                  CustomTextField(
                    textEditingController: confirmPasswordTextEditingController,
                    icon: Icons.lock,
                    hintText: 'Confirm Password',
                    isObscure: true,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ])),
            // register button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                formValidation();
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
