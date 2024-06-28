import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:uas_ambw/hive.dart';

class InputPin extends StatefulWidget {
  const InputPin({super.key, required this.isEditing});
  final bool isEditing;

  @override
  State<InputPin> createState() => _InputPinState();
}

class _InputPinState extends State<InputPin> {
  final bool isPinSet = pinBox.length > 0;
  bool isEditing = false;
  bool ableToEditPin = false;

  @override
  void initState() {
    isEditing = widget.isEditing;
    super.initState();
  }

  bool matchPin(String value) {
    return Crypt(pinBox.get('pin')).match(value);
  }

  void showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Center(
          child: Text(
            "Invalid PIN",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController pinController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: isEditing
          ? AppBar(
              backgroundColor: Colors.transparent,
              leading: TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              leadingWidth: 80,
            )
          : null,
      body: Center(
        heightFactor: isEditing ? 0.8 : 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isEditing)
              const Text("Edit PIN", style: TextStyle(fontSize: 24)),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Text(
                isEditing && ableToEditPin || !isPinSet
                    ? "Create new PIN to secure your notes"
                    : isEditing
                        ? "Input current PIN"
                        : "Input PIN to unlock your notes",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Pinput(
              length: 4,
              textInputAction: TextInputAction.done,
              obscureText: true,
              closeKeyboardWhenCompleted: true,
              controller: pinController,
              onCompleted: (value) {
                if (isEditing && !ableToEditPin) {
                  if (matchPin(value)) {
                    setState(() {
                      ableToEditPin = true;
                    });
                  } else {
                    showErrorSnackbar();
                    pinController.text = '';
                  }
                } else if (isEditing && ableToEditPin) {
                  pinBox.put('pin', Crypt.sha256(value).toString());
                  Navigator.pushReplacementNamed(context, '/home');
                } else if (isPinSet) {
                  if (matchPin(value)) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    showErrorSnackbar();
                    pinController.text = '';
                  }
                } else {
                  pinBox.put('pin', Crypt.sha256(value).toString());
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              defaultPinTheme: PinTheme(
                padding: EdgeInsets.all(8),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade700),
                ),
              ),
              focusedPinTheme: PinTheme(
                padding: EdgeInsets.all(8),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
              ),
              submittedPinTheme: PinTheme(
                padding: EdgeInsets.all(8),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
