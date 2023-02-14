// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:ven_smash/models/tournaments.dart';
import 'package:ven_smash/providers/tournaments_provider.dart';
import 'package:ven_smash/screens/screens.dart';
import 'package:ven_smash/services/services.dart';
import 'package:ven_smash/themes/apptheme.dart';
import 'package:ven_smash/widgets/widgets.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final tournamentServices = Provider.of<TournamentServices>(context);

    tournamentServices.selectedTournament = Tournaments(
      id: '',
      assistEmail: '',
      banner: '',
      description: '',
      endDate: '',
      games: '',
      icon: '',
      link: '',
      name: '',
      price: '',
      region: '',
      startDate: '',
      status: false,
      uploadDate: '', 
      gamesEndDate: '', 
      gamesPic: '', 
      gamesPrice: '', 
      gamesStartDate: '', 
      mapsLat: '', 
      mapsLong: '', 
      mapsVenue: '',
    );

    return ChangeNotifierProvider(
      create: (_) => EventsFormProvider(tournamentServices.selectedTournament),
      child: HomeScreenBody(tournamentServices: tournamentServices,),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
   
  const HomeScreenBody({
    Key? key, 
    required this.tournamentServices});

  final TournamentServices tournamentServices;
  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {

  bool isSaving = false;
  int _selectedIndex = 0;
  bool price = true;
  bool online = false;
  String? _selectedRegion = '';
  final _regionList = ['Seleccione un Estado: ','Amazonas','Anzoátegui','Apure','Aragua','Barinas','Bolívar','Carabobo','Cojedes', 'Delta Amacuro', 'Falcón','Guárico','Lara','Mérida','Miranda','Monagas','Nueva Esparta','Portuguesa', 'Sucre', 'Táchira', 'Trujillo','Vargas','Yaracuy','Zulia'];
  _HomeScreenBodyState(){
    _selectedRegion = _regionList[0];
  }
  Future refresh() async{
    setState(() {
      widget.tournamentServices.loadTournaments();
    });
  }
  int listedEvent = 0;

  TextEditingController tournamentPath = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
    for(int i = 0; i < widget.tournamentServices.tournaments.length; i++){
      if(widget.tournamentServices.tournaments[i].status == true){
        listedEvent = listedEvent + 1;
      }
    }

    final eventForm = Provider.of<EventsFormProvider>(context);
    DateTime now = DateTime.now();
    List<Widget> _widgetOptions = <Widget>[

    //! Muestra TODOS los torneos.
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('VenSmash', style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold)),
                  Text('Hola de nuevo 👋', style: TextStyle(fontSize: 20)),
                ],
              )
            ),
          ],
        ),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: widget.tournamentServices.tournaments.length,
          itemBuilder: (BuildContext context, int index) {
            int year = int.parse(widget.tournamentServices.tournaments[index].startDate.substring(0,4));
            int month = int.parse(widget.tournamentServices.tournaments[index].startDate.substring(5,7));
            int day = int.parse(widget.tournamentServices.tournaments[index].startDate.substring(8,10));
            DateTime tStatus = DateTime(year, month, day);
            if (widget.tournamentServices.tournaments[index].status == true){
              return Hero(
    
                tag: '${widget.tournamentServices.tournaments[index].id}',
                child: Material(
                  child: ListTile(
                    onTap: () {
                      widget.tournamentServices.selectedTournament.heroID = widget.tournamentServices.tournaments[index].id;
                      widget.tournamentServices.selectedTournament = widget.tournamentServices.tournaments[index];
                      Navigator.pushNamed(context, '/tournamentData');
                    },
                    title: Text(widget.tournamentServices.tournaments[index].name),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: tStatus.isAfter(DateTime.now()) ? Colors.green : Colors.red
                      ),
                      child: tStatus.isAfter(DateTime.now()) ? Text('Abierto') : Text('Finalizado'),
                    ),
                    subtitle: Text(widget.tournamentServices.tournaments[index].region, style: TextStyle(color: AppTheme.primary.withOpacity(0.6)),),
                    leading: FadeInImage(
                      image: NetworkImage(widget.tournamentServices.tournaments[index].icon == "" 
                      ? 'https://res.cloudinary.com/du6afhgfu/image/upload/v1672759857/imagen-no-disponible-icon_v4ckei.png'
                      : '${widget.tournamentServices.tournaments[index].icon}'),
                      placeholder: const AssetImage('assets/loading.gif'),
                    ),
                  ),
                ),
              );
            } 
            return Container();
          },
        ),
      ],
    ),
    //! Filtrado y búsqueda
    Text(
      'Filtros',
    ),
    //! Enviar un evento
    Form(
      key: eventForm.eventFormKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.url,
              onChanged: (value) => widget.tournamentServices.selectedTournament.link = value,
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Este campo es obligatorio';
                }
              },
              decoration: InputDecorations.petitionInputDecoration(
                labeltext: 'Enlace del torneo', 
                hintText: 'https://start.gg/example-event',
                prefixIcon: Icons.link
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              minWidth: 0, 
              color: AppTheme.primary,
              onPressed: isSaving == true ? null : () async {
                isSaving = true;
                widget.tournamentServices.selectedTournament.link.contains('https://www.') 
                  ? widget.tournamentServices.selectedTournament.link
                  : widget.tournamentServices.selectedTournament.link = 'https://www.${widget.tournamentServices.selectedTournament.link}';
                Uri link = Uri.parse(widget.tournamentServices.selectedTournament.link);
                if (link.host == 'www.start.gg'){
                  final response = await http.get(link);
                  if (response.statusCode == 200) {
                    if (link.path.contains('/tournament/')){
                      tournamentPath.text = link.path.replaceAll(RegExp(r'/tournament/'), '');
                      tournamentPath.text = tournamentPath.text.replaceAll(RegExp(r'/details'), '');
                    } else if (link.path.contains('/')){
                      tournamentPath.text = link.path.replaceAll(r'/', '');
                    }
                    Uri tournamentLink = Uri.parse('https://api.smash.gg/tournament/${tournamentPath.text}?expand[]=event');
                    final tournamentResponse = await http.get(tournamentLink);

                    //TODO: Evitar que se repitan los torneos
                    final Map<String, dynamic> map = json.decode(tournamentResponse.body);
                    // for (int i = 0; i < widget.tournamentServices.tournaments.length; i++){
                    //   String name = '${map['entities']['tournament']['name']}';
                    //   if (widget.tournamentServices.tournaments[i].name == name){
                    //     print('Este torneo ha sido publicado');
                    //   } else {}
                    // }

                    //!Tournament
                    widget.tournamentServices.selectedTournament.name = '${map['entities']['tournament']['name']}';
                    widget.tournamentServices.selectedTournament.assistEmail = '${map['entities']['tournament']['primaryContact']}';
                    widget.tournamentServices.selectedTournament.region = '${map['entities']['tournament']['addrState']}';
                    widget.tournamentServices.selectedTournament.status = false;
                    widget.tournamentServices.selectedTournament.price = '${map['entities']['tournament']['processingFee']}';
                    widget.tournamentServices.selectedTournament.uploadDate = now.toString();

                    if (map['entities']['tournament']['images'][0]['type'] == 'banner'){
                      widget.tournamentServices.selectedTournament.banner = '${map['entities']['tournament']['images'][0]['url']}';
                      widget.tournamentServices.selectedTournament.icon = '${map['entities']['tournament']['images'][1]['url']}';
                    } else {
                      widget.tournamentServices.selectedTournament.icon = '${map['entities']['tournament']['images'][0]['url']}';
                      widget.tournamentServices.selectedTournament.banner = '${map['entities']['tournament']['images'][1]['url']}';
                    }

                    widget.tournamentServices.selectedTournament.mapsLat = '${map['entities']['tournament']['lat']}';
                    widget.tournamentServices.selectedTournament.mapsLong = '${map['entities']['tournament']['lng']}';
                    widget.tournamentServices.selectedTournament.mapsVenue = '${map['entities']['tournament']['venueAddress']}';
                    
                    DateTime rawStartDate = DateTime.fromMillisecondsSinceEpoch(int.parse('${map['entities']['tournament']['startAt']}') * 1000);
                    widget.tournamentServices.selectedTournament.startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(rawStartDate);
                    DateTime rawEndDate = DateTime.fromMillisecondsSinceEpoch(int.parse('${map['entities']['tournament']['endAt']}') * 1000);
                    widget.tournamentServices.selectedTournament.endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(rawEndDate);

                    //!Events
                    widget.tournamentServices.selectedTournament.games = '';
                    widget.tournamentServices.selectedTournament.gamesPrice = '';
                    widget.tournamentServices.selectedTournament.gamesStartDate = '';
                    widget.tournamentServices.selectedTournament.gamesEndDate = '';
                    final List<dynamic> eventsMap = map['entities']['event'];
                    for (int i = 0; i < eventsMap.length; i++){

                      widget.tournamentServices.selectedTournament.games = '${widget.tournamentServices.selectedTournament.games}${eventsMap[i]['name']},';
                      widget.tournamentServices.selectedTournament.gamesPrice = '${widget.tournamentServices.selectedTournament.gamesPrice}${eventsMap[i]['entryFee']},';

                      DateTime rawGamesStartDate = DateTime.fromMillisecondsSinceEpoch(int.parse('${eventsMap[i]['startAt']}') * 1000);
                      widget.tournamentServices.selectedTournament.gamesStartDate = '${widget.tournamentServices.selectedTournament.gamesStartDate}${DateFormat('yyyy/MM/dd H:mm').format(rawGamesStartDate)},';
                      DateTime rawGamesEndDate = DateTime.fromMillisecondsSinceEpoch(int.parse('${eventsMap[i]['endAt']}') * 1000);
                      widget.tournamentServices.selectedTournament.gamesEndDate = '${widget.tournamentServices.selectedTournament.gamesEndDate}${DateFormat('yyyy/MM/dd H:mm').format(rawGamesEndDate)},';
                    }
                    widget.tournamentServices.selectedTournament.games = widget.tournamentServices.selectedTournament.games.substring(0, widget.tournamentServices.selectedTournament.games.length -1);
                    widget.tournamentServices.selectedTournament.gamesPrice = widget.tournamentServices.selectedTournament.gamesPrice.substring(0, widget.tournamentServices.selectedTournament.gamesPrice.length -1);
                    widget.tournamentServices.selectedTournament.gamesStartDate = widget.tournamentServices.selectedTournament.gamesStartDate.substring(0, widget.tournamentServices.selectedTournament.gamesStartDate.length -1);
                    widget.tournamentServices.selectedTournament.gamesEndDate = widget.tournamentServices.selectedTournament.gamesEndDate.substring(0, widget.tournamentServices.selectedTournament.gamesEndDate.length -1);

                    //!Videogames
                    widget.tournamentServices.selectedTournament.gamesPic = '';
                    final List<dynamic> gamesMap = map['entities']['videogame'];
                    for (int i = 0; i < eventsMap.length; i++){
                      var xd = gamesMap.asMap().keys.firstWhere((element) => gamesMap[element]['id'] == eventsMap[i]['videogameId']);
                      widget.tournamentServices.selectedTournament.gamesPic = '${widget.tournamentServices.selectedTournament.gamesPic}${gamesMap[xd]['images'][0]['url']},';
                    }
                    widget.tournamentServices.selectedTournament.gamesPic = widget.tournamentServices.selectedTournament.gamesPic.substring(0, widget.tournamentServices.selectedTournament.gamesPic.length -1);

                    Navigator.pushNamed(context, '/tournamentRequest');
                    // await widget.tournamentServices.createEvent(widget.tournamentServices.selectedTournament);
                    // showDialog(
                    //   barrierDismissible: false,
                    //   context: context,
                    //    builder: (context){
                    //     return AlertDialog(
                    //       elevation: 5,
                    //       title: const Text('¡Torneo enviado!'),
                    //       content: Container(
                    //         child: Text('Hemos recibido tu torneo (${widget.tournamentServices.selectedTournament.name}). Al ser verificado, se mostrará en la lista de eventos.')
                    //       ),
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    //       actions: [
                    //         TextButton(
                    //           onPressed: (){
                    //             refresh();
                    //             Navigator.pop(context);
                    //           }, 
                    //           child: Text('Aceptar', style: TextStyle(color: AppTheme.primary))
                    //         )
                    //       ],
                    //     );
                    //    }
                    // );
                    // isSaving = false;
                  } else if(response.statusCode == 500) {
                    Fluttertoast.showToast(
                      msg: 'Parece haber un problema con los servidores de start.gg, inténtelo de nuevo más tarde.');
                      Toast.LENGTH_LONG;
                  } else {
                  Fluttertoast.showToast(
                    msg: 'Este torneo no existe.');
                  }
                } else{
                  Fluttertoast.showToast(
                    msg: 'Este enlace no es válido.'
                  );
                }
              },
              //TODO: hacer que funcione el circleprogressindicator
              child: isSaving == true
                ? CircularProgressIndicator(color: AppTheme.primary,)
                : Text('¡Enviar enlace!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ),
            TextButton(
              onPressed: (){}, 
              child: Text('No tengo enlace de start.gg', style: TextStyle(color: AppTheme.primary))
            )
          ]
        )
      )
    )
  ];

    if (isSaving) return const LoadingScreen();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/search');
            }, 
            icon: const Icon(Icons.search)
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black
              ),
              child: null
            ),
            ListTile(
              leading: Icon(Icons.send_rounded, color: AppTheme.primary,),
              title: Text('Enviar un torneo', style: drawerTileStyle()),
              onTap: (){
                Navigator.pop(context);
                _selectedIndex = 2;
                setState(() {
                  
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart_sharp, color: AppTheme.primary,),
              title: Text('Estadísticas', style: drawerTileStyle()),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.star_rounded, color: AppTheme.primary,),
              title: Text('Apoya al desarrollador', style: drawerTileStyle()),
              onTap: (){},
            ),
            
          ],
        ),
      ),
      body: SingleChildScrollView(
        //todo: make it better
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CarouselSlider.builder(
            //   itemCount: listedEvent, 
            //   options: CarouselOptions(
            //     autoPlay: false,
            //     autoPlayInterval: const Duration(seconds: 10),
            //   ),
            //   itemBuilder: ((context, index, realIndex) {
            //     if (widget.tournamentServices.tournaments[index].status == true){
            //       return GestureDetector(
            //         onTap: (){
            //           widget.tournamentServices.selectedTournament = widget.tournamentServices.tournaments[index];
            //           Navigator.pushNamed(context, '/tournamentData');
            //         },
            //         child: Stack(
            //           children: [
            //             Opacity(
            //               opacity: 0.5,
            //               child: FadeInImage(
            //                 fit: BoxFit.cover,
            //                 height: 300,
            //                 image: NetworkImage(widget.tournamentServices.tournaments[index].banner == ''
            //                   ? 'https://res.cloudinary.com/du6afhgfu/image/upload/v1671729645/imagen-no-disponible_a3nzsr.png' 
            //                   : '${widget.tournamentServices.tournaments[index].banner}'),
            //                 placeholder: const AssetImage('assets/infinity.gif'),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.symmetric(vertical: 20),
            //               alignment: Alignment.bottomCenter,
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: [
            //                   Text(widget.tournamentServices.tournaments[index].name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30), maxLines: 1, overflow: TextOverflow.ellipsis),
            //                   Container(
            //                     alignment: Alignment.center,
            //                     width: 150,
            //                     height: 30,
            //                     decoration: BoxDecoration(
            //                       color: AppTheme.primary,
            //                       borderRadius: BorderRadius.circular(20),
            //                     ),
            //                     child: Text(widget.tournamentServices.tournaments[index].region, style: const TextStyle(color: Colors.black, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
            //                   )
            //                 ],
            //               ),
            //             )
            //           ]
            //         ),
            //       );
            //     } 
            //     return Container();
            //   }),
            // ),
            const SizedBox(height: 30),
            Container(
              child: _widgetOptions.elementAt(_selectedIndex),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: GNav(
          textSize: 30,
          iconSize: 25,
          rippleColor: AppTheme.primary,
          activeColor: AppTheme.primary,
          color: Colors.grey,
          tabActiveBorder: Border.all(color: AppTheme.primary),
          tabs: const [
            GButton(icon: Icons.flag_rounded, text: 'Torneos'),
            GButton(icon: Icons.filter_list_alt, text: 'Filtro'),
            GButton(icon: Icons.send_rounded, text: 'Solicitud')
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              print(index);
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Future<TimeOfDay?> timeSelector(BuildContext context) {
    return showTimePicker(
      context: context, 
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      builder: (context, child){
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryShade,
              onPrimary: Colors.black,
              onSurface: Colors.white
            ),
          ), 
          child: child!
        );
      },
    );
  }

  Future<DateTime?> dateSelector(BuildContext context) {
    return showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(1900), 
      lastDate: DateTime(2100),
      locale: Locale('es'),
      builder: (context, child){
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryShade,
              onPrimary: Colors.black,
              onSurface: Colors.white,
            )
          ), 
          child: child!
        );
      },
    );
  }

  TextStyle drawerTileStyle() => TextStyle(fontSize: 16);
}

