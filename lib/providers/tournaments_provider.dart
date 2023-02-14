import 'package:flutter/material.dart';
import 'package:ven_smash/models/tournaments.dart';

class EventsFormProvider extends ChangeNotifier{

  GlobalKey<FormState> eventFormKey = GlobalKey<FormState>();

  Tournaments tournaments;

  EventsFormProvider(this.tournaments);

  bool isValidForm(){
    return eventFormKey.currentState?.validate() ?? false;
  }
}