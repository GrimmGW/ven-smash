import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:ven_smash/services/services.dart';

import '../themes/apptheme.dart';

class TournamentDataScreen extends StatelessWidget {
   
  const TournamentDataScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final tournamentServices = Provider.of<TournamentServices>(context);

    final List<String> gamesList = tournamentServices.selectedTournament.games.split(',');
    final List<String> gamesListPrice = tournamentServices.selectedTournament.gamesPrice.split(',');
    final List<String> gamesListPic = tournamentServices.selectedTournament.gamesPic.split(',');
    final List<String> gamesListStartDate = tournamentServices.selectedTournament.gamesStartDate.split(',');
    final List<String> gamesListEndDate = tournamentServices.selectedTournament.gamesEndDate.split(',');
    DateTime newStartDate = DateTime.parse(tournamentServices.selectedTournament.startDate);
    DateTime newEndDate = DateTime.parse(tournamentServices.selectedTournament.endDate);
    print(newStartDate.isAfter(newEndDate));


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
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
                )
              ]
            ),
            //por si el torneo ya culminó...
            newStartDate.isBefore(DateTime.now()) 
            ? Container(
              height: 40,
              width: double.infinity,
              color: Colors.red,
              child: const Center(
                child: Text('Este torneo ha finalizado.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
              ),
            )
            : Container(),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Hero(
                    tag: '${tournamentServices.selectedTournament.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        height: 100,
                        width: 100,
                        image: NetworkImage('${tournamentServices.selectedTournament.icon}'),
                      ),
                    )
                  ),
                  const SizedBox(width: 10,),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tournamentServices.selectedTournament.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, overflow: TextOverflow.ellipsis), maxLines: 2,),
                        Text(tournamentServices.selectedTournament.region, style: TextStyle(color: AppTheme.primary))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(tournamentServices.selectedTournament.price == '0' ? 'Venue: GRATIS' : 'Venue: \$${tournamentServices.selectedTournament.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, overflow: TextOverflow.ellipsis), maxLines: 2,),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text('Lorem anim dolore duis sit consequat in ea veniam eiusmod cillum pariatur enim Lorem dolor. Ipsum sunt ullamco dolore quis veniam et enim quis cillum enim consectetur veniam. In ad Lorem et cillum officia. Velit excepteur nostrud aute consectetur eu ut dolore aliquip. Id in veniam mollit laborum enim ullamco do ad laboris sunt officia culpa. Minim sint amet et nulla magna occaecat consequat anim pariatur veniam. Esse non occaecat aute ipsum ea id culpa.', style: TextStyle(), textAlign: TextAlign.justify)
            ),
            const SizedBox(height: 30),
            Row(
              children: const [
                SizedBox(width: 10),
                Text('Eventos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: gamesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(gamesList[index]),
                    subtitle: Text('${gamesListStartDate[index]} • ${gamesListEndDate[index]}'),
                    leading: FadeInImage(
                      image: NetworkImage(gamesListPic[index] == "" 
                      ? 'https://res.cloudinary.com/du6afhgfu/image/upload/v1672759857/imagen-no-disponible-icon_v4ckei.png'
                      : gamesListPic[index]),
                      placeholder: const AssetImage('assets/loading.gif'),
                    ),
                    trailing: Text(gamesListPrice[index] == '0' ? 'GRATIS' : gamesListPrice[index], style: TextStyle(color: AppTheme.primary),),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: const [
                SizedBox(width: 10),
                Text('Información adicional', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            MoreInfo(
              icon: Icons.map_rounded, 
              link: 'https://www.google.com/maps/search/${tournamentServices.selectedTournament.mapsLat}, ${tournamentServices.selectedTournament.mapsLong}', 
              name: tournamentServices.selectedTournament.mapsVenue,
            ),
            const SizedBox(height: 10),
            MoreInfo(
              link: 'MAILTO:${tournamentServices.selectedTournament.assistEmail}', 
              icon: Icons.mail_rounded, 
              name: tournamentServices.selectedTournament.assistEmail
            ),
            const SizedBox(height: 30),
          ],
        ),
      )
    );
  }
}

class MoreInfo extends StatelessWidget {
  const MoreInfo({
    Key? key,
    required this.link, 
    required this.icon, 
    required this.name,
  }) : super(key: key);

  final String link;
  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Link(
              uri: Uri.parse(link),
              builder: ((context, followLink) => InkWell(
                onTap: followLink,
                child: Text(
                  name, 
                  style: const TextStyle(overflow: TextOverflow.ellipsis) , 
                  maxLines: 2
                ),
              ))
            )
          ),
        ],
      ),
    );
  }
}