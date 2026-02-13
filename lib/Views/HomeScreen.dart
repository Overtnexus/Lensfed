import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lensfed/Views/Screens/Meetings.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:lensfed/utilities/fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 late TabController _tabController;

 Widget _buildTabContent(List<String> names) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final gridItemWidth = screenWidth * 0.4;
    final gridItemHeight = screenHeight * 0.2;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,horizontal: screenHeight*0.02),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: screenHeight * 0.02,
          crossAxisSpacing: screenWidth * 0.03,
          crossAxisCount: 2,
          childAspectRatio: gridItemWidth / gridItemHeight,
        ),
        itemCount: names.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (names[index] == "Exit") {
                exit();
              } else {
                switch (names[index]) {
                  case "Ledger":
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => MeetingsScreen()));
                    break;
                //   case "Payment":
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => PaymentForm()));
                //     break;
                //   case "Receipt":
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => Reciept()));
                //     break;
                //   case "Sales":
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => SalesOrder()));
                //     break;
                //   case "Ledger Report":
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => LedgerReport()));
                //     break;
                //   case "Payment Report":
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => Paymentreport()));
                //     break;
                //   case "Receipt Report":
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => Recieptreport()));
                //     break;
                //   case "Sales Report":
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => SalesReport()));
                //     break;
                //   case "Stock Report":
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => StockReport()));
                //     break;
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.01),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors().searchTextcolor,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: const Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: gridItemHeight * 0.5,
                        width: gridItemWidth * 0.5,
                        // child: Image.asset(
                        //   images[index],
                        //   scale: 1.0,
                        // ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      names[index],
                      style: getFonts(screenWidth * 0.04, Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tab1Names = ["Ledger", "Exit"];
    final tab2Names = ["Payment", "Receipt", "Sales", "Exit"];
    final tab3Names = [
      "Ledger Report",
      "Payment Report",
      "Receipt Report",
      "Sales Report",
      "Stock Report",
      "Exit"
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final gridItemWidth = screenWidth * 0.4;
    final gridItemHeight = screenHeight * 0.2;
    return Scaffold(
      backgroundColor: Appcolors().scafoldcolor,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: Appcolors().maincolor,
        leading: Text(''),
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Text(
              "Sheracc ERP Offline",
              style: appbarFonts(MediaQuery.of(context).size.width * 0.04, Colors.white),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Appcolors().maincolor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Appcolors().maincolor,
            tabs: const [
              Tab(text: "Master"),
              Tab(text: "Entry"),
              Tab(text: "Reports"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(tab1Names),
                _buildTabContent(tab2Names),
                _buildTabContent(tab3Names),
              ],
            ),
          ),
        ],
      ),
    );

  }
  void exit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Appcolors().scafoldcolor,
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Are you confirm To Exit App?',
              style: getFonts(14, Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: getFonts(15, Appcolors().maincolor),
              ),
            ),
            TextButton(
              onPressed: () async {
                SystemNavigator.pop();
              },
              child: Text(
                'Yes',
                style: getFonts(15, Appcolors().maincolor),
              ),
            ),
          ],
        );
      },
    );
  }
}