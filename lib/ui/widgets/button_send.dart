import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ButtonSend extends StatefulWidget {
  const ButtonSend({Key? key}) : super(key: key);

  @override
  State<ButtonSend> createState() => _ButtonSendState();
}

class _ButtonSendState extends State<ButtonSend> {
  bool isButtonActive = false;
  late TextEditingController controller;
  late Timer _timer;
  int _start = 60;

  void _listenOtp() async {
    SmsAutoFill().listenForCode;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isButtonActive = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(() {
      if (_start == 0) {
        final isButtonActive = controller.text.isNotEmpty;
        setState(() => this.isButtonActive = isButtonActive);
      }
    });
    startTimer();
    super.initState();
    _listenOtp();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        autofocus: true,
        style: ElevatedButton.styleFrom(
          onSurface: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: isButtonActive
            ? () async {
                final signCode = await SmsAutoFill().getAppSignature;
                print(signCode);
                startTimer();
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Отправить еще раз'),
            const SizedBox(
              width: 20,
            ),
            Text('$_start' ' c'),
          ],
        ),
      ),
    );
  }
}
