// To parse this JSON data, do
//
//     final tournaments = tournamentsFromMap(jsonString);

import 'dart:convert';

class Tournaments {
    Tournaments({
        this.id,
        this.heroID,
        required this.assistEmail,
        this.banner,
        required this.description,
        required this.endDate,
        required this.games,
        required this.gamesPrice,
        required this.gamesPic,
        required this.gamesStartDate,
        required this.gamesEndDate,
        this.icon,
        required this.mapsLat,
        required this.mapsLong,
        required this.mapsVenue,
        required this.link,
        required this.name,
        required this.price,
        required this.region,
        required this.startDate,
        required this.status,
        required this.uploadDate,
    });
    String? id;
    String? heroID;
    String assistEmail;
    String? banner;
    String description;
    String endDate;
    String games;
    String gamesPrice;
    String gamesPic;
    String gamesStartDate;
    String gamesEndDate;
    String? icon;
    String mapsLat;
    String mapsLong;
    String mapsVenue;
    String link;
    String name;
    String price;
    String region;
    String startDate;
    bool status;
    String uploadDate;

    factory Tournaments.fromJson(String str) => Tournaments.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Tournaments.fromMap(Map<String, dynamic> json) => Tournaments(
        assistEmail: json["assistEmail"],
        banner: json["banner"],
        endDate: json["endDate"],
        description: json["description"],
        games: json["games"],
        gamesPrice: json["gamesPrice"],
        gamesPic: json["gamesPic"],
        gamesStartDate: json["gamesStartDate"],
        gamesEndDate: json["gamesEndDate"],
        icon: json["icon"],
        mapsLat: json["mapsLat"],
        mapsLong: json["mapsLong"],
        mapsVenue: json["mapsVenue"],
        link: json["link"],
        name: json["name"],
        price: json["price"],
        region: json["region"],
        startDate: json["startDate"],
        status: json["status"],
        uploadDate: json["uploadDate"],
    );

    Map<String, dynamic> toMap() => {
        "assistEmail": assistEmail,
        "banner": banner,
        "endDate": endDate,
        "description": description,
        "games": games,
        "gamesPrice": gamesPrice,
        "gamesPic": gamesPic,
        "gamesStartDate": gamesStartDate,
        "gamesEndDate": gamesEndDate,
        "icon": icon,
        "mapsLat": mapsLat,
        "mapsLong": mapsLong,
        "mapsVenue": mapsVenue,
        "link": link,
        "name": name,
        "price": price,
        "region": region,
        "startDate": startDate,
        "status": status,
        "uploadDate": uploadDate,
    };

    Tournaments copy() => Tournaments(
        assistEmail: assistEmail,
        banner: banner,
        endDate: endDate, 
        description: description,
        games: games, 
        gamesPrice: gamesPrice, 
        gamesPic: gamesPic, 
        gamesStartDate: gamesStartDate, 
        gamesEndDate: gamesEndDate, 
        icon: icon, 
        mapsLat: mapsLat, 
        mapsLong: mapsLong,
        mapsVenue: mapsVenue,
        link: link, 
        name: name, 
        price: price, 
        region: region, 
        startDate: startDate, 
        status: status, 
        uploadDate: uploadDate
    );
}
