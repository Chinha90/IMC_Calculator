import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Definição de Variáveis
  String _message = "Coloque o seu Peso e Altura";
  final TextEditingController _controllerWeight = TextEditingController();
  final TextEditingController _controllerHeight = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Variável para controlar o tamanho da imagem
  double _imageScale = 1.0;

// Função para criar as caixas de input
  Widget buildTextField(String label, TextEditingController _controller) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green[900]),
        border: OutlineInputBorder(),
      ),
      // Input do Utilizador
      style: TextStyle(color: Colors.green),
      keyboardType: TextInputType.number,
    );
  }

  // Função para fazer reset das caixas de input
  void _resetFields() {
    setState(() {
      _controllerWeight.text = "";
      _controllerHeight.text = "";
      _message = "Coloque o seu Peso e Altura";
    });
  }

//Função para calcular IMC
  void _imcCalculator() {
    // Substitui vírgulas por pontos
    String weightString = _controllerWeight.text.replaceAll(',', '.');
    String heightString = _controllerHeight.text.replaceAll(',', '.');

    // Passar a variável, obtida pelo input(string), para  double
    double weight = double.parse(weightString);
    double height = double.parse(heightString) / 100;
    double imc = weight / (height * height);

    setState(() {
      if (imc < 18.5) {
        _message = "Está abaixo do Peso.\nIMC = ${imc.toStringAsFixed(2)} ";
      } else if (imc >= 18.5 && imc <= 24.9) {
        _message = "Peso Ideal.\nIMC = ${imc.toStringAsFixed(2)}";
      } else if (imc >= 24.9 && imc <= 29.9) {
        _message = "Levemente Acima do Peso.\nIMC = ${imc.toStringAsFixed(2)}";
      } else if (imc >= 29.9 && imc <= 34.9) {
        _message = "Obesidade Grau I.\nIMC = ${imc.toStringAsFixed(2)}";
      } else if (imc >= 34.9 && imc <= 39.9) {
        _message = "Obesidade Grau II.\nIMC = ${imc.toStringAsFixed(2)}";
      } else if (imc >= 40) {
        _message = "Obesidade Grau III.\nIMC = ${imc.toStringAsFixed(2)}";
      }
    });
  }

  // Função para alterar o tamanho da imagem
  void _changeImageScale(bool isTapped) {
    setState(() {
      _imageScale = isTapped ? 1.2 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(201, 254, 165, 0.988),
        title: const Text("Calculadora de IMC"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _resetFields();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child:
            // Criar um Form para trabalhar os dados
            Form(
          key: _formKey,

          // Coluna com o conteúdo da página
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 80),
              GestureDetector(
                onTapDown: (_) => _changeImageScale(true), // Aumenta o scale
                onTapUp: (_) =>
                    _changeImageScale(false), // Retorna ao scale original
                onTapCancel: () => _changeImageScale(
                    false), // Retorna ao scale original se o toque for cancelado
                child: Transform.scale(
                  scale: _imageScale,
                  child: Image.asset("assets/images/imc.png", height: 220),
                ),
              ),
              const SizedBox(height: 50),
              //Input de Peso
              buildTextField("Peso (kg)", _controllerWeight),
              // Separador
              const SizedBox(height: 20),
              // Input Altura
              buildTextField("Altura (cm)", _controllerHeight),
              const SizedBox(height: 30),

              // Botão
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _imcCalculator();
                    }
                  },
                  child: const Text('Calcular',
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(42, 100, 3, 0.984))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(201, 254, 165, 0.988),
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )),
              const SizedBox(height: 30),

              // Mensagem de resultado e inicio
              Text(
                _message,
                style: const TextStyle(
                    fontSize: 17, color: Color.fromRGBO(42, 100, 3, 0.984)),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
