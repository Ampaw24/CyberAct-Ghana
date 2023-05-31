import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyData {
  final String name;
  final int age;

  MyData({required this.name, required this.age});

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      name: json['name'],
      age: json['age'],
    );
  }
}

class FetchDataFromJson extends StatefulWidget {
  @override
  _FetchDataFromJsonState createState() => _FetchDataFromJsonState();
}

class _FetchDataFromJsonState extends State<FetchDataFromJson> {
  List<MyData> dataList = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://example.com/data.json'));
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        dataList = (jsonData as List)
            .map((data) => MyData.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data from JSON'),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dataList[index].name),
            subtitle: Text('Age: ${dataList[index].age}'),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FetchDataFromJson(),
  ));
}
