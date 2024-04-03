import 'package:eco_swap/data/viewmodel/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:eco_swap/data/repository/UserRepository.dart';
import '../repository/IUserRepository.dart';

class UserViewModelFactory {
  final IUserRepository _userRepository;

  UserViewModelFactory(IUserRepository userRepository)
      : _userRepository = userRepository;

  UserViewModel create(){
    return new UserViewModel(_userRepository);
  }
}
