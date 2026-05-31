import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../utils/custom_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _role = 'farmer';
  String _gender = 'male';
  String? _dob;

  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();
  final _farmNameCtrl = TextEditingController();
  final _regNoCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _altPhoneCtrl.dispose();
    _farmNameCtrl.dispose();
    _regNoCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = "${picked.year}-${picked.month}-${picked.day}";
        _dobCtrl.text = _dob!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final genderOptions = ['male', 'female', 'other'];

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registered successfully')),
          );
          Navigator.pop(context);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            /// Background image
            Image.asset(
              "assets/images/bg.jpg", // replace with your image path
              fit: BoxFit.cover,
            ),

            /// Shadow overlay
            Container(
              color: Colors.black.withValues(alpha: 0.4),
            ),

            /// Foreground content
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(6),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Icon(Icons.chevron_left, color: Colors.white,))
                    ),

                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            /// Role Dropdown
                            DropdownButtonFormField<String>(
                              value: _role,
                              decoration: const InputDecoration(labelText: "Role"),
                              items: const [
                                DropdownMenuItem(value: "farmer", child: Text("Farmer")),
                                DropdownMenuItem(value: "customer", child: Text("Customer")),
                              ],
                              onChanged: (val) => setState(() => _role = val!),
                            ),
                            const SizedBox(height: 12),

                            /// Username & Password Row
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: _usernameCtrl,
                                    label: "Username",
                                    validator: (v) => v!.isEmpty ? "Required" : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _passwordCtrl,
                                    label: "Password",
                                    obscureText: true,
                                    validator: (v) => v!.isEmpty ? "Required" : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            CustomTextField(controller: _nameCtrl, label: "Name"),
                            const SizedBox(height: 12),
                            CustomTextField(controller: _addressCtrl, label: "Address"),
                            const SizedBox(height: 12),

                            /// Phone & Alt Phone
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: _phoneCtrl,
                                    label: "Phone No",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _altPhoneCtrl,
                                    label: "Alt Phone No",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            /// DOB Picker
                            TextFormField(
                              controller: _dobCtrl,
                              readOnly: true,
                              onTap: _pickDOB,
                              validator: (v) => v!.isEmpty ? "DOB required" : null,
                              decoration: const InputDecoration(
                                labelText: "Date of Birth",
                                suffixIcon: Icon(Icons.calendar_today, color: Colors.green),
                              ),
                            ),
                            const SizedBox(height: 12),

                            /// Gender Chips
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 8,
                                children: genderOptions.map((g) {
                                  final selected = _gender == g;
                                  return ChoiceChip(
                                    label: Text(g),
                                    labelStyle: TextStyle(
                                      color: selected ? Colors.white : Colors.black54,
                                    ),
                                    selected: selected,
                                    selectedColor: Colors.green,
                                    onSelected: (_) {
                                      setState(() => _gender = g);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            /// Farmer-specific fields
                            if (_role == "farmer") ...[
                              CustomTextField(controller: _farmNameCtrl, label: "Farm Name"),
                              const SizedBox(height: 12),
                              CustomTextField(
                                controller: _regNoCtrl,
                                label: "Farmer Registration No",
                              ),
                              const SizedBox(height: 12),
                            ],

                            /// Register Button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return CustomButton(
                                  text: "Register",
                                  isLoading: state is AuthLoading,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final userData = {
                                        "username": _usernameCtrl.text,
                                        "password": _passwordCtrl.text,
                                        "role": _role,
                                        "name": _nameCtrl.text,
                                        "address": _addressCtrl.text,
                                        "phone_no": _phoneCtrl.text,
                                        "alt_contact_no": _altPhoneCtrl.text,
                                        "gender": _gender,
                                        "dob": _dob,
                                        if (_role == "farmer") ...{
                                          "farm_name": _farmNameCtrl.text,
                                          "farmer_registration_no": _regNoCtrl.text,
                                        }
                                      };

                                      context.read<AuthBloc>().add(RegisterEvent(userDate: userData));
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
