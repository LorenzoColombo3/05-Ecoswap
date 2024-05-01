import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/UserModel.dart';
import '../../util/Result.dart';
import '../../util/ServiceLocator.dart';
import '../../widget/DateField.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late UserModel currentUser;
  late String imagePath;
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  DateTime? selectedDate;
  bool dataCompleted = false;
  late File _imageFile;
  late Future<String?> imageUrl;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    userViewModel.getUser().then((user){
      currentUser = user!;
    });
    imageUrl = userViewModel.getProfileImage();
    imagePath = "";
  }




  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: userViewModel.getUser(), // Ottieni l'utente
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Verifica se lo snapshot ha completato il caricamento dei dati
          currentUser = snapshot.data!;
          return buildContent(); // Costruisci il widget principale
        } else {
          return const CircularProgressIndicator(); // Visualizza un indicatore di caricamento in attesa
        }
      },
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
    }
  }

  Widget buildContent() {
    return Scaffold(
      appBar: AppBar(),
      body:Center(
        child:SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight, // Allinea il widget alla parte inferiore destra
                children: [

                  FutureBuilder<String?>(
                    future: imageUrl,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Visualizza un indicatore di caricamento in attesa
                      } else if (snapshot.hasData && snapshot.data != "") {
                        return ClipOval(
                          child: Image.network(
                            snapshot.data!,
                            width: 150, // Imposta la larghezza dell'immagine
                            height: 150, // Imposta l'altezza dell'immagine
                            fit: BoxFit
                                .cover, // Scala l'immagine per adattarla al widget Image
                          ),
                        );
                      } else {
                        return ClipOval(
                          child: Image.asset(
                            'assets/image/profile.jpg',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ); // Gestisci il caso in cui non ci sia alcun URL immagine
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, right: 8),
                    child: ClipOval(// Padding per spostare il pulsante
                      child: FloatingActionButton(
                        onPressed: () {
                          _getImage();
                          imagePath= _imageFile.path;
                          userViewModel.setProfileImage(imagePath);
                          imageUrl = userViewModel.getProfileImage();
                        },
                        child: Icon(Icons.edit), // Icona del pulsante
                        backgroundColor: Colors.blue, // Colore di sfondo del pulsante
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                currentUser.name, // Sostituisci con il nome utente reale
                style: const TextStyle(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Lastname',
                    prefixIcon: Icon(Icons.edit),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DateField(
                  onDateSelected: (date) {
                    selectedDate = date;
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.only(bottom: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(_nameController.text != "" && _lastnameController.text != "" &&
                        selectedDate.toString() != "" && _phoneController.text != "") {
                      userViewModel
                          .saveData(
                          name: _nameController.text,
                          lastName: _lastnameController.text,
                          birthDate: selectedDate.toString(),
                          phoneNumber: _phoneController.text)
                          .then((result) {
                        if (result!.isSuccess()) {
                          dataCompleted = true;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Data updated successfully')));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text((result as ErrorResult).getMessage()),
                            ),
                          );}
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Fill in all fields"),
                        ),
                      );
                    }
                  },
                  child: const Text('Update your data'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}