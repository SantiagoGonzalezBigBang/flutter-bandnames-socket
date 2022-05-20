class BandModel {

  BandModel({
    required this.id,
    required this.name,
    required this.votes
  });

  String id;
  String name;
  int votes;

  factory BandModel.fromMap(Map<String, dynamic> object) => BandModel(
    id   : object['id'], 
    name : object['name'], 
    votes: object['votes']
  );

}