import 'package:myapp/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/provider/transaction_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // นำเข้าจำเป็นสำหรับการใช้งาน File

class FormScreen extends StatelessWidget {
  FormScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final brandController = TextEditingController(); //ชื่อรุ่น
  final priceController = TextEditingController(); //ราคา

  String iconController = "assets/img/icon_question.png"; //เริ่มต้นเป็น ?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('กรอกแบบฟอร์มข้อมูล'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'ชื่อแบรนด์',
                    ),
                    autofocus: true,
                    controller: brandController,
                    validator: (String? str) {
                      if (str!.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                    },
                  ),
                  DropdownButtonFormField(
                      value: mobileIcon.ques,
                      decoration: const InputDecoration(
                        labelText: 'ระบบปฏิบัติการ',
                      ),
                      items: mobileIcon.values.map((key) {
                        return DropdownMenuItem(
                            value: key, child: Text(key.title));
                      }).toList(),
                      onChanged: (value) {
                        iconController = value!.imagePath.toString();
                      }),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'ราคาเปิดตัว',
                    ),
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    validator: (String? input) {
                      try {
                        double amount = double.parse(input!);
                        if (amount < 0) {
                          return 'กรุณากรอกข้อมูลมากกว่า 0';
                        }
                      } catch (e) {
                        return 'กรุณากรอกข้อมูลเป็นตัวเลข';
                      }
                    },
                  ),
                  TextButton(
                      child: const Text('บันทึก'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // create transaction data object

                          var statement = Transactions(
                            brand: brandController.text,
                            price: double.parse(priceController.text),
                            date: DateTime.now(),
                            imagePath: iconController.isNotEmpty
                                ? iconController
                                : 'assets/img/icon_question.png',
                          );

                          // add transaction data object to provider
                          var provider = Provider.of<TransactionProvider>(
                              context,
                              listen: false);

                          provider.addTransaction(statement);

                          Navigator.pop(context);
                        }
                      })
                ],
              )),
        ));
  }
}
