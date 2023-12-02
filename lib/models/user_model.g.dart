// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      college: fields[4] as String,
      contact: fields[7] as String,
      discipline: fields[5] as String,
      email: fields[2] as String,
      image: fields[3] as String?,
      role: fields[8] as String,
      semester: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.college)
      ..writeByte(5)
      ..write(obj.discipline)
      ..writeByte(6)
      ..write(obj.semester)
      ..writeByte(7)
      ..write(obj.contact)
      ..writeByte(8)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      college: json['college'] as String,
      contact: json['contact'] as String,
      discipline: json['discipline'] as String,
      email: json['email'] as String,
      image: json['image'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      semester: json['semester'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'college': instance.college,
      'discipline': instance.discipline,
      'semester': instance.semester,
      'contact': instance.contact,
      'role': instance.role,
    };
