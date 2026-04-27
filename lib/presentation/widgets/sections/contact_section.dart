
import 'package:flutter/material.dart';
import '../common/section_wrapper.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Center(child: Text("Contact Section")),
    );
  }
}
