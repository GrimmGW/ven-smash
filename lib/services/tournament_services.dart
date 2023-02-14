import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ven_smash/models/tournaments.dart';

class TournamentServices extends ChangeNotifier{

  final String _baseUrl = 'ven-smash-default-rtdb.firebaseio.com';
  final List<Tournaments> tournaments = []; 
  late Tournaments selectedTournament;

  bool isLoading = true;
  bool isSaving = false;

  TournamentServices(){

    loadTournaments();

  }

  Future<List<Tournaments>> loadTournaments() async{

    tournaments.clear();
    isLoading = true;
    notifyListeners();

    final _prefs = await SharedPreferences.getInstance();
    final url = Uri.https(_baseUrl, 'tournaments.json', {
      'auth': await _prefs.getString('token') ?? ''
      });
    final resp = await http.get(url);
    final Map<String, dynamic> tournamentsMap = json.decode(resp.body);

    tournamentsMap.forEach((key, value) {
      final tempTournament = Tournaments.fromMap(value);
      tempTournament.id = key;
      tournaments.add(tempTournament);
    });

    isLoading = false;
    notifyListeners();
    return tournaments;
  }

  Future saveOrCreateTournament(Tournaments tournament) async{
    isSaving = true;
    notifyListeners();

    if (tournament.id == null){
      await createEvent(tournament);
    } else{
      await updateTournament(tournament);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateTournament(Tournaments tournament) async{
    final _prefs = await SharedPreferences.getInstance();
    final url = Uri.https(_baseUrl, 
    'tournaments/${tournament.id}.json', {
      'auth': await _prefs.getString('token') ?? ''
    });
    final resp = await http.put(url, body: tournament.toJson());

    final index = tournaments.indexWhere((element) => element.id == tournament.id);
    tournaments[index] = tournament;

    return tournament.id!;

  }

  Future<String> createEvent(Tournaments tournament) async{
    isSaving = true;
    final _prefs = await SharedPreferences.getInstance();
    final url = Uri.https(_baseUrl, 
    'tournaments.json', {
      'auth': await _prefs.getString('token') ?? ''
    });
    final resp = await http.post(url, body: tournament.toJson());
    final decodedData = json.decode(resp.body);

    tournament.id = decodedData['name'];

    tournaments.add(tournament);
    isSaving = false;
    return tournament.id!;
  }

  Future deleteEvent(Tournaments tournament) async{
    isSaving = true;
    notifyListeners();
    final _prefs = await SharedPreferences.getInstance();
    final url = Uri.https(
      _baseUrl, 
      'tournaments/${tournament.id}.json', {
      'auth': await _prefs.getString('token') ?? ''
    });

    final resp = await http.delete(url, body: tournament.toJson());

    tournaments.removeWhere((element) => element.id == tournament.id);

    isSaving = false;
    notifyListeners();
    return loadTournaments();
  }
}