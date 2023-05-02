import 'package:flutter/material.dart';
import 'package:flutter_curso_07_products_app/src/providers/login_form_provider.dart';
import 'package:flutter_curso_07_products_app/src/services/authentication_service.dart';
import 'package:flutter_curso_07_products_app/src/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_curso_07_products_app/src/ui/input_decoration.dart';
import 'package:flutter_curso_07_products_app/src/widgets/widgets.dart';

class SingUpScreen extends StatelessWidget {

  const SingUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250,),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium
                    ),
                    const SizedBox(height: 30,),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50,),
              TextButton(
                style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.blue),
                  shape: MaterialStatePropertyAll(StadiumBorder()),
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                child: const Text('Do you have an Account?', style: TextStyle(fontSize: 18),),
              ),
            ],
          ),
        )
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {

  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Form (
      key: loginFormProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [

          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.loginInputDecoration(
              hint: 'john.doe@email.com',
              label: 'Email Address',
              icon: Icons.alternate_email,
              color: Colors.blue
            ),
            onChanged: (value) => loginFormProvider.email = value,
            validator: (value) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value ?? '') ? null : 'Invalid email address',
          ),

          const SizedBox(height: 30,),

          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecorations.loginInputDecoration(
                hint: 'Password',
                label: '**********',
                icon: Icons.lock_outline,
                color: Colors.blue
            ),
            onChanged: (value) => loginFormProvider.password = value,
            validator: (value) => RegExp(r"^[a-zA-Z0-9#$%&*]{6}")
                .hasMatch(value ?? '') ? null : 'Invalid password, min length 6 chars',
          ),

          const SizedBox(height: 30,),

          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
            disabledColor: Colors.grey,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15,),
            onPressed: !loginFormProvider.isLoading ? () async {

              FocusScope.of(context).unfocus();
              final authService = Provider.of<AuthenticationService>(context, listen: false);

              if (!loginFormProvider.isValidForm()) return;

              loginFormProvider.isLoading = true;

              final String? errorMessage = await authService.createUser(loginFormProvider.email, loginFormProvider.password);

              if (errorMessage == null) {
                Navigator.pushReplacementNamed(context, 'home');
              }else {
                NotificationsService.showSnackBar(errorMessage);
                loginFormProvider.isLoading = false;
              }
            } : null,
            child: Text(
              loginFormProvider.isLoading ?
              'Loading...' :
              'Sign Up',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          )

        ],
      ),
    );
  }
}
