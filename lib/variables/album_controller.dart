class AlbumItemClass {
  String id;
  String title;
  String artist;
  int songCount;
  String artistId;
  String coverArt;
  int year;
  int duration;
  String created;

  AlbumItemClass(this.id, this.title, this.artist, this.songCount, this.artistId, this.coverArt, this.year, this.duration, this.created);

  factory AlbumItemClass.fromJson(Map map){
    return AlbumItemClass(
      map['id']??"", 
      map["title"]??map["name"]??"", 
      map["artist"]??map['albumArtist']??"", 
      map["songCount"]??0, 
      map["artistId"]??map["albumArtistId"]??"",
      map["coverArt"]??"",
      map['year']??map['maxYear']??0,
      map['duration'].toInt() ?? 0,
      map['created'] ?? map['createdAt'] ?? ''
    );
  }

  Map toJson(){
    return {
      "id": id,
      "title": title,
      "artist": artist,
      "songCount": songCount,
      "artistId": artistId,
      "coverArt": coverArt,
      "year": year,
      "duration": duration,
      "created": created
    };
  }
}