import 'package:cloud_firestore/cloud_firestore.dart';

class PenjualanModel {
  String id;
  int bulan;
  int jumlah;
  int minggu;
  int tahun;
  Timestamp waktuTambah;

  PenjualanModel({
    this.id, this.bulan, this.jumlah,
    this.minggu, this.tahun, this.waktuTambah
  });

  PenjualanModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    bulan = snapshot.data()['bulan'];
    jumlah = snapshot.data()['jumlah'];
    minggu = snapshot.data()['minggu'];
    tahun = snapshot.data()['tahun'];
    waktuTambah = snapshot.data()['waktu_tambah'];
  } 
}