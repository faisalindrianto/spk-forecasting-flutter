import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spk/model/penjualan_model.dart';
import 'package:spk/service/firestore_service.dart';

class MainController extends GetxController {
  RxList<PenjualanModel> dataPenjualan = List<PenjualanModel>().obs;
  RxList<PenjualanModel> allData = List<PenjualanModel>().obs;
  Rx<PageController> mainPageController = PageController().obs;

  @override
  void onReady() {
    dataPenjualan.bindStream(FirestoreService().streamData(orderBy: "tanggal_lengkap", limit: 4));
    allData.bindStream(FirestoreService().streamData(orderBy: "tanggal_lengkap"));
    super.onReady();
  }
}