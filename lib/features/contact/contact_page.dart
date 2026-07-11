import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/fade_in_widget.dart';
import '../../core/widgets/section_heading.dart';
import '../../services/contact_service.dart';
import '../../services/url_service.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  EnquiryType _enquiryType = EnquiryType.general;
  bool _privacyAccepted = false;
  bool _isSubmitting = false;
  bool _submitted = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_privacyAccepted) {
      setState(() =>
          _errorMessage = 'Please accept the privacy acknowledgement to continue.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final service = ref.read(contactServiceProvider);
      await service.submitEnquiry(ContactFormData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        enquiryType: _enquiryType,
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      ));
      if (mounted) setState(() => _submitted = true);
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage =
            'Something went wrong. Please try again or email us directly.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.darkNavy, AppColors.flutterBlue],
            ),
          ),
          child: ContentContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? AppSpacing.xxl : AppSpacing.xxxl,
              ),
              child: const SectionHeading(
                eyebrow: 'CONTACT',
                title: 'Get in touch',
                subtitle:
                    'Have a question, talk proposal, or sponsorship enquiry? We\'d love to hear from you.',
                light: true,
              ),
            ),
          ),
        ),
        Container(
          color: AppColors.offWhite,
          child: ContentContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
              ),
              child: isMobile
                  ? _MobileLayout(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      subjectController: _subjectController,
                      messageController: _messageController,
                      enquiryType: _enquiryType,
                      privacyAccepted: _privacyAccepted,
                      isSubmitting: _isSubmitting,
                      submitted: _submitted,
                      errorMessage: _errorMessage,
                      onEnquiryTypeChanged: (t) =>
                          setState(() => _enquiryType = t!),
                      onPrivacyChanged: (v) =>
                          setState(() => _privacyAccepted = v ?? false),
                      onSubmit: _submit,
                    )
                  : _DesktopLayout(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      subjectController: _subjectController,
                      messageController: _messageController,
                      enquiryType: _enquiryType,
                      privacyAccepted: _privacyAccepted,
                      isSubmitting: _isSubmitting,
                      submitted: _submitted,
                      errorMessage: _errorMessage,
                      onEnquiryTypeChanged: (t) =>
                          setState(() => _enquiryType = t!),
                      onPrivacyChanged: (v) =>
                          setState(() => _privacyAccepted = v ?? false),
                      onSubmit: _submit,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.subjectController,
    required this.messageController,
    required this.enquiryType,
    required this.privacyAccepted,
    required this.isSubmitting,
    required this.submitted,
    required this.errorMessage,
    required this.onEnquiryTypeChanged,
    required this.onPrivacyChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final EnquiryType enquiryType;
  final bool privacyAccepted;
  final bool isSubmitting;
  final bool submitted;
  final String? errorMessage;
  final ValueChanged<EnquiryType?> onEnquiryTypeChanged;
  final ValueChanged<bool?> onPrivacyChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _ContactForm(
            formKey: formKey,
            nameController: nameController,
            emailController: emailController,
            subjectController: subjectController,
            messageController: messageController,
            enquiryType: enquiryType,
            privacyAccepted: privacyAccepted,
            isSubmitting: isSubmitting,
            submitted: submitted,
            errorMessage: errorMessage,
            onEnquiryTypeChanged: onEnquiryTypeChanged,
            onPrivacyChanged: onPrivacyChanged,
            onSubmit: onSubmit,
          ),
        ),
        const SizedBox(width: AppSpacing.xxl),
        Expanded(
          flex: 2,
          child: _ContactSidebar(),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.subjectController,
    required this.messageController,
    required this.enquiryType,
    required this.privacyAccepted,
    required this.isSubmitting,
    required this.submitted,
    required this.errorMessage,
    required this.onEnquiryTypeChanged,
    required this.onPrivacyChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final EnquiryType enquiryType;
  final bool privacyAccepted;
  final bool isSubmitting;
  final bool submitted;
  final String? errorMessage;
  final ValueChanged<EnquiryType?> onEnquiryTypeChanged;
  final ValueChanged<bool?> onPrivacyChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactForm(
          formKey: formKey,
          nameController: nameController,
          emailController: emailController,
          subjectController: subjectController,
          messageController: messageController,
          enquiryType: enquiryType,
          privacyAccepted: privacyAccepted,
          isSubmitting: isSubmitting,
          submitted: submitted,
          errorMessage: errorMessage,
          onEnquiryTypeChanged: onEnquiryTypeChanged,
          onPrivacyChanged: onPrivacyChanged,
          onSubmit: onSubmit,
        ),
        const SizedBox(height: AppSpacing.xxl),
        _ContactSidebar(),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  const _ContactForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.subjectController,
    required this.messageController,
    required this.enquiryType,
    required this.privacyAccepted,
    required this.isSubmitting,
    required this.submitted,
    required this.errorMessage,
    required this.onEnquiryTypeChanged,
    required this.onPrivacyChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final EnquiryType enquiryType;
  final bool privacyAccepted;
  final bool isSubmitting;
  final bool submitted;
  final String? errorMessage;
  final ValueChanged<EnquiryType?> onEnquiryTypeChanged;
  final ValueChanged<bool?> onPrivacyChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (submitted) {
      return FadeInWidget(
        key: const Key('contact-success'),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withAlpha(16),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.successGreen.withAlpha(60)),
          ),
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: AppColors.successGreen, size: 56),
              const SizedBox(height: AppSpacing.md),
              Text('Message sent!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.darkNavy, fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Thank you for your message. We will get back to you as soon as possible.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send a message',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full name *'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Please enter your name' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email address *'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[\w\-.+]+@[\w-]+\.[a-z]{2,}$')
                    .hasMatch(v.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<EnquiryType>(
              initialValue: enquiryType,
              decoration: const InputDecoration(labelText: 'Enquiry type *'),
              items: EnquiryType.values
                  .map((t) => DropdownMenuItem(
                      value: t, child: Text(_enquiryLabel(t))))
                  .toList(),
              onChanged: onEnquiryTypeChanged,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject *'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Please enter a subject' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: messageController,
              decoration: const InputDecoration(
                  labelText: 'Message *',
                  alignLabelWithHint: true),
              maxLines: 6,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your message';
                if (v.trim().length < 10) {
                  return 'Message must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: privacyAccepted,
                  onChanged: onPrivacyChanged,
                  activeColor: AppColors.flutterBlue,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'I agree that my details will be used to respond to my enquiry. '
                      'I have read and accept the Flutter Birmingham Privacy Notice.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(errorMessage!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.errorRed)),
            ],
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _enquiryLabel(EnquiryType type) {
    switch (type) {
      case EnquiryType.general:
        return 'General enquiry';
      case EnquiryType.speaker:
        return 'Speaker enquiry';
      case EnquiryType.sponsorship:
        return 'Sponsorship enquiry';
      case EnquiryType.volunteer:
        return 'Volunteer enquiry';
    }
  }
}

class _ContactSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInWidget(
          key: const Key('contact-sidebar-general'),
          child: _ContactCategory(
            icon: Icons.email_outlined,
            title: 'General enquiries',
            description: 'For general questions about Flutter Birmingham.',
            actionLabel: 'Email us',
            onTap: () => UrlService.openEmail(AppStrings.contactEmail),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FadeInWidget(
          key: const Key('contact-sidebar-speaker'),
          child: _ContactCategory(
            icon: Icons.mic_none_outlined,
            title: 'Speak at our events',
            description: 'Interested in giving a talk at Flutter Birmingham?',
            actionLabel: 'Submit a talk',
            onTap: () => UrlService.open(AppStrings.speakerFormUrl),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FadeInWidget(
          key: const Key('contact-sidebar-sponsor'),
          child: _ContactCategory(
            icon: Icons.handshake_outlined,
            title: 'Sponsorship',
            description: 'Help support the Flutter Birmingham community.',
            actionLabel: 'Sponsorship enquiry',
            onTap: () => UrlService.openEmail(AppStrings.contactEmail,
                subject: 'Sponsorship enquiry'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FadeInWidget(
          key: const Key('contact-sidebar-volunteer'),
          child: _ContactCategory(
            icon: Icons.volunteer_activism_outlined,
            title: 'Volunteer',
            description: 'Help us run better events and grow the community.',
            actionLabel: 'Get involved',
            onTap: () => UrlService.openEmail(AppStrings.contactEmail,
                subject: 'Volunteer enquiry'),
          ),
        ),
      ],
    );
  }
}

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.flutterBlue.withAlpha(16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.flutterBlue, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text(description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.xs),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    actionLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.flutterBlue,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.flutterBlue.withAlpha(120)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
