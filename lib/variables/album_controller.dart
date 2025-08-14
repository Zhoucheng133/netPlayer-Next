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
      map["title"]??"", 
      map["artist"]??"", 
      map["songCount"]??0, 
      map["artistId"]??"",
      map["coverArt"]??"",
      map['year']??0,
      map["duration"]??0,
      map["created"]??"",
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