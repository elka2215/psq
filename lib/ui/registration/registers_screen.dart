import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:psq/ui/registration/bloc/event_bloc.dart';
import 'package:psq/ui/registration/bloc/state_bloc.dart';
import 'package:psq/ui/registration/screens/sms_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'bloc/bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, required this.internet}) : super(key: key);
  final bool internet;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final maskFormatter = MaskTextInputFormatter(mask: '+7 ### ###-##-##');
  final formKey = GlobalKey<FormState>();
  bool isButtonActive = false;
  String? number;
  late TextEditingController controller;

  void _listenOtp() async {
    SmsAutoFill().listenForCode;
  }

  @override
  void initState() {
    _listenOtp();
    controller = TextEditingController();
    controller.addListener(() {
      if (controller.text.length == 16) {
        final isButtonActive = controller.text.isNotEmpty;
        setState(() => this.isButtonActive = isButtonActive);
      }
    });

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
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
            if (state is InitialAuthState) {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  'Connection Status: ${_connectionStatus
                                      .toString()}'),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Номер телефона',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                style: const TextStyle(fontSize: 35),
                                autofocus: true,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: '+7 000 000-00-00',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: 35),
                                ),
                                controller: controller,
                                inputFormatters: [maskFormatter],
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null) return 'Проверьте номер';
                                  if (value.length < 16) {
                                    return 'Проверьте номер';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  number = value;
                                      () {
                                    context.read<AuthBloc>().add(
                                        NumberAuthEvent(number: value));
                                  };//??????????????????????????????????????????
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('На него мы вам отправим СМС с кодом'),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                    child: const Text('Отправить код'),
                                    autofocus: false,
                                    style: ElevatedButton.styleFrom(
                                      onSurface: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: isButtonActive
                                        ? () async {
                                      final isValidated =
                                          formKey.currentState?.validate() ??
                                              false;
                                      if (isValidated) {
                                        FocusScope.of(context).unfocus();
                                        formKey.currentState?.save();
                                        if (number?.length == 16) {
                                          final signCode =
                                          await SmsAutoFill().getAppSignature;
                                          print(signCode);
                                          context.read<AuthBloc>().add(NumberAuthEvent(number: number ?? ''));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SmsScreen(
                                                    number: controller.text,
                                                  ),
                                            ),
                                          );
                                        } else {
                                          Container();
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialog(
                                                  title:
                                                  const Text(
                                                      'Попробуйте снова'),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          'Закрыть'),
                                                    )
                                                  ],
                                                ),
                                          );
                                        }
                                      }
                                    }
                                        : null),
                              ),
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
