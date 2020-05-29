class Product {

  final int id;
  final String product_name;
  final String productprice;
  final String pharmacy_name;
  final String pharmacy_logo;
  final int pharmacy_id;
  final String city;
  final String location;
  final String address;
  final String latitude;
  final String longitude;

  Product({ this.id,
            this.product_name, 
            this.productprice, 
            this.pharmacy_name, 
            this.pharmacy_logo,
            this.pharmacy_id,
            this.city,
            this.location,
            this.address,
            this.latitude,
            this.longitude,
          });

  factory Product.fromJson(Map<String, dynamic> json) {
    return new Product(
      id:             json['id'] as int,
      product_name:   json['product_name'] as String,
      productprice:   json['productprice'] as String,
      pharmacy_name:  json["pharmacy"]["pharmacy_name"] as String,
      pharmacy_logo:  json["pharmacy"]["pharmacy_logo"] as String,
      pharmacy_id:    json["pharmacy"]["id"] as int,
      city:           json["pharmacy"]["city"] as String,
      location:       json["pharmacy"]["location"] as String,
      address:        json["pharmacy"]["address"] as String,
      latitude:       json["pharmacy"]["latitude"] as String,
      longitude:      json["pharmacy"]["longitude"] as String,
    );
  }
}
