// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: (fields[0] as num).toInt(),
      title: fields[1] as String,
      author: fields[2] as String,
      imageUrl: fields[3] as String,
      downloadCount: (fields[4] as num).toInt(),
      languages: (fields[5] as List).cast<String>(),
      isCopyrighted: fields[6] as bool?,
      summaries: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.downloadCount)
      ..writeByte(5)
      ..write(obj.languages)
      ..writeByte(6)
      ..write(obj.isCopyrighted)
      ..writeByte(7)
      ..write(obj.summaries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
