import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:spk/custom_widget.dart';
import 'package:spk/model/penjualan_model.dart';
import 'package:spk/service/firestore_service.dart';

class PrediksiPage extends StatefulWidget {
  const PrediksiPage({ Key key }) : super(key: key);

  @override
  _PrediksiPageState createState() => _PrediksiPageState();
}

class _PrediksiPageState extends State<PrediksiPage> {
  bool loading = false;
  int selectedMinggu;
  PredictionResult result;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Prediksi"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prediksi untuk...",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      child: CupertinoPicker(
                                        backgroundColor: Colors.white,
                                        onSelectedItemChanged: (value) {
                                          setState(() {
                                            selectedMinggu = value + 1;
                                          });
                                        },
                                        itemExtent: 32.0,
                                        children: const [
                                          Text('1'),
                                          Text('2'),
                                          Text('3'),
                                          Text('4'),
                                          Text('5'),
                                          Text('6'),
                                          Text('7'),
                                          Text('8'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () => Get.back(),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(100)
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Pilih",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              );
                            },
                            isScrollControlled: true,
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            )
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            selectedMinggu == null ? "Berapa minggu?" : "$selectedMinggu minggu ke depan",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          // for loading
                          Get.bottomSheet(
                            Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: Lottie.network("https://assets2.lottiefiles.com/packages/lf20_YH7Lm4.json")
                                  ),
                                  Text(
                                    "Tunggu sebentar yaa...",
                                    style: TextStyle(
                                      fontSize: 16
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                ],
                              ),
                            )
                          );
                          Future.delayed(Duration(seconds: 5), () async {
                            await startPrediction().then((value) {
                              setState(() {
                                result = value;
                              });
                              Get.back();
                            });
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100)
                          ),
                          alignment: Alignment.center,
                          child: loading ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          ) : Text(
                            "Mulai Prediksi",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                result != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Text(
                              "Timeseries"
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "X"
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Y"
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "XX"
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "XY"
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: result.listData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${result.listData[index].timeSeries}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Jumlah penjualan : ${result.listData[index].penjualan}",
                                        style: TextStyle(
                                          color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    result.listData[index].x.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    result.listData[index].y.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    result.listData[index].xx.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    result.listData[index].xy.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "A : ${result.a}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "B : ${result.b}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Total X : ${result.sumX}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Total Y : ${result.sumY}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Total XX : ${result.sumXX}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Total XY : ${result.sumXY}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 200)
                  ],
                ) : Container(),
                SizedBox(height: 200)
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: result != null ? 1 : 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).size.height * 0.15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    )
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hasil prediksi",
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      result?.conclusion ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<PredictionResult> startPrediction() async {
    int startX = -1;
    double sumX = 0;
    double sumY = 0;
    double sumXX = 0;
    double sumXY = 0;
    List<PenjualanModel> allData = await FirestoreService().getData();
    List<TimeSeriesModel> timeSeries = [];

    allData.forEach((data) {
      startX++;

      timeSeries.add(TimeSeriesModel(
        timeSeries: "Minggu ke ${data.minggu} bulan ${data.bulan} ${data.tahun}",
        penjualan: data.jumlah,
        x: startX,
        y: data.jumlah,
        xx: startX * startX,
        xy: startX * data.jumlah
      ));

      print("Minggu ke ${data.minggu} bulan ${data.bulan} ${data.tahun} - X : $startX | Y : ${data.jumlah} | XX : ${startX * startX} | XY : ${startX * data.jumlah}");
    });

    timeSeries.forEach((element) {
      sumX += element.x;
      sumY += element.y;
      sumXX += element.xx;
      sumXY += element.xy;
    });

    int n = allData.length;
    print("jumlah data : $n");
    print("sum X : $sumX | sum Y : $sumY | sum XX : $sumXX | sum XY : $sumXY");
    print("rata rata X : ${sumX / n} | rata rata Y : ${sumY / n}");

    double b = (sumXY - ((sumX * sumY) / n))/(sumXX - ((sumX * sumX) / n));
    double a = (sumY / n) - b * (sumX / n);
    double y = a + b * n;

    print("B : $b");
    print("A : $a");
    print("Y : $y");

    print("last x is $startX");
    startX = startX + selectedMinggu;
    y = a + b * startX;
    print("Prediksi penjualan $selectedMinggu minggu berikutnya adalah $y");

    return PredictionResult(
      a: a,
      b: b,
      conclusion: "Prediksi penjualan $selectedMinggu minggu berikutnya adalah $y",
      listData: timeSeries,
      sumX: sumX,
      sumXX: sumXX,
      sumXY: sumXY,
      sumY: sumY,
      y: y
    );
  }
}

class TimeSeriesModel {
  String timeSeries;
  int penjualan;
  int x;
  int y;
  int xx;
  int xy;

  TimeSeriesModel({
    this.timeSeries,
    this.penjualan,
    this.x,
    this.y,
    this.xx,
    this.xy
  });
}

class PredictionResult {
  List<TimeSeriesModel> listData;
  double sumX;
  double sumY;
  double sumXX;
  double sumXY;
  double a;
  double b;
  double y;
  String conclusion;

  PredictionResult({
    this.listData,
    this.sumX,
    this.sumY,
    this.sumXX,
    this.sumXY,
    this.a,
    this.b,
    this.y,
    this.conclusion
  });
}