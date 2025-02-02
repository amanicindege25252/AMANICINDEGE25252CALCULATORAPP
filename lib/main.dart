import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _input = '';

  void _onPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _display = '0';
        _input = '';
      } else if (value == '=') {
        try {
          _display = _evaluateExpression(_input);
          _input = _display;
        } catch (e) {
          _display = 'Error';
          _input = '';
        }
      } else {
        _input += value;
        _display = _input;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      expression = expression.replaceAll('x', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _display,
                style: TextStyle(fontSize: 80, color: Colors.white),
              ),
            ),
          ),
          _buildButtonRow(['AC', 'C', '%', '÷']),
          _buildButtonRow(['7', '8', '9', 'x']),
          _buildButtonRow(['4', '5', '6', '-']),
          _buildButtonRow(['1', '2', '3', '+']),
          _buildButtonRow(['0', '00', '.', '=']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: values.map((value) => _buildButton(value)).toList(),
    );
  }

  Widget _buildButton(String value) {
    bool isOperator = ['+', '-', 'x', '÷', '='].contains(value);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onPressed(value),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          backgroundColor: isOperator ? Colors.orange : Colors.grey[800],
          foregroundColor: Colors.white,
        ),
        child: Text(
          value,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
