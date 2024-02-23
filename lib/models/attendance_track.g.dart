// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceTrackAdapter extends TypeAdapter<AttendanceTrack> {
  @override
  final int typeId = 2;

  @override
  AttendanceTrack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceTrack(
      courseUnit: fields[0] as String,
      signInSuccessful: fields[1] as bool,
      timeSignedIn: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceTrack obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.courseUnit)
      ..writeByte(1)
      ..write(obj.signInSuccessful)
      ..writeByte(2)
      ..write(obj.timeSignedIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceTrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}