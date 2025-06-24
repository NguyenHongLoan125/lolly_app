import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddDishScreen extends StatefulWidget {
  const AddDishScreen({super.key});

  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  @override
  Widget build(BuildContext context) {
  return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                'Công thức nấu ăn',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff007400),
                  fontWeight: FontWeight.bold
                ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xffECF5E3),
            leading: IconButton(
                onPressed: (){
                  context.go('/main');
                },
                icon: const Icon(Icons.arrow_back,color:Color(0xff007400),size: 50,)
            ),
          ),

          body: SingleChildScrollView(
            child: Container(
              color: Color(0xffECF5E3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      width: 152,
                      height: 126,
                      decoration: BoxDecoration(
                        color: Color(0xffDCEDD7),
                        borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(),
                  const SizedBox(height: 20,),
                  Row(),
                  const SizedBox(height: 20,),
                  Row(),
                  const SizedBox(height: 20,),
                  Row(),
                  const SizedBox(height: 20,),
                  Row(),
                  const SizedBox(height: 20,),
                  Row(),
                  const SizedBox(height: 20,),
                  Row(),
                  const SizedBox(height: 20,),
                  Row(),
                  const SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        )
    );
  }
}

