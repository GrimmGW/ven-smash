import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ven_smash/themes/apptheme.dart';
import 'package:http/http.dart' as http;


class TournamentRequestScreen extends StatefulWidget {
   
  const TournamentRequestScreen({Key? key}) : super(key: key);

  @override
  State<TournamentRequestScreen> createState() => _TournamentRequestScreenState();
}

class _TournamentRequestScreenState extends State<TournamentRequestScreen> {

  TextEditingController textEditingController = TextEditingController();
  TextEditingController dataEditingController = TextEditingController();
  TextEditingController tournamentName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text('Petición', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Center(
         child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: textEditingController,
              ),

              MaterialButton(
                child: Text('hey'),
                onPressed: () async{
                  textEditingController.text.contains('https://www.') 
                  ? textEditingController.text 
                  : textEditingController.text = 'https://www.${textEditingController.text}';
                  Uri link = Uri.parse(textEditingController.text);
                  if (link.host == 'www.start.gg'){
                    final response = await http.get(link);
                    if (response.statusCode == 200) {
                      if (link.path.contains('/tournament/')){
                        dataEditingController.text = link.path.replaceAll(RegExp(r'/tournament/'), '');
                        dataEditingController.text = dataEditingController.text.replaceAll(RegExp(r'/details'), '');
                      } else if (link.path.contains('/')){
                        dataEditingController.text = link.path.replaceAll(r'/', '');
                      }
                      Uri tournamentLink = Uri.parse('https://api.smash.gg/tournament/${dataEditingController.text}?expand[]=event');
                      final tournamentResponse = await http.get(tournamentLink);
                      final Map<String, dynamic> map = json.decode(tournamentResponse.body);
                      tournamentName.text = '${map['entities']['tournament']['id']}';
                    } else {
                      throw Exception('No se pudo cargar.');
                    }
                  } else{
                    Fluttertoast.showToast(
                      msg: 'Este enlace no es válido.'
                    );
                  }
                }
              ),
              Text(tournamentName.text)
            ],
          ),
         ),
      ),
    );  
  }
}