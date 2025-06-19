import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007400)),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "Nguyễn Hồng Loan",
          style: const TextStyle(
            color: Color(0xFF007400),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        actions: [
          Image.asset('assets/logo.png', height: 70, width: 70),
        ],
        elevation: 0,
      ),

      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
              color: Colors.white,
            ),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text(
                  "Hiện chưa có thông tin",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
