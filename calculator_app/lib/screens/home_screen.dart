import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String userInput = "";
  String result = "0";

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
      backgroundColor: Color.fromARGB(255, 190, 189, 189),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height/3.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    userInput,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),

          const Divider(
            color: Colors.white,
          ),

          Expanded(
            child: Container(
              // padding: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 20.0),
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
              // EdgeInsets.fromLTRB(left, top, right, bottom)
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
      splashColor: Color.fromARGB(255, 190, 189, 189),
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
              offset: Offset(-3, -3),
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
        return Color.fromARGB(255, 252, 100, 100);
    }
    return Colors.white;
  }

  getBgColor(String text){
    if(text == "AC"){
        return Color.fromARGB(255, 252, 100, 100);
    }
    if(text == "="){
      return Color.fromARGB(255, 104, 204, 159);
    }
    return Color.fromARGB(255, 0, 0, 0);
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
      if(result.endsWith(".0")){
        result = result.replaceAll(".0", "");
        return;
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