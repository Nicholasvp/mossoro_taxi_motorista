import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/tabs/earningstab.dart';
import 'package:mossorotaximotorista/tabs/hometab.dart';
import 'package:mossorotaximotorista/tabs/profiletab.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selecetdIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selecetdIndex = index;
      tabController!.index = selecetdIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          HomeTab(),
          EarningsTab(),
          // RatingsTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.star),
          //   label: 'Avaliações',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: selecetdIndex,
        backgroundColor: BrandColors.colorCampanha,
        unselectedItemColor: Colors.white,
        selectedItemColor: BrandColors.colorIcon,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked,
      ),
    );
  }
}
