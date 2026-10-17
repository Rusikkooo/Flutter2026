import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
    home: const SignUpScreen(),
  );
}

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthCtrl = TextEditingController();

  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm, _birthCtrl]) {
      c.dispose();
    }
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2006, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (d == null || !mounted) return;
    setState(() {
      _birth = d;
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      _birthCtrl.text = '$day.$month.${d.year}';
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _done = true);
    }
  }

  void _startOver() {
    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();
      _birthCtrl.clear();
      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
    });
  }

  Widget _buildForm() => Form(
    key: _formKey,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Name'),
          textInputAction: TextInputAction.next,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          onFieldSubmitted: (_) => _emailFocus.requestFocus(),
          validator: (v) =>
              (v ?? '').trim().length < 2 ? 'Name is too short' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _email,
          focusNode: _emailFocus,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'name@kbtu.kz',
          ),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textInputAction: TextInputAction.next,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          validator: (v) {
            final text = v ?? '';
            final at = text.indexOf('@');
            if (at == -1 || !text.substring(at).contains('.')) {
              return 'Email looks wrong';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _password,
          decoration: const InputDecoration(
            labelText: 'Password',
            helperText: 'At least 8 characters',
          ),
          obscureText: true,
          textInputAction: TextInputAction.next,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          validator: (v) =>
              (v ?? '').length < 8 ? 'Password is too short' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _confirm,
          decoration: const InputDecoration(labelText: 'Confirm password'),
          obscureText: true,
          textInputAction: TextInputAction.done,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          onFieldSubmitted: (_) => _submit(),
          validator: (v) =>
              v != _password.text ? 'Passwords do not match' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _group,
          decoration: const InputDecoration(labelText: 'Group'),
          items: [
            for (final g in groups) DropdownMenuItem(value: g, child: Text(g)),
          ],
          onChanged: (g) => setState(() => _group = g),
          validator: (g) => g == null ? 'Choose a group' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _birthCtrl,
          readOnly: true,
          onTap: _pickDate,
          decoration: const InputDecoration(
            labelText: 'Date of birth',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          validator: (_) => _birth == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('I agree to the rules'),
          value: _agreed,
          onChanged: (v) => setState(() => _agreed = v ?? false),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _agreed ? _submit : null,
          child: const Text('Sign up'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sign up')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _done
          ? Column(
              children: [
                SummaryCard(
                  name: _name.text,
                  email: _email.text,
                  group: _group,
                  birth: _birth,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _startOver,
                  child: const Text('Start over'),
                ),
              ],
            )
          : _buildForm(),
    ),
  );
}
