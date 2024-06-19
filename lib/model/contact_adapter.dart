import 'package:hive/hive.dart';

import 'contact.dart';

class ContactAdapter extends TypeAdapter<Contact> {
  @override
  final int typeId = 4;

  @override
  Contact read(BinaryReader reader) {
    return Contact(
      name: reader.readString(),
      email: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Contact obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.email);
  }
}
