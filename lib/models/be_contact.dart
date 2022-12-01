import 'package:flutter_contacts/contact.dart';

class BeContact {
  String name;
  String email;
  String phone;
  String title;
  String website;
  String address;
  String city;
  String country;

  BeContact({
    this.name = "Not specified",
    this.email = "Not specified",
    this.phone = "Not specified",
    this.title = "Not specified",
    this.website = "Not specified",
    this.address = "Not specified",
    this.country = "Not specified",
    this.city = "Not specified",
  });

  BeContact fromContact(Contact contact) {
    BeContact beContact = BeContact();

    beContact.name = contact.name.first + " " + contact.name.last;

    if (contact.emails.isNotEmpty && contact.emails[0].address.isNotEmpty) {
      beContact.email = contact.emails[0].address;
    }
    if (contact.phones.isNotEmpty && contact.phones[0].number.isNotEmpty) {
      beContact.phone = contact.phones[0].number;
    }
    if (contact.organizations.isNotEmpty &&
        contact.organizations[0].title.isNotEmpty) {
      beContact.title = contact.organizations[0].title;
    }
    if (contact.websites.isNotEmpty && contact.websites[0].url.isNotEmpty) {
      beContact.website = contact.websites[0].url;
    }
    if (contact.addresses.isNotEmpty) {
      if (contact.addresses[0].street.isNotEmpty) {
        beContact.address = contact.addresses[0].street;
      }
      if (contact.addresses[0].city.isNotEmpty) {
        beContact.city = contact.addresses[0].city;
      }
      if (contact.addresses[0].country.isNotEmpty) {
        beContact.country = contact.addresses[0].country;
      }
    }
    return beContact;
  }
}
