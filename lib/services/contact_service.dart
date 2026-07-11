// Contact form service interface.
// Currently uses a mock implementation that logs submissions locally.
// To enable Firebase, implement FirebaseContactService and swap the provider
// in lib/app/providers.dart.

enum EnquiryType { general, speaker, sponsorship, volunteer }

class ContactFormData {
  const ContactFormData({
    required this.name,
    required this.email,
    required this.enquiryType,
    required this.subject,
    required this.message,
  });

  final String name;
  final String email;
  final EnquiryType enquiryType;
  final String subject;
  final String message;
}

abstract class ContactService {
  Future<void> submitEnquiry(ContactFormData data);
}

class MockContactService implements ContactService {
  final List<ContactFormData> _submissions = [];

  List<ContactFormData> get submissions => List.unmodifiable(_submissions);

  @override
  Future<void> submitEnquiry(ContactFormData data) async {
    // Simulate network delay during development
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _submissions.add(data);
    // ignore: avoid_print
    print(
      '[MockContactService] Received enquiry:\n'
      '  Name: ${data.name}\n'
      '  Email: ${data.email}\n'
      '  Type: ${data.enquiryType.name}\n'
      '  Subject: ${data.subject}\n'
      '  Message: ${data.message}',
    );
  }
}
