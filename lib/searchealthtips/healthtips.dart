class TipCategory {

  final int id;
  final String icon;
  final String name;
  final String timestamp;

  TipCategory({ this.id,
            this.icon, 
            this.name,
            this.timestamp,
          });

  factory TipCategory.fromJson(Map<String, dynamic> json) {
    return new TipCategory(
      id:         json['id'] as int,
      icon:       json["icon"] as String,
      name:       json["name"] as String,
      timestamp:  json["timestamp"] as String,
    );
  }
}

class Tip {
  final int id;
  final String category;
  final String name;
  final String description;
  final String icon;

  Tip({ this.id,
            this.category, 
            this.name,
            this.description,
            this.icon,
          });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return new Tip(
      id:           json['id'] as int,
      category:     json["category"]["name"] as String,
      name:         json["name"] as String,
      description:  json["description"] as String,
      icon:         json["category"]["icon"] as String,
    );
  }

}
