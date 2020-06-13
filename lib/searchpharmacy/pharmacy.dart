class Pharmacy {

  final int id;
  final String pharmacy_name;
  final String pharmacy_logo;
  final String city;
  final String location;
  final String address;
  final String latitude;
  final String longitude;

  Pharmacy({ this.id,
            this.pharmacy_name, 
            this.pharmacy_logo,
            this.city,
            this.location,
            this.address,
            this.latitude,
            this.longitude,
          });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return new Pharmacy(
      id:             json['id'] as int,
      pharmacy_name:  json["pharmacy_name"] as String,
      pharmacy_logo:  json["pharmacy_logo"] as String,
      city:           json["city"] as String,
      location:       json["location"] as String,
      address:        json["address"] as String,
      latitude:       json["latitude"] as String,
      longitude:      json["longitude"] as String,
    );
  }
}
