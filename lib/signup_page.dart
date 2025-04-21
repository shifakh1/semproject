import 'package:flutter/material.dart';
import 'login_page.dart';

String? savedUsername;
String? savedPassword;
String? savedEmail;
String? savedPhone;
String? savedCountry;
String? savedDob;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String? selectedCountry;
  final List<String> countries = [
    'Select Country',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Pakistan',
    'India',
    'China',
    'Japan'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _validateAndSignUp(BuildContext context) {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedCountry == null ||
        dobController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (!emailController.text.contains('@') || !emailController.text.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email")),
      );
      return;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    if (phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    if (selectedCountry == 'Select Country') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a country")),
      );
      return;
    }

    // Save all data
    savedUsername = usernameController.text;
    savedPassword = passwordController.text;
    savedEmail = emailController.text;
    savedPhone = phoneController.text;
    savedCountry = selectedCountry;
    savedDob = dobController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Account Created Successfully")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Image.asset("assets/ac_logo.png", height: 130),
              SizedBox(height: 10),
              Text(
                "WE KNOW OUR WAY AROUND!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),

              // Username Field
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Email Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password (min 6 characters)",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Phone Number Field
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Country Dropdown
              DropdownButtonFormField<String>(
                value: selectedCountry,
                decoration: InputDecoration(
                  labelText: "Country",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                items: countries.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCountry = newValue;
                  });
                },
              ),
              SizedBox(height: 15),

              // Date of Birth Field
              TextField(
                controller: dobController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 30),

              // SIGN UP Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  elevation: 5,
                ),
                onPressed: () => _validateAndSignUp(context),
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}