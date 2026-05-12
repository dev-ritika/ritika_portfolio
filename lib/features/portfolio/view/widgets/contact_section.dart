import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'animated_section_wrapper.dart';
import 'section_background.dart';
import 'section_header.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _sending = false;
        _sent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final hPad = ResponsiveUtils.getHorizontalPadding(context);

    return SectionBackground(
      style: SectionBgStyle.accent,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: ResponsiveUtils.sectionVPadding(context),
        ),
        child: Column(
          children: [
            // Section header
            AnimatedSectionWrapper(
              delay: const Duration(milliseconds: 100),
              child: SectionHeader(
                label: '06. Contact',
                title: AppStrings.contactTitle,
                subtitle: AppStrings.contactSubtitle,
              ),
            ),
            const SizedBox(height: 60),

            // Content
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _buildContactInfo()),
        const SizedBox(width: 32),
        Expanded(flex: 6, child: _buildContactForm()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContactInfo(),
        const SizedBox(height: 40),
        _buildContactForm(),
      ],
    );
  }

  Widget _buildContactInfo() {
    return AnimatedSectionWrapper(
      delay: const Duration(milliseconds: 200),
      slideOffset: const Offset(-0.05, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's work together",
            style: GoogleFonts.sora(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "I'm currently open to exciting Flutter opportunities. Whether you have a project in mind, want to discuss architecture, or just want to say hi — my inbox is open!",
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 40),

          // Contact details
          _ContactDetailItem(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: AppStrings.email,
            onTap: () => _copyToClipboard(AppStrings.email),
          ),
          const SizedBox(height: 16),
          _ContactDetailItem(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: AppStrings.phone,
            onTap: () => _copyToClipboard(AppStrings.phone),
          ),
          const SizedBox(height: 16),
          _ContactDetailItem(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: AppStrings.location,
          ),
          const SizedBox(height: 16),
          _ContactDetailItem(
            icon: Icons.code_outlined,
            label: 'GitHub',
            value: AppStrings.github,
            onTap: () => _copyToClipboard(AppStrings.githubUrl),
          ),
          const SizedBox(height: 40),

          // Availability badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.08),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Available for opportunities',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return AnimatedSectionWrapper(
      delay: const Duration(milliseconds: 300),
      slideOffset: const Offset(0.05, 0),
      child: Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _sent ? _buildSuccessState() : _buildForm(),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF10B981).withOpacity(0.1),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Color(0xFF10B981),
            size: 36,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Message Sent!',
          style: GoogleFonts.sora(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Thanks for reaching out. I'll get back to you within 24 hours.",
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 28),
        _GlowButton(
          label: 'Send Another',
          onTap: () => setState(() {
            _sent = false;
            _nameController.clear();
            _emailController.clear();
            _messageController.clear();
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send a Message',
            style: GoogleFonts.sora(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 28),
          _FormField(
            controller: _nameController,
            label: 'Your Name',
            icon: Icons.person_outline,
            validator: (v) =>
                v == null || v.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 20),
          _FormField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your email';
              if (!v.contains('@')) return 'Please enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _FormField(
            controller: _messageController,
            label: 'Your Message',
            icon: Icons.message_outlined,
            maxLines: 5,
            validator: (v) =>
                v == null || v.isEmpty ? 'Please enter a message' : null,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: _GlowButton(
              label: _sending ? 'Sending...' : 'Send Message',
              onTap: _sending ? null : _submitForm,
              isLoading: _sending,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text', style: GoogleFonts.dmSans()),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _ContactDetailItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactDetailItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  State<_ContactDetailItem> createState() => _ContactDetailItemState();
}

class _ContactDetailItemState extends State<_ContactDetailItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.cardHover : AppColors.card,
            border: Border.all(
              color: _hovered
                  ? AppColors.primary.withOpacity(0.3)
                  : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: _hovered
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onTap != null)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _hovered ? 1 : 0,
                  child: const Icon(
                    Icons.content_copy,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => _focused = v),
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        style: GoogleFonts.dmSans(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: GoogleFonts.dmSans(
            color: _focused ? AppColors.primary : AppColors.textMuted,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: _focused ? AppColors.primary : AppColors.textMuted,
            size: 18,
          ),
          filled: true,
          fillColor: AppColors.surface,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: widget.maxLines > 1 ? 16 : 14,
          ),
        ),
      ),
    );
  }
}

class _GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _GlowButton({required this.label, this.onTap, this.isLoading = false});

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(_hovered ? 0.5 : 0.2),
                blurRadius: _hovered ? 24 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: GoogleFonts.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.translationValues(
                          _hovered ? 4 : 0,
                          0,
                          0,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
