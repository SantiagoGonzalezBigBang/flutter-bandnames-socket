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
    id   : object.containsKey('id') ? object['id'] : 'no-id', 
    name : object.containsKey('name') ? object['name'] : 'no-name', 
    votes: object.containsKey('votes') ? object['votes'] : 0, 
  );

}