import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:ven_smash/themes/apptheme.dart';
import 'package:ven_smash/widgets/inputDecorations.dart';

import '../services/tournament_services.dart';

class TournamentDataRequestScreen extends StatelessWidget {
   
  const TournamentDataRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final tournamentServices = Provider.of<TournamentServices>(context);
    TextEditingController textName = TextEditingController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
         child: Form(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Opacity(
                      opacity: 0.8,
                      child: FadeInImage(
                        image: NetworkImage(tournamentServices.selectedTournament.banner == '' 
                        ? 'https://res.cloudinary.com/du6afhgfu/image/upload/v1671729645/imagen-no-disponible_a3nzsr.png'
                        : '${tournamentServices.selectedTournament.banner}'),
                        placeholder: const AssetImage('assets/banner-loading.gif'), 
                        fadeInCurve: Curves.easeIn,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            offset: Offset(1,5)
                          )
                        ]
                      ),
                      child: Link(
                        target: LinkTarget.blank,
                        uri: Uri.parse(tournamentServices.selectedTournament.link),
                          
                        builder: (context, followLink) => IconButton(
                          icon: const Icon(Icons.link_rounded, color: Colors.black,),
                          onPressed: followLink,
                        ),
                      ),
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 30), 
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        height: 100,
                        width: 100,
                        image: NetworkImage('${tournamentServices.selectedTournament.icon}'),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell( 
                            onTap: (){
                              textName.text = tournamentServices.selectedTournament.name;
                              showDialog(
                                barrierDismissible: false,
                                context: context, 
                                builder: (context){
                                  return AlertDialog( 
                                    title: Text('Nombre del torneo'), 
                                    content: TextField( 
                                      onChanged: (value) {
                                        tournamentServices.selectedTournament.name = value;
                                      }, 
                                      controller: textName, 
                                      decoration: InputDecorations.showDiaglogInputDecoration(
                                        hintText: 'Torneo increíble', 
                                        labeltext: 'Nombre del torneo'
                                      ), 
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        }, 
                                        child: Text('Aceptar')
                                      )
                                    ],
                                  );
                                }
                              );  
                            },
                            child: Text(tournamentServices.selectedTournament.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, overflow: TextOverflow.ellipsis), maxLines: 2,)
                          ),
                          Text(tournamentServices.selectedTournament.region, style: TextStyle(color: AppTheme.primary))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}