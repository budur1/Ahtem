import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AddMedicationScreen extends StatefulWidget {
  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<AddMedicationScreen> {
  String? selectedFrequency;
  List<bool> isSelected = List.generate(7, (index) => false);
  List<bool> isIntervalSelected = List.generate(1000, (index) => false);
  String selectedDays = '';
  String selectedDaysText = '';
  int medicationCount = 0;
  bool isMedicationAdded = false;

  void toggleDay(int index) {
    setState(() {
      isSelected[index] = !isSelected[index];
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
      if (isSelected[i]) {
        selectedDays += 'SMTWTFS'[i];
      }
    }
    updateSelectedDaysText();
  }

  void updateSelectedDaysText() {
    List<String> selectedDaysList = [];
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
        case 'T':
          selectedDaysList.add('Thu');
          break;
        case 'F':
          selectedDaysList.add('Fri');
          break;
        case 'S':
          selectedDaysList.add('Sat');
          break;
      }
    }

    setState(() {
      selectedDaysText = selectedDaysList.join(' and ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFFD12E34),
                        fontSize: 14,
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
                  const SizedBox(height: 8.0),
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
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      width: 332,
                      height: 46,
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
                        value: selectedFrequency,
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
                            selectedFrequency = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Choose Days',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      width: 332,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    borderRadius: BorderRadius.circular(18),
                                    color: isSelected[i]
                                        ? const Color(0xFF83CFC9)
                                        : const Color.fromARGB(
                                            255, 236, 236, 236),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'SMTWTFS'.substring(i, i + 1),
                                      style: TextStyle(
                                        color: isSelected[i]
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
                  const SizedBox(height: 8.0),
                  if (selectedDaysText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        selectedDaysText,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8.0),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      width: 332,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(1000, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  toggleInterval(index);
                                });
                              },
                              child: Container(
                                width: 332,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: isIntervalSelected[index]
                                      ? const Color(0xFF83CFC9)
                                      : Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: isIntervalSelected[index]
                                        ? Colors.white
                                        : const Color.fromARGB(102, 0, 0, 0),
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
                  const SizedBox(height: 8.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Start Date',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: IconButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                              },
                              icon: const Icon(Icons.calendar_today),
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (medicationCount > 0) {
                                        medicationCount--;
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
                                    medicationCount.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      medicationCount++;
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
                        ],
                      ),
                    ),
                  ),
                  const Spacer(), // Add Spacer to push the "Continue" option to the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        // Add functionality for delete button
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(64.98, 0, 0, 0),
                        width: 250,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          color: const Color.fromARGB(255, 224, 76, 125),
                        ),
                        child: const Center(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 35.0,
            right: 24.0,
            child: GestureDetector(
              onTap: () {
                if (!isMedicationAdded) {
                  setState(() {
                    isMedicationAdded = true;
                  });
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.bottomSlide,
                    title: 'Thanks!!',
                    desc: 'your Medication is added successfully.',
                    btnOkText: 'Continue',
                    btnOkOnPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMedicationScreen()),
                      );
                    },
                  ).show();
                }
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Color(0xFF1E91C6),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
