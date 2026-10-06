import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api/inquiry_api_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _messageController = TextEditingController();

  String _service = 'WEDDINGS';
  bool _submitting = false;
  bool _submitted = false;

  final _services = const [
    'WEDDINGS',
    'INTRODUCTIONS',
    'BABY SHOWERS',
    'GRADUATIONS',
    'PHOTOSHOOTS',
    'MOMENTS',
    'VIDEOGRAPHY',
    'GRAPHICS DESIGN',
    'OTHER',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      await InquiryApiService().submitInquiry(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        service: _service,
        preferredDate: _dateController.text.trim(),
        location: _locationController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _submitting = false;
        _submitted = true;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _submitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _BookingHero(),
            _submitted
                ? const _SuccessSection()
                : _InquirySection(
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    dateController: _dateController,
                    locationController: _locationController,
                    messageController: _messageController,
                    service: _service,
                    services: _services,
                    submitting: _submitting,
                    onServiceChanged: (value) {
                      if (value == null) return;
                      setState(() => _service = value);
                    },
                    onSubmit: _submit,
                  ),
            const _BookingFooter(),
          ],
        ),
      ),
    );
  }
}

class _BookingHero extends StatelessWidget {
  const _BookingHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 105, 28, 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 850;

              final title = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KALLYGRAPHY STUDIO',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'BOOK YOUR\nMOMENT.',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.espresso,
                      fontSize: wide ? 82 : 58,
                      height: .88,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      'Every story begins with a conversation. '
                      'Tell KALLYGRAPHY STUDIO what you are planning, '
                      'and let’s create photographs that feel like memory.',
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: AppColors.muted, height: 1.75),
                    ),
                  ),
                ],
              );

              final mark = Container(
                width: wide ? 210 : double.infinity,
                height: wide ? 210 : 170,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.mocha,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '01',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.ivory,
                        fontSize: 48,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'START HERE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.ivory,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [title, const SizedBox(height: 35), mark],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 70),
                  mark,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InquirySection extends StatelessWidget {
  const _InquirySection({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.dateController,
    required this.locationController,
    required this.messageController,
    required this.service,
    required this.services,
    required this.submitting,
    required this.onServiceChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController dateController;
  final TextEditingController locationController;
  final TextEditingController messageController;
  final String service;
  final List<String> services;
  final bool submitting;
  final ValueChanged<String?> onServiceChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkBrown,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 90),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 900;

              final form = Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Eyebrow('01 / YOUR DETAILS', color: AppColors.sand),
                    const SizedBox(height: 30),
                    Text(
                      'Tell KALLYGRAPHY\nabout your plans.',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: AppColors.ivory,
                            fontSize: wide ? 58 : 45,
                            height: .94,
                          ),
                    ),
                    const SizedBox(height: 40),
                    _OvalField(
                      controller: nameController,
                      label: 'YOUR NAME',
                      validator: _required,
                    ),
                    const SizedBox(height: 14),
                    _OvalField(
                      controller: emailController,
                      label: 'EMAIL ADDRESS',
                      keyboardType: TextInputType.emailAddress,
                      validator: _email,
                    ),
                    const SizedBox(height: 14),
                    _OvalDropdown(
                      value: service,
                      items: services,
                      onChanged: onServiceChanged,
                    ),
                    const SizedBox(height: 14),
                    if (wide)
                      Row(
                        children: [
                          Expanded(
                            child: _OvalField(
                              controller: dateController,
                              label: 'EVENT DATE',
                              hint: 'DD / MM / YYYY',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _OvalField(
                              controller: locationController,
                              label: 'LOCATION',
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _OvalField(
                            controller: dateController,
                            label: 'EVENT DATE',
                            hint: 'DD / MM / YYYY',
                          ),
                          const SizedBox(height: 14),
                          _OvalField(
                            controller: locationController,
                            label: 'LOCATION',
                          ),
                        ],
                      ),
                    const SizedBox(height: 14),
                    _OvalField(
                      controller: messageController,
                      label: 'TELL US ABOUT IT',
                      maxLines: 5,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 58,
                      child: FilledButton(
                        onPressed: submitting ? null : onSubmit,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.mocha,
                          foregroundColor: AppColors.ivory,
                          disabledBackgroundColor: AppColors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.ivory,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SEND INQUIRY',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Icon(Icons.arrow_forward_rounded),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              );

              final qr = const _BookingQr();

              if (!wide) {
                return Column(children: [form, const SizedBox(height: 70), qr]);
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: form),
                  const SizedBox(width: 80),
                  const Expanded(flex: 4, child: _BookingQr()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BookingQr extends StatelessWidget {
  const _BookingQr();

  @override
  Widget build(BuildContext context) {
    const contactData = '''
BEGIN:VCARD
VERSION:3.0
FN:KALLYGRAPHY STUDIO
ORG:KALLYGRAPHY STUDIO
TEL;TYPE=CELL:+256787758821
TEL;TYPE=WORK:+256707266444
EMAIL:kallygraph01@gmail.com
END:VCARD
''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('02 / QUICK BOOKING', color: AppColors.sand),
        const SizedBox(height: 30),
        Text(
          'Scan.\nBook.\nBegin.',
          style: Theme.of(context).textTheme.displayMedium
              ?.copyWith(color: AppColors.ivory, fontSize: 50, height: .96),
        ),
        const SizedBox(height: 24),
        Text(
          'Save KALLYGRAPHY STUDIO to your phone. '
          'Scan this code to get our WhatsApp, phone and email details.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.sand, height: 1.7),
        ),
        const SizedBox(height: 30),
        Container(
          width: 230,
          height: 230,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.ivory,
            borderRadius: BorderRadius.circular(26),
          ),
          child: QrImageView(
            data: contactData,
            version: QrVersions.auto,
            backgroundColor: AppColors.ivory,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.espresso,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.espresso,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'KALLYGRAPHY STUDIO',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.ivory,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _SuccessSection extends StatelessWidget {
  const _SuccessSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.mocha,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              const Text(
                'THANK YOU.',
                style: TextStyle(
                  color: AppColors.ivory,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Your story is\nnow in motion.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.ivory,
                  fontSize: 56,
                  height: .9,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Your inquiry has been received by KALLYGRAPHY STUDIO. '
                'We’ll be in touch soon to talk through the details.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.cream, height: 1.7),
              ),
              const SizedBox(height: 38),
              FilledButton(
                onPressed: () => context.go('/portfolio'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.ivory,
                  foregroundColor: AppColors.espresso,
                  minimumSize: const Size(190, 56),
                ),
                child: const Text('VIEW THE WORK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingFooter extends StatelessWidget {
  const _BookingFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 65, 28, 45),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KALLYGRAPHY STUDIO',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.espresso,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'PHOTOGRAPHY · VIDEOGRAPHY · GRAPHICS DESIGN',
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.muted, letterSpacing: 1.5),
              ),
              const SizedBox(height: 35),
              OutlinedButton.icon(
                onPressed: () => context.go('/studio'),
                icon: const Icon(Icons.lock_outline_rounded, size: 18),
                label: const Text(
                  'KALLYGRAPHY STUDIO LOGIN',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.espresso,
                  side: const BorderSide(color: AppColors.espresso, width: 1.2),
                  minimumSize: const Size(250, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Divider(color: AppColors.border),
              const SizedBox(height: 22),
              Text(
                'KAMPALA · UGANDA · WORLDWIDE',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: AppColors.muted, letterSpacing: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.5,
      ),
    );
  }
}

class _OvalField extends StatelessWidget {
  const _OvalField({
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.espresso, fontFamily: 'Manrope'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: AppColors.ivory,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        hintStyle: const TextStyle(
          color: AppColors.beige,
          fontFamily: 'Manrope',
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: maxLines > 1 ? 20 : 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 999),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 999),
          borderSide: const BorderSide(color: AppColors.mocha, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 999),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 999),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}

class _OvalDropdown extends StatelessWidget {
  const _OvalDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      style: const TextStyle(
        color: AppColors.espresso,
        fontFamily: 'Manrope',
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: 'WHAT ARE WE CREATING?',
        filled: true,
        fillColor: AppColors.ivory,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.mocha, width: 2),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
    );
  }
}

String? _required(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }
  return null;
}

String? _email(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }

  if (!value.contains('@') || !value.contains('.')) {
    return 'Enter a valid email';
  }

  return null;
}
