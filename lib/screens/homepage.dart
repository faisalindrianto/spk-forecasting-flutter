import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spk/controller/main_controller.dart';
import 'package:spk/custom_widget.dart';
import 'package:spk/model/penjualan_model.dart';
import 'package:spk/service/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loadingData = true;
  List<PenjualanModel> dataPenjualan = [];
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
  void initState() {
    FirestoreService().getData(limit: 4).then((value) {
      setState(() {
        dataPenjualan = value;
        loadingData = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Selamat Datang!"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container (
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 16, bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: AssetImage("assets/images/banner.png"),
                    fit: BoxFit.cover
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      "Aplikasi Prediksi Penjualan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Soto Ayam Sajiwo Lestari",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Get.find<MainController>().mainPageController.value.animateToPage(
                          3,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.green
                          ),
                        ),
                        child: Text(
                          "Prediksi Sekarang!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Data Mingguan",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
                ),
              ),
              SizedBox(height: 16),
              GetX<MainController>(
                init: Get.put(MainController()),
                builder: (MainController mainController) {
                  if(mainController.dataPenjualan.length > 0) {
                    return Column(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.only(bottom: 16),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mainController.dataPenjualan.length,
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
                                          "Minggu ke ${mainController.dataPenjualan[index].minggu} bulan ${month[mainController.dataPenjualan[index].bulan-1]}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Tahun ${mainController.dataPenjualan[index].tahun}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      mainController.dataPenjualan[index].jumlah.toString(),
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
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.find<MainController>().mainPageController.value.animateToPage(
                              1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Lihat Rekap Data Penjualan",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.green,
                                size: 20,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container(
                      height: 200,
                      child: Center(child: Text("Belum ada data"))
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
