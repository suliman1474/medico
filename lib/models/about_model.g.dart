// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AboutModelAdapter extends TypeAdapter<AboutModel> {
  @override
  final int typeId = 7;

  @override
  AboutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AboutModel(
      image: fields[0] as String,
      description: fields[1] as String,
      whatsapp: fields[2] as String,
      insta: fields[3] as String,
      gmail: fields[4] as String,
      ownername: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AboutModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.whatsapp)
      ..writeByte(3)
      ..write(obj.insta)
      ..writeByte(4)
      ..write(obj.gmail)
      ..writeByte(5)
      ..write(obj.ownername);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AboutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutModel _$AboutModelFromJson(Map<String, dynamic> json) => AboutModel(
      image: json['image'] as String,
      description: json['description'] as String,
      whatsapp: json['whatsapp'] as String,
      insta: json['insta'] as String,
      gmail: json['gmail'] as String,
      ownername: json['ownername'] as String,
    );

Map<String, dynamic> _$AboutModelToJson(AboutModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'description': instance.description,
      'whatsapp': instance.whatsapp,
      'insta': instance.insta,
      'gmail': instance.gmail,
      'ownername': instance.ownername,
    };
