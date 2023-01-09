import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String userInput = "";
  String result = "0";

  bool mode = false;

  List<String> buttonList = [
    "AC",
    "(",
    ")",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "-",
    "C",
    "0",
    ".",
    "=",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? Color.fromARGB(255, 240, 239, 239): Color.fromARGB(255, 44, 42, 42) ,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height/3.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ToggleSwitch(
                        minWidth: 50.0,
                        initialLabelIndex: 1,
                        cornerRadius: 10.0,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Color.fromARGB(255, 196, 196, 196),
                        inactiveFgColor: Color.fromARGB(255, 0, 0, 0),
                        totalSwitches: 2,
                        icons: [Icons.mode_night , Icons.light_mode ],
                        // labels: ['Night', 'Light'],
                        activeBgColors: [[Color.fromARGB(255, 206, 203, 203)],[Color.fromARGB(255, 51, 50, 50)]],
                        onToggle: (index) {
                        setState(() {
                          if(index == 0){
                            mode = true;
                          }
                          if(index == 1){
                          mode = false;
                          }
                        });
                        print(mode);
                        },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    userInput,
                    style: TextStyle(
                      fontSize: 32,
                      color: mode ? Color.fromARGB(255, 44, 42, 42) : Color.fromARGB(255, 236, 235, 235)
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: TextStyle(
                      fontSize: 48,
                      color: mode ? Color.fromARGB(255, 44, 42, 42) : Color.fromARGB(255, 236, 235, 235),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),

          const Divider(
            color: Color.fromARGB(255, 189, 187, 187),
            thickness: 1,
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 20.0),
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
              child: GridView.builder(
                itemCount: buttonList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ), 
                itemBuilder: (BuildContext context, int index){
                  return CustomButton(buttonList[index]);
                }
                ),
            )
            )

        ]
      )
      ,
    );
  }

  Widget CustomButton(String text){
    return InkWell(
      splashColor: mode ? Colors.white: Color.fromARGB(255, 44, 42, 42),
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(-3, -3),
            )
          ]
        ),

        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text),
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

      ),
    );
  }

  getColor(String text){
    if(
      text == "/" || 
      text == "*" || 
      text == "+" || 
      text == "-" || 
      text == "C" || 
      text == "(" || 
      text == ")" 
      ){
        return const Color.fromARGB(255, 252, 100, 100);
    }
    return mode ? Color.fromARGB(255, 32, 32, 32): Color.fromARGB(255, 243, 240, 240);
  }

  getBgColor(String text){
    if(text == "AC"){
        return const Color.fromARGB(255, 252, 100, 100);
    }
    if(text == "="){
      return const Color.fromARGB(255, 104, 204, 159);
    }
    return mode ? Color.fromARGB(255, 238, 230, 230) :Color.fromARGB(255, 75, 75, 75);
  }

  handleButtons(String text){

    if(text == "AC"){
      userInput = "";
      result = "0";
      return;
    }

    if(text == "C"){
      if(userInput.isNotEmpty){
        return userInput = userInput.substring(0, userInput.length-1);
      }
    else{
      return null;
    }
    }

    if(text == "="){
      result = calculate();
      userInput = result;

      if(userInput.endsWith(".0")){
        return result = result.replaceAll(".0", "");
      }

      if(result.endsWith(".0")){
        return result = result.replaceAll(".0", "");
      }
    }

    userInput = userInput+text;

  }

  String calculate(){
    try{
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    }catch(e){
      return "Error";
    }
  }

}