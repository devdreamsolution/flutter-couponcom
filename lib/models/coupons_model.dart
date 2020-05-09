class CouponModel {
  int id;
  String description;
  String code;
  String discount;
  int storeId;
  String storeName;
  String storeImage;
  String storeLink;
  String createdAt;
  String updatedAt;

  CouponModel({
    this.id,
    this.description,
    this.code,
    this.discount,
    this.storeId,
    this.storeName,
    this.storeImage,
    this.storeLink,
    this.createdAt,
    this.updatedAt,
  });

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    code = json['code'];
    discount = json['discount'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    storeImage = json['storeImage'];
    storeLink = json['storeLink'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['code'] = this.code;
    data['discount'] = this.discount;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['storeImage'] = this.storeImage;
    data['storeLink'] = this.storeLink;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
