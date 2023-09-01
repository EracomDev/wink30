// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';

class EmailScreen extends StatelessWidget {
  final int numberOfEmails; // Number of emails

  const EmailScreen({super.key, required this.numberOfEmails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Screen'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.email),
                onPressed: () {
                  // Perform settings action
                },
              ),
              Positioned(
                top: 0,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    numberOfEmails.toString(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Text('Email screen content'),
      ),
    );
  }
}
