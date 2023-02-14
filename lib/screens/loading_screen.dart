import 'package:flutter/material.dart';
import 'package:ven_smash/themes/apptheme.dart';

class LoadingScreen extends StatelessWidget {
   
  const LoadingScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: CircularProgressIndicator(
          color: AppTheme.primary
         ),
      ),
    );
  }
}