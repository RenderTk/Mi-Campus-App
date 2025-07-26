import 'package:flutter/material.dart';
import 'package:usap_mobile/utils/email_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _globalKey = GlobalKey<FormState>();

  Widget _buildEmailTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        validator: (value) => EmailValidator.validateInstitutional(
          value,
          allowedDomains: ["usap.edu"],
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Correo institucional",
        ),
      ),
    );
  }

  Widget _buildPasswordTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Contraseña",
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_globalKey.currentState!.validate()) {}
          },
          child: const Text("Iniciar sesión"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              Image.asset("assets/usap_logo_big.png"),
              const SizedBox(height: 30),
              Text(
                "¡Bienvenido a USAP móvil!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 35),
              _buildEmailTextFormField(),
              const SizedBox(height: 50),
              _buildPasswordTextFormField(),
              const SizedBox(height: 30),
              _buildLoginButton(),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {},
                child: const Text("¿Olvidaste tu contraseña?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
