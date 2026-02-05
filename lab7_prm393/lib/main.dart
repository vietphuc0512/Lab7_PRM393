import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 7 - Signup',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Focus nodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  bool _isCheckingEmail = false;
  bool _hidePassword = true;

  // ===== Validators =====

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ===== Submit Logic =====

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCheckingEmail = true);

    // Fake async API call
    await Future.delayed(const Duration(seconds: 2));

    if (_emailController.text.startsWith('taken')) {
      setState(() => _isCheckingEmail = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This email is already taken')),
      );
      return;
    }

    setState(() => _isCheckingEmail = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signup successful 🎉')),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                // Full Name
                TextFormField(
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) => _validateRequired(v, 'Full name'),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocus),
                ),


                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                ),

                const SizedBox(height: 12),

                // Password
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _hidePassword = !_hidePassword),
                    ),
                  ),
                  validator: _validatePassword,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_confirmFocus),
                ),

                const SizedBox(height: 12),

                // Confirm Password
                TextFormField(
                  focusNode: _confirmFocus,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.done,
                  decoration:
                  const InputDecoration(labelText: 'Confirm Password'),
                  validator: _validateConfirmPassword,
                  onFieldSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isCheckingEmail ? null : _submit,
                    child: _isCheckingEmail
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Create Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
