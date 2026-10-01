import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../services/api/inquiry_api_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const _phone = '+256787758821';
  static const _email = 'kallygraph01@gmail.com';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _messageController = TextEditingController();

  String _service = 'Wedding';
  bool _isSending = false;
  bool _inquirySent = false;
  String? _inquiryError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendInquiry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
      _inquirySent = false;
      _inquiryError = null;
    });

    try {
      await InquiryApiService().submitInquiry(
        name: _nameController.text,
        email: _emailController.text,
        service: _service,
        preferredDate: _dateController.text,
        location: _locationController.text,
        message: _messageController.text,
      );

      if (!mounted) return;

      setState(() {
        _isSending = false;
        _inquirySent = true;
        _inquiryError = null;
      });

      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _dateController.clear();
      _locationController.clear();
      _messageController.clear();
      _service = 'Wedding';
    } on InquiryApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
        _inquirySent = false;
        _inquiryError = error.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
        _inquirySent = false;
        _inquiryError =
            'Something went wrong. Please try again or contact us directly.';
      });
    }
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/256707266444?text=${Uri.encodeComponent('Hello KALLYGRAPHY, I would like to make an inquiry.')}',
    );

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _call() async {
    final uri = Uri.parse('tel:$_phone');
    await launchUrl(uri);
  }

  Future<void> _openEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {'subject': 'Photography Inquiry — KALLYGRAPHY'},
    );

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _BookingHero(),
            _InquirySection(
              formKey: _formKey,
              service: _service,
              isSending: _isSending,
              inquirySent: _inquirySent,
              inquiryError: _inquiryError,
              nameController: _nameController,
              emailController: _emailController,
              dateController: _dateController,
              locationController: _locationController,
              messageController: _messageController,
              onServiceChanged: (value) {
                if (value != null) {
                  setState(() => _service = value);
                }
              },
              onSubmit: _sendInquiry,
            ),
            _ContactSection(
              onWhatsApp: _openWhatsApp,
              onCall: _call,
              onEmail: _openEmail,
            ),
            const _QrSection(),
            const _BookingClosing(),
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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        170,
        AppSpacing.screenHorizontal,
        110,
      ),
      color: AppColors.espresso,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '06 / BOOK',
                style: TextStyle(
                  color: AppColors.beige,
                  fontFamily: 'Manrope',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Let’s create\nsomething memorable.',
                style: TextStyle(
                  color: AppColors.cream,
                  fontFamily: 'CormorantGaramond',
                  fontSize: 72,
                  height: .96,
                ),
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: const Text(
                  'Tell us a little about your story, and we’ll take it from there.',
                  style: TextStyle(
                    color: AppColors.sand,
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    height: 1.8,
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

class _InquirySection extends StatelessWidget {
  const _InquirySection({
    required this.formKey,
    required this.service,
    required this.isSending,
    required this.inquirySent,
    required this.inquiryError,
    required this.nameController,
    required this.emailController,
    required this.dateController,
    required this.locationController,
    required this.messageController,
    required this.onServiceChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final String service;
  final bool isSending;
  final bool inquirySent;
  final String? inquiryError;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController dateController;
  final TextEditingController locationController;
  final TextEditingController messageController;

  final ValueChanged<String?> onServiceChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.ivory,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: 110,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 800;

              final form = Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '01 / YOUR STORY',
                      style: TextStyle(
                        color: AppColors.brown,
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tell us what you’re\nplanning.',
                      style: TextStyle(
                        color: AppColors.espresso,
                        fontFamily: 'CormorantGaramond',
                        fontSize: 52,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 45),
                    _Field(
                      label: 'YOUR NAME',
                      controller: nameController,
                      hint: 'Full name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _Field(
                      label: 'EMAIL',
                      controller: emailController,
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email.';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _Field(
                      label: 'SERVICE',
                      child: DropdownButtonFormField<String>(
                        initialValue: service,
                        decoration: _inputDecoration('Select a service'),
                        items:
                            const [
                                  'Wedding',
                                  'Baby Shower',
                                  'Birthday',
                                  'Photoshoot',
                                  'Couples',
                                  'Graduation',
                                  'Event',
                                  'Corporate / Brand',
                                  'Other',
                                ]
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                        onChanged: onServiceChanged,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (wide)
                      Row(
                        children: [
                          Expanded(
                            child: _Field(
                              label: 'DATE',
                              controller: dateController,
                              hint: 'Preferred date',
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _Field(
                              label: 'LOCATION',
                              controller: locationController,
                              hint: 'Where will it happen?',
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _Field(
                        label: 'DATE',
                        controller: dateController,
                        hint: 'Preferred date',
                      ),
                      const SizedBox(height: 24),
                      _Field(
                        label: 'LOCATION',
                        controller: locationController,
                        hint: 'Where will it happen?',
                      ),
                    ],
                    const SizedBox(height: 24),
                    _Field(
                      label: 'MESSAGE',
                      controller: messageController,
                      hint: 'Tell us a little about your plans...',
                      maxLines: 6,
                    ),
                    const SizedBox(height: 30),
                    if (inquiryError != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 26,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'INQUIRY NOT SENT',
                                    style: TextStyle(
                                      color: AppColors.espresso,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    inquiryError!,
                                    style: const TextStyle(
                                      color: AppColors.brown,
                                      fontFamily: 'Manrope',
                                      fontSize: 13,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (inquirySent) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.sand,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.beige),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: AppColors.brown,
                              size: 26,
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INQUIRY SENT',
                                    style: TextStyle(
                                      color: AppColors.espresso,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    'Thank you. We have received your inquiry and will be in touch shortly.',
                                    style: TextStyle(
                                      color: AppColors.brown,
                                      fontFamily: 'Manrope',
                                      fontSize: 13,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSending ? null : onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.espresso,
                          foregroundColor: AppColors.cream,
                          disabledBackgroundColor: AppColors.muted,
                          minimumSize: const Size.fromHeight(62),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isSending
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.cream,
                                ),
                              )
                            : const Text(
                                'SEND INQUIRY  →',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 1.6,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );

              final side = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GOOD PHOTOGRAPHS\nSTART WITH A\nGOOD CONVERSATION.',
                    style: TextStyle(
                      color: AppColors.espresso,
                      fontFamily: 'CormorantGaramond',
                      fontSize: 42,
                      height: 1.02,
                    ),
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Whether it is a wedding, intimate portrait session, celebration, or brand story, tell us what matters to you.',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      height: 1.8,
                    ),
                  ),
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [form, const SizedBox(height: 80), side],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: form),
                  const SizedBox(width: 100),
                  Expanded(flex: 2, child: side),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.child,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.brown,
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 9),
        child ??
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              validator: validator,
              style: const TextStyle(
                color: AppColors.espresso,
                fontFamily: 'Manrope',
                fontSize: 14,
              ),
              decoration: _inputDecoration(hint ?? ''),
            ),
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: AppColors.muted,
      fontFamily: 'Manrope',
      fontSize: 13,
    ),
    filled: true,
    fillColor: AppColors.cream,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brown, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  );
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({
    required this.onWhatsApp,
    required this.onCall,
    required this.onEmail,
  });

  final VoidCallback onWhatsApp;
  final VoidCallback onCall;
  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.sand,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '02 / CONNECT DIRECTLY',
                style: TextStyle(
                  color: AppColors.brown,
                  fontFamily: 'Manrope',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Prefer a direct conversation?',
                style: TextStyle(
                  color: AppColors.espresso,
                  fontFamily: 'CormorantGaramond',
                  fontSize: 52,
                  height: 1,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Reach KALLYGRAPHY through any of the channels below.',
                style: TextStyle(
                  color: AppColors.brown,
                  fontFamily: 'Manrope',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 760;

                  final items = [
                    _ContactCard(
                      icon: Icons.chat_bubble_outline,
                      label: 'WHATSAPP',
                      value: '+256 707 266 444',
                      onTap: onWhatsApp,
                    ),
                    _ContactCard(
                      icon: Icons.phone_outlined,
                      label: 'CALL',
                      value: '+256 787 758 821',
                      onTap: onCall,
                    ),
                    _ContactCard(
                      icon: Icons.mail_outline,
                      label: 'EMAIL',
                      value: 'kallygraph01@gmail.com',
                      onTap: onEmail,
                    ),
                  ];

                  if (!wide) {
                    return Column(
                      children: items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: item,
                            ),
                          )
                          .toList(),
                    );
                  }

                  return Row(
                    children: items
                        .map(
                          (item) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: item,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.cream : AppColors.ivory,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: _hovered
                ? const [
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.espresso,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, color: AppColors.cream, size: 21),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: AppColors.brown,
                        fontFamily: 'Manrope',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.value,
                      style: const TextStyle(
                        color: AppColors.espresso,
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_outward, color: AppColors.brown, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrSection extends StatelessWidget {
  const _QrSection();

  static const _qrData = '''
BEGIN:VCARD
VERSION:3.0
FN:KALLYGRAPHY
ORG:KALLYGRAPHY Photography
EMAIL:kallygraph01@gmail.com
TEL;TYPE=CELL:+256787758821
TEL;TYPE=WORK:+256707266444
NOTE:WhatsApp: +256707266444
END:VCARD
''';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.espresso,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 700;

              final qr = Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.ivory,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: QrImageView(
                  data: _qrData,
                  version: QrVersions.auto,
                  size: 230,
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
              );

              final text = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '03 / SAVE OUR CONTACT',
                    style: TextStyle(
                      color: AppColors.beige,
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Scan.\nSave.\nConnect.',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontFamily: 'CormorantGaramond',
                      fontSize: 58,
                      height: .9,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Scan the QR code to save KALLYGRAPHY’s contact details directly to your phone.',
                    style: TextStyle(
                      color: AppColors.sand,
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      height: 1.8,
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    'WHATSAPP  +256 707 266 444\nCALL  +256 787 758 821\nEMAIL  kallygraph01@gmail.com',
                    style: TextStyle(
                      color: AppColors.beige,
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      height: 2,
                      letterSpacing: .7,
                    ),
                  ),
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [qr, const SizedBox(height: 50), text],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  qr,
                  const SizedBox(width: 80),
                  Expanded(child: text),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BookingClosing extends StatelessWidget {
  const _BookingClosing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        100,
        AppSpacing.screenHorizontal,
        130,
      ),
      child: const Center(
        child: Text(
          'YOUR STORY.\nBEAUTIFULLY FRAMED.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.espresso,
            fontFamily: 'CormorantGaramond',
            fontSize: 62,
            height: .95,
          ),
        ),
      ),
    );
  }
}
