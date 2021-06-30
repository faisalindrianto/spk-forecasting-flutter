import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spk/controller/main_controller.dart';
import 'package:spk/custom_widget.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({ Key key }) : super(key: key);

  @override
  _PenjualanPageState createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  List month = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Data Penjualan"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetX<MainController>(
              init: Get.put(MainController()),
              builder: (MainController mainController) {
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 16, left: 12, right: 12, top: 16),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: mainController.allData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Minggu ke ${mainController.allData[index].minggu} bulan ${month[mainController.allData[index].bulan-1]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Tahun ${mainController.allData[index].tahun}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              mainController.allData[index].jumlah.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.green
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
            ),
            SizedBox(height: 140)
          ],
        ),
      ),
    );
  }
}