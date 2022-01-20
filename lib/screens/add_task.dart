import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytask')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timeStamp': time,
    });
    Fluttertoast.showToast(msg: 'Data Added');
    titleController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Enter title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Enter description'),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  addTaskToFirebase();
                },
                child: Text(
                  'Add task',
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
