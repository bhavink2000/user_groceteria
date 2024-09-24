/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class DriverAssignmentModel {
  int? driver;
  int? assignee;

  DriverAssignmentModel({this.driver, this.assignee});

  DriverAssignmentModel.fromJson(Map<String, dynamic> json) {
    driver = int.parse(json['driver'].toString());
    assignee = int.parse(json['assignee'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver'] = driver;
    data['assignee'] = assignee;
    return data;
  }
}
