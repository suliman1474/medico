// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PollModelAdapter extends TypeAdapter<PollModel> {
  @override
  final int typeId = 3;

  @override
  PollModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PollModel(
      id: fields[0] as String,
      question: fields[1] as String,
      options: (fields[3] as List).cast<OptionModel>(),
      timestamp: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PollModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollModel _$PollModelFromJson(Map<String, dynamic> json) => PollModel(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$PollModelToJson(PollModel instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'timestamp': instance.timestamp,
      'options': instance.options,
    };
