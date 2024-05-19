import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:medication_reminder_vscode/screen/home_screen.dart';

class AddNewMedScreen extends StatefulWidget {
  @override
  _AddNewMedScreen createState() => _AddNewMedScreen();
}

class _AddNewMedScreen extends State<AddNewMedScreen> {
  void saveMedicationDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        print('Authenticated User ID: ${user.uid}');

        String firestorePath = 'users/$userId/medications';
        print('Firestore Path: $firestorePath');

        CollectionReference medications = FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .collection("Medications");

        String medicationName = name.text; // Retrieve medication name

        await medications.add({
          'name': medicationName, // Pass medication name to Firestore
          'startDate':
              '${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}',
          'quantityInCabinet': quantityInCabinet,
          'preferredTimes': preferredTimes,
          'intervalDays': intervalDays,
          'dosage': dosage,
          'daysOfWeek': DaysOfweek,
          'scheduleType': seletedFrequency,
          'isTaken': false,
        });

        print('Medication details saved successfully');
      }
    } catch (e) {
      print('Error saving medication details: $e');
    }
  }

  String? seletedFrequency;
  List<bool> DaysOfweek = List.generate(7, (index) => false);
  List<bool> isIntervalSelected = List.generate(90, (index) => false);
  String selectedDays = '';
  String selectedDaysText = '';
  int quantityInCabinet = 0;
  bool isMedicationAdded = false;
  int? intervalDays;
  DateTime? selectedDate;
  TextEditingController name = TextEditingController();

  String preferredTimes = '';
  int dosage = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void toggleDay(int index) {
    setState(() {
      DaysOfweek[index] = !DaysOfweek[index];
      updateSelectedDays();
    });
  }

  void toggleInterval(int index) {
    setState(() {
      isIntervalSelected[index] = !isIntervalSelected[index];
    });
  }

  void updateSelectedDays() {
    selectedDays = '';
    for (int i = 0; i < 7; i++) {
      if (DaysOfweek[i]) {
        selectedDays += 'SMTWtFs'[i];
      }
    }
    updateSelectedDaysText();
  }

  void updateSelectedDaysText() {
    List<String> selectedDaysList = [];
    selectedDays.indexOf('S');
    selectedDays.lastIndexOf('s');
    selectedDays.indexOf('T');
    selectedDays.lastIndexOf('t');

    for (int i = 0; i < selectedDays.length; i++) {
      switch (selectedDays[i]) {
        case 'S':
          selectedDaysList.add('Sun');
          break;

        case 'M':
          selectedDaysList.add('Mon');
          break;
        case 'T':
          selectedDaysList.add('Tue');
          break;
        case 'W':
          selectedDaysList.add('Wed');

          break;

        case 't':
          selectedDaysList.add('Thu');
          break;
        case 'F':
          selectedDaysList.add('Fri');
          break;

        case 's':
          selectedDaysList.add('Sat');
      }
    }

    setState(() {
      selectedDaysText = selectedDaysList.join(' and ');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Add New Medication',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.pink,
            child: const Center(
              child: Text(
                'Your content goes here',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 360,
                height: 670,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E9EA),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/homepage');
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE04C7D),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                              ),
                              const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 8.0),
                        child: Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, top: 8),
                          width: 332,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                TextField(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  controller: name,
                                  decoration: InputDecoration(
                                    hintText: 'name of Medication',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 8.0),
                        child: Text(
                          'How often do you want to take it?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                          width: 332,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              border: InputBorder.none,
                            ),
                            value: seletedFrequency,
                            items: <String>[
                              'At Regular Intervals',
                              'On Specific Days of the week',
                              'As Needed',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                seletedFrequency = value!;
                                if (seletedFrequency ==
                                    'On Specific Days of the week') {
                                  isIntervalSelected =
                                      List.generate(90, (index) => false);
                                } else if (seletedFrequency ==
                                    'At Regular Intervals') ;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      if (seletedFrequency != 'At Regular Intervals')
                        Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Choose Days',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Container(
                                width: 332,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (int i = 0; i < 7; i++)
                                        GestureDetector(
                                          onTap: () {
                                            toggleDay(i);
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: DaysOfweek[i]
                                                  ? const Color(0xFF83CFC9)
                                                  : const Color.fromARGB(
                                                      255, 236, 236, 236),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'SMTWtFs'.substring(i, i + 1),
                                                style: TextStyle(
                                                  color: DaysOfweek[i]
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            if (selectedDaysText.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  selectedDaysText,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 143, 143, 143),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 3.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 332,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        preferredTimes = 'Morning';
                                      });
                                    },
                                    child: Text(
                                      'Morning',
                                      style: TextStyle(
                                        color: preferredTimes == 'Morning'
                                            ? const Color.fromARGB(
                                                255, 123, 56, 162)
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        preferredTimes = 'Afternoon';
                                      });
                                    },
                                    child: Text(
                                      'Afternoon',
                                      style: TextStyle(
                                        color: preferredTimes == 'Afternoon'
                                            ? const Color.fromARGB(
                                                255, 123, 56, 162)
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        preferredTimes = 'Evening';
                                      });
                                    },
                                    child: Text(
                                      'Evening',
                                      style: TextStyle(
                                        color: preferredTimes == 'Evening'
                                            ? const Color.fromARGB(
                                                255, 123, 56, 162)
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      if (seletedFrequency != 'On Specific Days of the week')
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Choose Interval [Days]',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8.0),
                      if (seletedFrequency != 'On Specific Days of the week')
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            width: 332,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(90, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        toggleInterval(index);
                                        intervalDays = index + 1;

                                        print(intervalDays);
                                      });
                                    },
                                    child: Container(
                                      width: 332,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: intervalDays == index + 1
                                            ? const Color(0xFF83CFC9)
                                            : Colors.transparent,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(
                                          color: intervalDays == index + 1
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  102, 0, 0, 0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                          width: 332,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  '${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: IconButton(
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                          width: 332,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Medication Cabinet',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (quantityInCabinet > 0) {
                                            quantityInCabinet--;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: Colors.blue,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 65,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.grey[300],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        quantityInCabinet.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantityInCabinet++;
                                        });
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: Colors.blue,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                          width: 332,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                'How many times do you\n take it a day ?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (dosage > 0) {
                                          dosage--;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.blue,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 65,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.grey[300],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      dosage.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        dosage++;
                                      });
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.blue,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      )
                    ]),
              ),
            ),
          ),
          Positioned(
            top: 35.0,
            right: 35.0,
            child: GestureDetector(
              onTap: () {
                if (!isMedicationAdded &&
                    quantityInCabinet != 0 &&
                    ((seletedFrequency == 'At Regular Intervals') ||
                        (seletedFrequency == 'On Specific Days of the week' &&
                            selectedDaysText.isNotEmpty)) &&
                    preferredTimes.isNotEmpty) {
                  setState(() {
                    isMedicationAdded = true;
                  });
                  saveMedicationDetails();
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.bottomSlide,
                    title: 'Thanks!!',
                    desc: 'Your medication is added successfully.',
                    btnOkText: 'Continue',
                    btnOkOnPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ).show();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE04C7D),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
