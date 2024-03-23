// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderModelAdapter extends TypeAdapter<FolderModel> {
  @override
  final int typeId = 4;

  @override
  FolderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FolderModel(
      id: fields[0] as String,
      name: fields[1] as String,
      path: fields[2] as String,
      subFolders: (fields[3] as List?)?.cast<String>(),
      actualSubfolders: (fields[4] as List?)?.cast<FolderModel>(),
      files: (fields[5] as List?)?.cast<FileModel>(),
      links: (fields[6] as List?)?.cast<LinkModel>(),
      appearance: fields[7] as bool,
      isLocked: fields[10] as dynamic,
      downloadUrl: fields[8] as String,
      parentId: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FolderModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.subFolders)
      ..writeByte(4)
      ..write(obj.actualSubfolders)
      ..writeByte(5)
      ..write(obj.files)
      ..writeByte(6)
      ..write(obj.links)
      ..writeByte(7)
      ..write(obj.appearance)
      ..writeByte(8)
      ..write(obj.downloadUrl)
      ..writeByte(9)
      ..write(obj.parentId)
      ..writeByte(10)
      ..write(obj.isLocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderModel _$FolderModelFromJson(Map<String, dynamic> json) => FolderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      subFolders: (json['subFolders'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      actualSubfolders: (json['actualSubfolders'] as List<dynamic>?)
          ?.map((e) => FolderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => FileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => LinkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      appearance: json['appearance'] as bool? ?? true,
      isLocked: json['isLocked'],
      downloadUrl: json['downloadUrl'] as String? ?? '',
      parentId: json['parentId'] as String? ?? '',
    );

Map<String, dynamic> _$FolderModelToJson(FolderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'subFolders': instance.subFolders,
      'actualSubfolders': instance.actualSubfolders,
      'files': instance.files,
      'links': instance.links,
      'appearance': instance.appearance,
      'downloadUrl': instance.downloadUrl,
      'parentId': instance.parentId,
      'isLocked': instance.isLocked,
    };
