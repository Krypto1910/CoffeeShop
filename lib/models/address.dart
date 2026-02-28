class Address {
  int id;
  String title;
  String detail;
  bool isSelected;

  Address({
    required this.id,
    required this.title,
    required this.detail,
    this.isSelected = false,
  });

  Address copyWith({
    int? id,
    String? title,
    String? detail,
    bool? isSelected,
  }) {
    return Address(
      id: id ?? this.id,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}