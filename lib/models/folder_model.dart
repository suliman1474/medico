import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'file_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'link_model.dart';

part 'folder_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class FolderModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String path;

  @HiveField(3)
  List<String>? subFolders;

  @HiveField(4)
  List<FolderModel>? actualSubfolders; // List of actual subfolders

  @HiveField(5)
  List<FileModel>? files;
  @HiveField(6)
  List<LinkModel>? links;
  @HiveField(7)
  bool appearance;

  @HiveField(8)
  String downloadUrl;
  @HiveField(9)
  String parentId;
  @HiveField(10)
  bool isLocked;
  FolderModel({
    required this.id,
    required this.name,
    required this.path,
    this.subFolders,
    this.actualSubfolders, // Update here to use actualSubfolders
    this.files,
    this.links,
    this.appearance = true,
    isLocked,
    this.downloadUrl = '',
    this.parentId = '',
  }) : isLocked = isLocked ?? false;

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? subFolderList = json['subFolders'];
    List<String>? subFolders = List<String>.from(subFolderList ?? []);

    // Convert subfolders list to actual subfolder instances
    List<FolderModel>? actualSubfolders = (subFolders != null)
        ? subFolders
            .map((id) => FolderModel(
                id: id, name: '', path: '', parentId: json['id'] as String))
            .toList()
        : null;

    return FolderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      subFolders: subFolders,
      actualSubfolders: actualSubfolders,
      files: (json['files'] as List<dynamic>)
          ?.map((e) => FileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: (json['links'] as List<dynamic>)
          ?.map((e) => LinkModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      appearance: json['appearance'] as bool? ?? true,
      isLocked: json['isLocked'] as bool? ?? false,
      parentId: json['parentId'] as String,
      downloadUrl: json['downloadUrl'] as String? ?? '',
    );
  }

  factory FolderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FolderModel(
      id: doc.id,
      name: data['name'],
      path: data['path'],
      subFolders: List<String>.from(data['subFolders'] ?? []),
      actualSubfolders: [],
      files: [],
      links: (data?['links'] != null)
          ? (data?['links'] is List<dynamic>
              ? (data?['links'] as List<dynamic>)
                  .map((e) => LinkModel.fromJson(e as Map<String, dynamic>))
                  .toList()
              : (data?['links'] is Map<String, dynamic>
                  ? [LinkModel.fromJson(data?['links'] as Map<String, dynamic>)]
                  : null))
          : null,
      appearance: data['appearance'] ?? true,
      isLocked: data['isLocked'] ?? false,
      downloadUrl: data['downloadUrl'] ?? '',
      parentId: data['parentId'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => _$FolderModelToJson(this);
}
