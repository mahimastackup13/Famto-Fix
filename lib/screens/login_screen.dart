import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:famto_mini_booking/core/app_config.dart';
import 'package:famto_mini_booking/core/router.dart';
import 'package:famto_mini_booking/core/validators.dart';
import 'package:famto_mini_booking/widgets/responsive_center.dart';

const _teal = Color(0xFF14C9D0);
const _tealDark = Color(0xFF2F5F61);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _referralController = TextEditingController();
  bool _showReferral = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _goHome() => Navigator.of(context).pushReplacementNamed(AppRoutes.home);

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900)); // mock login
    if (!mounted) return;
    _goHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8F8F8), Color(0xFF9FE9EC), Color(0xFF00CFD5)],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
          child: SafeArea(
            child: ResponsiveCenter(
              maxWidth: 480,
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _header(),
                          _form(),
                          _footer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A0B3A3A),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/images/categories/famlogo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 36),
          const Text(
            'Welcome to',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: _teal),
          ),
          const SizedBox(height: 4),
          const Text(
            AppConfig.appName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: _teal,
                height: 1.1),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    _IndiaFlag(),
                    SizedBox(width: 10),
                    Text('+91',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.phone,
                  onFieldSubmitted: (_) => _continue(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    counterText: '',
                    errorStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _linkButton(
            _showReferral ? 'Hide referral code' : 'Have a referral code ?',
            () => setState(() => _showReferral = !_showReferral),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: _showReferral
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextField(
                      controller: _referralController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Enter referral code',
                        prefixIcon: Icon(Icons.card_giftcard_outlined),
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Divider(color: _teal, thickness: 1)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('OR',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: _tealDark)),
              ),
              const Expanded(child: Divider(color: _teal, thickness: 1)),
            ],
          ),
          const SizedBox(height: 12),
          _linkButton('Login as Guest', _isLoading ? null : _goHome),
        ],
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 28),
      child: Column(
        children: [
          const Text(
            'By signing up, you agree to our Terms & Privacy Policy',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: _tealDark),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
              backgroundColor: const Color(0xFFF8F8F8),
              foregroundColor: Colors.black,
              disabledBackgroundColor: const Color(0xFFF8F8F8),
              elevation: 6,
              shadowColor: Colors.black26,
              shape: const StadiumBorder(),
            ),
            onPressed: _isLoading ? null : _continue,
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: _teal),
                  )
                : const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _linkButton(String label, VoidCallback? onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
}

class _IndiaFlag extends StatelessWidget {
  const _IndiaFlag();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        width: 28,
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Expanded(child: Container(color: const Color(0xFFFF9933))),
                Expanded(child: Container(color: Colors.white)),
                Expanded(child: Container(color: const Color(0xFF138808))),
              ],
            ),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF000080), width: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
