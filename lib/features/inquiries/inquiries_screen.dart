import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../services/api/photographer_inquiry_api_service.dart';
import '../../services/auth/auth_session.dart';
import '../../shared/models/inquiry.dart';

class InquiriesScreen extends StatefulWidget {
  const InquiriesScreen({required this.session, super.key});

  final AuthSession session;

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  final _api = const PhotographerInquiryApiService();

  List<Inquiry> _inquiries = const [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInquiries();
  }

  Future<void> _loadInquiries() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final inquiries = await _api.fetchInquiries(
        accessToken: widget.session.accessToken,
      );

      if (!mounted) return;

      setState(() {
        _inquiries = inquiries;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  int get _newCount =>
      _inquiries.where((inquiry) => inquiry.status == 'new').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.brown,
          onRefresh: _loadInquiries,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.xl,
                    AppSpacing.screenHorizontal,
                    AppSpacing.lg,
                  ),
                  child: _Header(
                    newCount: _newCount,
                    onRefresh: _loadInquiries,
                  ),
                ),
              ),
              if (_isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.brown),
                  ),
                )
              else if (_error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorState(message: _error!, onRetry: _loadInquiries),
                )
              else if (_inquiries.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    0,
                    AppSpacing.screenHorizontal,
                    AppSpacing.xxxl,
                  ),
                  sliver: SliverList.separated(
                    itemCount: _inquiries.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      return _InquiryCard(
                        inquiry: _inquiries[index],
                        onTap: () => _openInquiry(_inquiries[index]),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openInquiry(Inquiry inquiry) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _InquiryDetailsDialog(
        inquiry: inquiry,
        session: widget.session,
        api: _api,
        onUpdated: (updated) {
          setState(() {
            _inquiries = _inquiries
                .map((item) => item.id == updated.id ? updated : item)
                .toList();
          });
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.newCount, required this.onRefresh});

  final int newCount;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'INQUIRIES',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.muted,
                  letterSpacing: 2.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Client conversations.',
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(color: AppColors.espresso),
              ),
            ],
          ),
        ),
        if (newCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.espresso,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$newCount NEW',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.cream,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        const SizedBox(width: AppSpacing.sm),
        IconButton(
          onPressed: onRefresh,
          tooltip: 'Refresh inquiries',
          icon: const Icon(Icons.refresh_rounded),
          color: AppColors.brown,
        ),
      ],
    );
  }
}

class _InquiryCard extends StatelessWidget {
  const _InquiryCard({required this.inquiry, required this.onTap});

  final Inquiry inquiry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNew = inquiry.status == 'new';

    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.sand,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _initials(inquiry.name),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.espresso,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inquiry.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.espresso,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      inquiry.service,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _summary(inquiry),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _StatusPill(status: inquiry.status, isNew: isNew),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _summary(Inquiry inquiry) {
    final parts = <String>[];

    if (inquiry.preferredDate?.isNotEmpty == true) {
      parts.add(inquiry.preferredDate!);
    }

    if (inquiry.location?.isNotEmpty == true) {
      parts.add(inquiry.location!);
    }

    return parts.isEmpty ? inquiry.email : parts.join(' · ');
  }

  String _initials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return '?';

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.isNew});

  final String status;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isNew ? AppColors.espresso : AppColors.beige,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isNew ? AppColors.cream : AppColors.espresso,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _InquiryDetailsDialog extends StatefulWidget {
  const _InquiryDetailsDialog({
    required this.inquiry,
    required this.session,
    required this.api,
    required this.onUpdated,
  });

  final Inquiry inquiry;
  final AuthSession session;
  final PhotographerInquiryApiService api;
  final ValueChanged<Inquiry> onUpdated;

  @override
  State<_InquiryDetailsDialog> createState() => _InquiryDetailsDialogState();
}

class _InquiryDetailsDialogState extends State<_InquiryDetailsDialog> {
  late String _status;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _status = widget.inquiry.status;
  }

  @override
  Widget build(BuildContext context) {
    final inquiry = widget.inquiry;

    return AlertDialog(
      backgroundColor: AppColors.ivory,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Expanded(
            child: Text(
              inquiry.name,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: AppColors.espresso),
            ),
          ),
          _StatusPill(status: _status, isNew: _status == 'new'),
        ],
      ),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: 'SERVICE', value: inquiry.service),
              if (inquiry.preferredDate?.isNotEmpty == true)
                _DetailRow(
                  label: 'PREFERRED DATE',
                  value: inquiry.preferredDate!,
                ),
              if (inquiry.location?.isNotEmpty == true)
                _DetailRow(label: 'LOCATION', value: inquiry.location!),
              _DetailRow(label: 'EMAIL', value: inquiry.email),
              if (inquiry.message?.isNotEmpty == true)
                _DetailRow(label: 'MESSAGE', value: inquiry.message!),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'STATUS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.muted,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.cream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'new', child: Text('New')),
                  DropdownMenuItem(
                    value: 'contacted',
                    child: Text('Contacted'),
                  ),
                  DropdownMenuItem(
                    value: 'confirmed',
                    child: Text('Confirmed'),
                  ),
                  DropdownMenuItem(value: 'closed', child: Text('Closed')),
                ],
                onChanged: _isUpdating
                    ? null
                    : (value) {
                        if (value != null) {
                          _updateStatus(value);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        ),
        if (inquiry.email.isNotEmpty)
          TextButton.icon(
            onPressed: _emailClient,
            icon: const Icon(Icons.mail_outline_rounded),
            label: const Text('EMAIL'),
          ),
      ],
    );
  }

  Future<void> _updateStatus(String status) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final updated = await widget.api.updateStatus(
        inquiryId: widget.inquiry.id,
        status: status,
        accessToken: widget.session.accessToken,
      );

      if (!mounted) return;

      setState(() {
        _status = updated.status;
        _isUpdating = false;
      });

      widget.onUpdated(updated);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update inquiry: $error')),
      );
    }
  }

  Future<void> _emailClient() async {
    final uri = Uri(
      scheme: 'mailto',
      path: widget.inquiry.email,
      queryParameters: {
        'subject': 'KALLYGRAPHY — ${widget.inquiry.service} inquiry',
      },
    );

    await launchUrl(uri);
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.muted,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.espresso, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mail_outline_rounded,
              size: 42,
              color: AppColors.mocha,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No inquiries yet.',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: AppColors.espresso),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'New client conversations will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Could not load inquiries.',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: AppColors.espresso),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.espresso,
                foregroundColor: AppColors.cream,
              ),
              child: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
