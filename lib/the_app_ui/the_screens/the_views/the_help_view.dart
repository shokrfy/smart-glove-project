import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HelpScreen extends StatefulWidget {
  static const String theRouteName = 'help';

  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _sending = false;

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);

    const serviceId = 'service_5mdv0qb';
    const templateId = 'template_cjco797';
    const publicKey = '5h80DcOGSv6swQ6nR';
    const privateKey = 'yOcUECYEEB24x1krINKf-';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final body = {
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': publicKey,
      'private_key': privateKey,
      'template_params': {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'message': _messageCtrl.text.trim(),
      },
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (mounted) {
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your message sent successfully')),
          );
          _nameCtrl.clear();
          _emailCtrl.clear();
          _messageCtrl.clear();
        } else {
          throw Exception(res.body);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * .05),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * .02),
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: w * .06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: h * .02),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Name is required'
                              : null,
                ),
                SizedBox(height: h * .02),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Your Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                    return emailRegex.hasMatch(v.trim())
                        ? null
                        : 'Enter a valid email';
                  },
                ),
                SizedBox(height: h * .02),
                TextFormField(
                  controller: _messageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Your Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Message can\'t be empty'
                              : null,
                ),
                SizedBox(height: h * .02),
                SizedBox(
                  width: double.infinity,
                  height: h * .06,
                  child: ElevatedButton(
                    onPressed: _sending ? null : _sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child:
                        _sending
                            ? const CircularProgressIndicator()
                            : const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ),
                SizedBox(height: h * .05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
