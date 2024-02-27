import 'package:flutter/material.dart';

class BuildContainer extends StatelessWidget {
  const BuildContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Now public
Widget buildContainer(
    {required String imagePath, required String text, required Color color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14.0),
    child: Container(
      width: 129,
      height: 163.01,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.1),
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 100,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
