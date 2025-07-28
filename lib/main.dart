import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

void main() {
  runApp(const ConvolutionCalculatorApp());
}

class ConvolutionCalculatorApp extends StatelessWidget {
  const ConvolutionCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
          brightness: Brightness.light,
        ),
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
      ),
      home: const ConvolutionCalculator(),
    );
  }
}

class ConvolutionCalculator extends StatefulWidget {
  const ConvolutionCalculator({Key? key}) : super(key: key);

  @override
  _ConvolutionCalculatorState createState() => _ConvolutionCalculatorState();
}

class _ConvolutionCalculatorState extends State<ConvolutionCalculator> {
  final TextEditingController signal1Controller = TextEditingController();
  final TextEditingController signal2Controller = TextEditingController();
  List<int> result = [];

  // Hàm tính convolution
  List<int> calculateConvolution(List<int> signal1, List<int> signal2) {
    int n = signal1.length;
    int m = signal2.length;
    List<int> convolution = List.filled(n + m - 1, 0);

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        convolution[i + j] += signal1[i] * signal2[j];
      }
    }
    return convolution;
  }

  void handleCalculate() {
    try {
      // Chuyển đổi input thành danh sách số nguyên
      List<int> signal1 = signal1Controller.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();

      List<int> signal2 = signal2Controller.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();

      // Tính toán convolution
      setState(() {
        result = calculateConvolution(signal1, signal2);
      });
    } catch (e) {
      setState(() {
        result = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input. Please enter valid numbers separated by commas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header without icon
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'Convolution Calculator',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueAccent,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Convolution calculation explanation
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'The sequence y(n) is equal to the convolution of sequences x(n) and h(n):',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Math.tex(
                        r'y(n) = x(n) * h(n) = \sum_{k=-\infty}^{\infty} x(k)\, h(n-k)',
                        textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'For finite sequences x(n) with M values and h(n) with H values:',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Math.tex(
                        r'y(n) = \sum_{k=0}^{N} x(n+k)\, h(N-1-k)\quad\text{for } N = 0\,..\,M+H-2',
                        textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              // Input fields with icons
              _buildInputField(
                controller: signal1Controller,
                hintText: 'Enter Signal 1 (e.g., 1, 2, 3)',
                icon: Icons.timeline_rounded,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: signal2Controller,
                hintText: 'Enter Signal 2 (e.g., 4, 5, 6)',
                icon: Icons.multiline_chart_rounded,
              ),

              const SizedBox(height: 32),

              // Calculate button with icon
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: handleCalculate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  label: const Text(
                    'Calculate Convolution',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Result display with icon
              if (result.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.08),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            'Result',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        result.join(', '),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build a styled input field with icon
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 17),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.lightBlueAccent),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 15, color: Colors.black38),
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 22.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}