import 'package:flutter/material.dart';
import 'package:freedom_smile/utils/assets_images.dart';

class CreateProfileOther extends StatefulWidget {
  const CreateProfileOther({super.key});

  @override
  State<CreateProfileOther> createState() => _CreateProfileOtherState();
}

class _CreateProfileOtherState extends State<CreateProfileOther> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.bgOthers),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: []),
      ),
    );
  }
}
