class AdminModel {
  String email, password,id;
  bool showOrders, showCategories, addCat, saveOrder, removeOrder;

  AdminModel({required this.id,
    required this.email, required this.showOrders, required this.showCategories, required this.addCat,
    required this.saveOrder, required this.removeOrder,required this.password
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': id,
      'showOrders': showOrders,
      'showCategories': showCategories,
      'addCat': addCat,
      'saveOrder': saveOrder,
      'password': password,
      'removeOrder': removeOrder,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      email: map['email'],
      id: map['id'],
      password: map['password'],
      showOrders: map['showOrders'],
      showCategories: map['showCategories'],
      addCat: map['addCat'],
      saveOrder: map['saveOrder'],
      removeOrder: map['removeOrder'],
    );
  }
}