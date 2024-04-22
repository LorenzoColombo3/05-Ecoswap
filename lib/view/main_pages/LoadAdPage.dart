import 'package:eco_swap/widget/ModalBottomSheet.dart';
import 'package:flutter/material.dart';

class LoadAdPage extends StatefulWidget {
  const LoadAdPage({super.key});

  @override
  State<LoadAdPage> createState()  => _HomeScreenState();
}

class _HomeScreenState extends State<LoadAdPage> {

  void initState() {
    super.initState();
  }
  void _openIconButtonPressed() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: false,
      context: context,
      builder: (ctx) => ModalBottomSheet(),
    );
  }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _openIconButtonPressed();
      });
    }


    @override
    Widget build(BuildContext context) => Container(child: Text('LoadPage'));

}