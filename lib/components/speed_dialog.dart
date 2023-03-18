import 'package:ebook/view_models/speed_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../theme/theme_config.dart';

class SpeedDialog extends StatefulWidget {
  const SpeedDialog(
      {super.key,
      required this.onChooseSpeed});
  final Function onChooseSpeed;

  @override
  State<SpeedDialog> createState() => _SpeedDialogState();
}

class _SpeedDialogState extends State<SpeedDialog> {
  double speed = 0.5;
  @override
  void initState() {
    super.initState();
    speed = Provider.of<SpeedProvider>(context, listen: false).getSpeed();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.3,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [buildHeader(), buildSlider(), buildButton()],
      ),
    );
  }

  buildHeader() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Tốc độ ${speed}x',
              style: TextStyle(
                  color: ThemeConfig.lightAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              height: 30,
              width: 30,
              margin: const EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                  color: ThemeConfig.fourthAccent, shape: BoxShape.circle),
              child: Center(
                  child: IconButton(
                icon: const Icon(Icons.clear_rounded),
                color: Colors.white,
                iconSize: 15,
                onPressed: () {
                  Navigator.pop(context);
                },
              ))),
        ],
      ),
    );
  }
  
  buildSlider() {
    return Expanded(
      flex: 1,
      child: SizedBox(
        child: SfSlider(
          min: 0.5,
          max: 2.0,
          value: speed,
          interval: 0.1,
          showTicks: true,
          activeColor: Colors.blueGrey,
           labelFormatterCallback: (dynamic actualValue, String formattedText) {
              final speed = double.parse(actualValue.toStringAsFixed(1));
              if(speed == 0.5 || speed == 1.0 || speed == 2.0) {
                return '${speed}x';
              } 
              else {
                return '';
              }
            },
          showLabels: true,
          
          onChanged: (dynamic value) {
            setState(() {
              speed = double.parse((value as double).toStringAsFixed(1));
            });
          },
        ),
      ),
      );
  }
  
  buildButton() {
    return Consumer<SpeedProvider>(
      builder: (context, event, _){
        return Expanded(
          child: InkWell(
            onTap: (){
              if(speed != event.getSpeed()) {
                event.setSpeed(speed);
                widget.onChooseSpeed(speed);
              }
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                colors: [Colors.red, Colors.blue],
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
              ),
                borderRadius: BorderRadius.circular(20)
              ),
              child: const Center(child: Text('Xong', style: TextStyle(color: Colors.white , fontSize: 20),)),
            ),
          ));
      });
  }

  
}
