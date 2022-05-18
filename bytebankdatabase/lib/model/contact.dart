class Contact {
  final int? id;
  final String name;
  final int? accountNumber;

  Contact({
    this.id,
    required this.name,
    required this.accountNumber,
  });

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        accountNumber = json['accountNumber'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'accountNumber': accountNumber,
      };

  @override
  String toString() =>
      'New Contact(id:$id,name: $name, number: $accountNumber)';
}
