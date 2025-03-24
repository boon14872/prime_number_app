import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prime_number_app/models/prime_response.dart';
import 'package:prime_number_app/repositories/prime_number_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrimeNumberRepository _primeNumberRepository = PrimeNumberRepository();

  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();

  bool _islLoading = false;
  PrimeResponse? _result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Prime Number Calculator',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(top: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade300,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orangeAccent),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'กรอกตัวเลขเพื่อตรวจสอบว่าเป็นจำนวนเฉพาะหรือไม่ โดยสามารถตรวจสอบได้เฉพาะตัวเลขได้ถึง 18 หลักเท่านั้น',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    maxLength: 18,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกตัวเลข';
                      }
                      if (int.tryParse(value) == null) {
                        return 'กรุณากรอกตัวเลขเท่านั้น';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'กรอกตัวเลข',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _result = null;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _islLoading = true;
                        });
                        final number = int.parse(_numberController.text);
                        await _primeNumberRepository.isPrime(number).then((
                          value,
                        ) {
                          setState(() {
                            _result = value;
                            _islLoading = false;
                          });
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      _islLoading ? 'กำลังคำนวณ...' : 'ตรวจสอบ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  if (_result != null)
                    Column(
                      children: [
                        SizedBox(height: 16),
                        Container(height: 1, color: Colors.black),
                        SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  _result?.isPrime == true
                                      ? Colors.green.shade300
                                      : Colors.red.shade300,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orangeAccent),
                            ),
                            child: Text(
                              'ผลลัพธ์',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8),
                        Text(
                          'ตัวเลข: ${_result?.number ?? ''}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'เป็นจำนวนเฉพาะ: ${_result?.isPrime ?? false}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'เวลาที่ใช้: ${(_result?.executionTimeMicroseconds ?? 0) / 1000} มิลลิวินาที',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
