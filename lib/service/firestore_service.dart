import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spk/model/penjualan_model.dart';

class FirestoreService{
  CollectionReference dataPenjualan = FirebaseFirestore.instance.collection('data_penjualan');
  Future<bool> addData(int bulan, int jumlah, int minggu, int tahun) async {
    bool status;

    await FirebaseFirestore.instance.collection('data_penjualan').add({
      "tahun" : tahun,
      "bulan" : bulan,
      "minggu" : minggu,
      "jumlah" : jumlah,
      "tanggal_lengkap" : "$tahun-$bulan-$minggu",
      "waktu_tambah" : FieldValue.serverTimestamp()
    }).then((value) {
      status = true;
    }).catchError((err) {
      status = false;
    });

    return status;
  }

  Future<List<PenjualanModel>> getData({int limit}) async {
    List<PenjualanModel> data = [];

    if(limit != null) {
      await dataPenjualan.limit(limit).orderBy("tanggal_lengkap", descending: true).get().then((snap) {
        snap.docs.forEach((doc) {
          data.add(PenjualanModel.fromDocumentSnapshot(doc));
        });
      });
    } else {
      await dataPenjualan.orderBy("tanggal_lengkap", descending: true).get().then((snap) {
        snap.docs.forEach((doc) {
          data.add(PenjualanModel.fromDocumentSnapshot(doc));
        });
      });
    }


    return data;
  }

  Stream<List<PenjualanModel>> streamData({int limit, String orderBy}) {
    Query query = dataPenjualan;

    if(limit != null) {
      query = query.limit(limit);
    }

    if(orderBy != null) {
      query = query.orderBy(orderBy, descending: true);
    }

    return query.snapshots().map((QuerySnapshot snapshot) {
      List<PenjualanModel> penjualanData = [];

      snapshot.docs.forEach((doc) {
        penjualanData.add(PenjualanModel.fromDocumentSnapshot(doc));
      });

      return penjualanData;
    });
  }
}