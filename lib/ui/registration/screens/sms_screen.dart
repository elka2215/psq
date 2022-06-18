import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psq/ui/registration/bloc/bloc.dart';
import 'package:psq/ui/registration/bloc/state_bloc.dart';
import 'package:psq/ui/registration/screens/user_name.dart';
import 'package:psq/ui/widgets/button_send.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SmsScreen extends StatefulWidget {
  const SmsScreen({Key? key, required this.number}) : super(key: key);
  final String number;

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  String? code;
  bool isButtonActive = false;
  late TextEditingController controller;

  void _listenOtp() async {
    SmsAutoFill().listenForCode;
  }

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
    _listenOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state){
          if (state is EmptyAuthState) {
            return const Center(
              child: Text('empty'),
            );
          }
          if (state is LoadingAuthState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is InitialAuthState){
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                           Text(
                            'Код из смс ' '${state.userModel?.data.code}',
                            style:
                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            child: PinFieldAutoFill(
                              autoFocus: true,
                              codeLength: 6,
                              onCodeChanged: (val) {
                                if (val == state.userModel?.data.code) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UserName(),
                                    ),
                                  );
                                }
                                print('val = ' '$val');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Отправили на ' + widget.number),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Expanded(
                            child: ButtonSend(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }
      ),
    );
  }
}
