import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StorageModel {
  @JsonKey(name: 'key')
  String key;

  @JsonKey(name: 'data')
  String data;

  StorageModel({this.key = '', this.data = ''});

  factory StorageModel.fromJson(Map<String, dynamic> json) => StorageModel(
        key: json['key'],
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
        'key': this.key,
        'data': this.data,
      };
}
