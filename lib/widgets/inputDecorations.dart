import 'package:flutter/material.dart';
import 'package:ven_smash/themes/apptheme.dart';

class InputDecorations{

  static InputDecoration petitionInputDecoration({
    
    required String hintText,
    required String labeltext,
    IconData? prefixIcon,
    Widget? suffixIcon,

  }) {
    return InputDecoration(
      hintText: hintText,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.primary, 
          width: 2
        )
      ),
      labelText: labeltext,
      labelStyle: TextStyle(
        color: AppTheme.primary
      ),
      prefixIcon: Icon(prefixIcon, color: AppTheme.primary,),
    );
  }

  static InputDecoration showDiaglogInputDecoration({
    
    required String hintText,
    required String labeltext,
    Widget? suffixIcon,

  }) {
    return InputDecoration(
      hintText: hintText,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.primary, 
          width: 2
        )
      ),
      labelText: labeltext,
      labelStyle: TextStyle(
        color: AppTheme.primary
      ),
    );
  }
}