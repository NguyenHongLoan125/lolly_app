import 'package:flutter/material.dart';

class AddLogo extends StatelessWidget {
  const AddLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset('assets/logo.png', height: 50, width: 50,),
          const SizedBox(height: 20,),
          const Text(
            'Nấu ăn cùng bạn',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white
          ),)
          
        ],
      ),
    );
  }
}
