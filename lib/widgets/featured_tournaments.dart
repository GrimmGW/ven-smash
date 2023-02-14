import 'package:flutter/material.dart';
import 'package:ven_smash/models/tournaments.dart';

class FeaturedTournaments extends StatelessWidget {

  final Tournaments tournaments;

  const FeaturedTournaments({
    Key? key, 
    required this.tournaments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 200,
      width: 300,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage('https://images.start.gg/images/tournament/486598/image-18dc70a62f1a37c049d07a2af82b854f-optimized.png?ehk=z65UMnb8yEdJ%2FGeMApUnTMRs2u6ryYBvamaja%2Bi2Ck4%3D&ehkOptimized=YhExsdB%2FcXywR5HF8Rvo%2Bisxji1I%2Faot3T7fn1L7mx0%3D'),
                placeholder: AssetImage('assets/infinity.gif'),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('No More Johns', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Text('Inicia el 2022/12/17')
            ],
          ),
        ],
      ),
    );
  }
}