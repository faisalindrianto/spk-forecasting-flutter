import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spk/controller/main_controller.dart';
import 'package:spk/screens/datapenjualan.dart';
import 'package:spk/screens/homepage.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:spk/screens/metode.dart';
import 'package:spk/screens/prediksi.dart';
import 'package:spk/service/firestore_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({ Key key }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ShapeBorder bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(40)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.fromLTRB(18, 22, 18, 22);
  SnakeShape snakeShape = SnakeShape.indicator;
  bool showSelectedLabels = true;
  bool showUnselectedLabels = true;
  Color selectedColor = Colors.green;
  Gradient selectedGradient = const LinearGradient(colors: [Colors.red, Colors.amber]);
  Color unselectedColor = Colors.blueGrey;
  MainController mainController = Get.put(MainController());
  int currentTab = 0;

  DateTime selectedDate;
  DateFormat dateFormat = DateFormat("MMMM, yyyy", "id_ID");
  bool loadingAdd = false;
  TextEditingController mingguController = new TextEditingController();
  TextEditingController jumlahController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Get.put(MainController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                currentTab = index;
              });
            },
            controller: mainController.mainPageController.value,
            children: [
              HomePage(),
              PenjualanPage(),
              SizedBox(),
              PrediksiPage(),
              MetodePage()
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SnakeNavigationBar.color(
                    elevation: 4.0,
                    shadowColor: Colors.grey.withOpacity(0.3),
                    behaviour: snakeBarStyle,
                    snakeShape: snakeShape,
                    shape: bottomBarShape,
                    padding: padding,

                    snakeViewColor: selectedColor,
                    selectedItemColor: snakeShape == SnakeShape.indicator ? selectedColor : null,
                    unselectedItemColor: Colors.blueGrey,

                    showUnselectedLabels: showUnselectedLabels,
                    showSelectedLabels: showSelectedLabels,
                    selectedLabelStyle: TextStyle(fontSize: 12),
                    unselectedLabelStyle: TextStyle(fontSize: 12),

                    currentIndex: currentTab,
                    onTap: (index) {
                      setState(() => currentTab = index);
                      mainController.mainPageController.value.animateToPage(
                        index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut
                      );
                    },
                    items: [
                      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Data'),
                      BottomNavigationBarItem(icon: Icon(null), label: ''),
                      BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'Prediksi'),
                      BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Metode'),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: GetPlatform.isAndroid ? EdgeInsets.only(bottom: 40) : EdgeInsets.only(bottom: 80),
                    child: FloatingActionButton(
                      onPressed: () {
                        formTambah();
                      },
                      tooltip: 'Tambah Data Baru',
                      child: Icon(Icons.add),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  formTambah() {
    return Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.5,
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tambah Data",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close)
                    ),
                  ],
                ),
                SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    showMonthPicker(
                      context: context,
                      initialDate: DateTime.now()
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      )
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      selectedDate == null ? "Pilih Bulan dan Tahun" :
                      dateFormat.format(selectedDate).toString(),
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: mingguController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Minggu ke ?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.6)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  ),
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.8)
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: jumlahController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Jumlah Penjualan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.6)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  ),
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.8)
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      loadingAdd = true;
                    });
                    FirestoreService().addData(
                      selectedDate.month,
                      int.parse(jumlahController.text),
                      int.parse(mingguController.text),
                      selectedDate.year,
                    ).then((value) {
                      setState(() {
                        loadingAdd = false;
                      });
                      jumlahController.text = '';
                      mingguController.text = '';
                      if(value){
                        Get.back();
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Berhasil menambahkan data!'),
                            behavior: SnackBarBehavior.floating,
                          )
                        );
                      }else{
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Gagal menambahkan data!'),
                            behavior: SnackBarBehavior.floating,
                          )
                        );
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    alignment: Alignment.center,
                    child: loadingAdd ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    ) : Text(
                      "Tambah",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}