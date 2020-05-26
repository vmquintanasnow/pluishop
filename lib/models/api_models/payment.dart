class Payment {
  String url;
  String name;
  bool active;
  String accountNumber;
  String confirmationPhone;

  Payment(
      {this.url,
      this.name,
      this.active,
      this.accountNumber,
      this.confirmationPhone});

  Payment.fromJson(Map json)
      : url = json["url"],
        name = json["name"],
        active = json["active"],
        accountNumber =
            json["account_number"] == false ? "" : json["account_number"],
        confirmationPhone = json["confirmation_phone"] == false
            ? ""
            : json["confirmation_phone"];

  String getId() {
    return url.split('=')[1];
  }
}
