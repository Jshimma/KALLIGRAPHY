import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
      final api = InquiryApiService();

      await api.submitInquiry(
        name: _nameController.text,
        email: _emailController.text,
        service: _service,
        preferredDate: _dateController.text,
        location: _locationController.text,
        message: _messageController.text,
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
      padding: const EdgeInsets.fromLTRB(28, 110, 28, 70),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BOOK / INQUIRE',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Let’s create something\nworth remembering.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.espresso,
                  fontSize: 72,
                  height: .92,
                ),
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 610),
                child: Text(
                  'Tell me a little about what you are planning. '
                  'I’ll get back to you and we can talk through the details together.',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppColors.muted, height: 1.75),
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
              final wide = constraints.maxWidth > 820;

              final form = Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Eyebrow('01 / YOUR DETAILS', color: AppColors.sand),
                    const SizedBox(height: 34),
                    Text(
                      'Tell Ryan about\nyour plans.',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: AppColors.ivory,
                            fontSize: 56,
                            height: .96,
                          ),
                    ),
                    const SizedBox(height: 42),
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
                              validator: _required,
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _OvalField(
                        controller: dateController,
                        label: 'EVENT DATE',
                        hint: 'DD / MM / YYYY',
                      ),
                      const SizedBox(height: 14),
                      _OvalField(
                        controller: locationController,
                        label: 'LOCATION',
                        validator: _required,
                      ),
                    ],
                    const SizedBox(height: 14),
                    _MessageField(
                      controller: messageController,
                      validator: _required,
                    ),
                    const SizedBox(height: 28),
                    _SubmitButton(submitting: submitting, onPressed: onSubmit),
                  ],
                ),
              );

              if (!wide) {
                return form;
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: form),
                  const SizedBox(width: 90),
                  const Expanded(child: _FormAside()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  static String? _email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }

    if (!value.contains('@')) {
      return 'Enter a valid email';
    }

    return null;
  }
}

class _FormAside extends StatelessWidget {
  const _FormAside();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(
              'assets/images/ryan/Wedding3.jpg',
              height: 460,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 26),
          Text(
            'PHOTOGRAPHY · VIDEOGRAPHY · GRAPHICS DESIGN',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.sand,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Every story deserves to be documented with intention.',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: AppColors.ivory, height: 1.35),
          ),
        ],
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
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.espresso),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.ivory,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        hintStyle: const TextStyle(color: AppColors.beige),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
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
          borderSide: const BorderSide(color: AppColors.mocha, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.error),
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
      dropdownColor: AppColors.ivory,
      style: const TextStyle(color: AppColors.espresso),
      decoration: InputDecoration(
        labelText: 'WHAT ARE YOU BOOKING?',
        filled: true,
        fillColor: AppColors.ivory,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
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
          borderSide: const BorderSide(color: AppColors.mocha, width: 1.5),
        ),
      ),
      items: [
        for (final item in items)
          DropdownMenuItem(value: item, child: Text(item)),
      ],
    );
  }
}

class _MessageField extends StatelessWidget {
  const _MessageField({required this.controller, required this.validator});

  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 6,
      maxLines: 8,
      validator: validator,
      style: const TextStyle(color: AppColors.espresso),
      decoration: InputDecoration(
        labelText: 'TELL RYAN ABOUT YOUR PLANS',
        alignLabelWithHint: true,
        filled: true,
        fillColor: AppColors.ivory,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        contentPadding: const EdgeInsets.fromLTRB(25, 22, 25, 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.mocha, width: 1.5),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.submitting, required this.onPressed});

  final bool submitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: submitting ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ivory,
          foregroundColor: AppColors.espresso,
          disabledBackgroundColor: AppColors.beige,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 34),
        ),
        child: submitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.espresso,
                ),
              )
            : Text(
                'SEND INQUIRY',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.espresso,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }
}

class _SuccessSection extends StatelessWidget {
  const _SuccessSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkBrown,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 130),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.sand,
              size: 54,
            ),
            const SizedBox(height: 28),
            Text(
              'Thank you.',
              style: Theme.of(context).textTheme.displayMedium
                  ?.copyWith(color: AppColors.ivory, fontSize: 58),
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Text(
                'Your inquiry has been received. Ryan will be in touch soon to talk through the details.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.sand, height: 1.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingFooter extends StatelessWidget {
  const _BookingFooter();

  Future<void> _open(String value) async {
    final uri = Uri.parse(value);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---------------------------------------------------------------
        // DIRECT CONTACT — BURNT ORANGE
        // ---------------------------------------------------------------
        Container(
          width: double.infinity,
          color: AppColors.mocha,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 88),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 760;

                  return Flex(
                    direction: compact ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: compact
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OR REACH RYAN DIRECTLY',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: AppColors.cream,
                                    letterSpacing: 2.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Prefer a direct\nconversation?',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: AppColors.ivory,
                                    height: 0.95,
                                  ),
                            ),
                            const SizedBox(height: 18),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 470),
                              child: Text(
                                'If you already know what you need, you can reach Ryan directly and start the conversation from there.',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.cream.withValues(
                                        alpha: 0.88,
                                      ),
                                      height: 1.7,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: compact ? 0 : 48,
                        height: compact ? 40 : 0,
                      ),
                      Flexible(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _ContactButton(
                              label: 'EMAIL',
                              icon: Icons.mail_outline_rounded,
                              onTap: () =>
                                  _open('mailto:kallygraphy01@gmail.com'),
                            ),
                            _ContactButton(
                              label: 'WHATSAPP',
                              icon: Icons.chat_bubble_outline_rounded,
                              onTap: () => _open('https://wa.me/256707266444'),
                            ),
                            _ContactButton(
                              label: 'CALL',
                              icon: Icons.phone_outlined,
                              onTap: () => _open('tel:+256787758821'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        // ---------------------------------------------------------------
        // ---------------------------------------------------------------
        // PRIVATE STUDIO — CREAM
        // ---------------------------------------------------------------
        Container(
          width: double.infinity,
          color: AppColors.cream,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 58),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 680;

                  return Flex(
                    direction: compact ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: compact
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RYAN’S PRIVATE WORKSPACE',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.brown,
                                  letterSpacing: 2.2,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Photographer Studio.',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: AppColors.espresso),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Private access for Ryan to manage inquiries, '
                            'galleries and studio work.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.muted, height: 1.5),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: compact ? 0 : 32,
                        height: compact ? 24 : 0,
                      ),
                      TextButton(
                        onPressed: () => context.go('/studio'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.espresso,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 8,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'STUDIO LOGIN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.8,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        // FOOTER — ESPRESSO
        // ---------------------------------------------------------------
        Container(
          width: double.infinity,
          color: AppColors.espresso,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KALLYGRAPHY',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.cream,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'KALIISA RYAN',
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: AppColors.sand, letterSpacing: 1.8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.cream,
        side: BorderSide(color: AppColors.cream.withValues(alpha: 0.65)),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
        shape: const StadiumBorder(),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: color ?? AppColors.muted,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
    );
  }
}
