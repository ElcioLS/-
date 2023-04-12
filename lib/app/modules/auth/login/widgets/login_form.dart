part of '../login_page.dart';

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final loginEC = TextEditingController();
    final passwordEC = TextEditingController();
    final controller = Modular.get<LoginController>();

    @override
    void dispose() {
      loginEC.dispose();
      passwordEC.dispose();
      super.dispose();
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          CuidapetTextFormField(
            label: 'Login',
            controller: loginEC,
            validator: Validatorless.multiple([
              Validatorless.required('Login obrigatório'),
              Validatorless.email('E-mail inválido'),
            ]),
          ),
          const SizedBox(height: 20),
          CuidapetTextFormField(
            label: 'Senha',
            obscureText: true,
            controller: passwordEC,
            validator: Validatorless.multiple([
              Validatorless.required('Senha obgrigatória'),
              Validatorless.min(5, 'A senha deve conter ao menos 6 caracteres')
            ]),
          ),
          const SizedBox(height: 20),
          CuidapetDefaultButton(
              label: 'Entrar',
              onPressed: () async {
                final formValid = formKey.currentState?.validate() ?? false;
                if (formValid) {
                  await controller.login(loginEC.text, passwordEC.text);
                }
              })
        ],
      ),
    );
  }
}
