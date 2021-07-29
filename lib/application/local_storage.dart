import 'package:localstore/localstore.dart';

Future<String?> getSingleFromLocalStorage(String collection, String id) async {
  final storage = Localstore.instance;
  final docs = await storage.collection('looneytube').doc(collection).get();

  return docs != null ? docs[id] : null;
}

Future<String?> storeSingle(String collection, String id, String value) async {
  final storage = Localstore.instance;
  final Map<String, dynamic> toStore = {};

  toStore[id] = value;
  final docs = await storage.collection('looneytube').doc(collection).set(toStore);

  return docs != null ? docs[id] : null;
}
