import 'package:adf_cuidapet/app/core/ui/extensions/size_screen_extension.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/cuidapet_text_form_field.dart';
import 'package:adf_cuidapet/app/modules/auth/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:validatorless/validatorless.dart';

part 'widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar usuário'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 162.w,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),
            const _RegisterForm(),
          ],
        ),
      )),
    );
  }
}
