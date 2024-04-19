import 'package:eco_swap/util/Result.dart';
import 'package:eco_swap/view/main_pages/HomePage.dart';
import 'package:eco_swap/widget/DateField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';
import '../main_pages/NavigationPage.dart';
import 'LoginPage.dart';

class RegistryPage extends StatefulWidget {
  const RegistryPage({super.key,});

  @override
  State<RegistryPage> createState() => _RegistryPageState();
}

class _RegistryPageState extends State<RegistryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? selectedDate;
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  bool dataCompleted = false;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
  }

  void dispose() {
    if (!dataCompleted) {
      userViewModel.deleteUser();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Registry:',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NavigationPage(logoutCallback: () {
                            userViewModel.deleteCredential();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                          }),
                        ));
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
                child: const Text('Register now'),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
