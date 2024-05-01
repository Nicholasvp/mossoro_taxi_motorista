import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/dataprovider.dart';
import 'package:mossorotaximotorista/widgets/BrandDivier.dart';
import 'package:mossorotaximotorista/widgets/HistoryTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  final String type;

  HistoryPage({required this.type});

  @override
  _HistoryPageState createState() => _HistoryPageState(type: type);
}

class _HistoryPageState extends State<HistoryPage> {
  _HistoryPageState({required this.type});

  String type;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Histórico de Viagens ${(type == 'passenger') ? '(Passageiros)' : '(Documentos)'}'),
        backgroundColor: BrandColors.colorCampanha,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return HistoryTile(
            history: (type == 'passenger')
                ? Provider.of<AppData>(context).tripPassengerHistory[index]
                : Provider.of<AppData>(context).tripDocumentHistory[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => BrandDivider(),
        itemCount: (type == 'passenger')
            ? Provider.of<AppData>(context).tripPassengerHistory.length
            : Provider.of<AppData>(context).tripDocumentHistory.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
