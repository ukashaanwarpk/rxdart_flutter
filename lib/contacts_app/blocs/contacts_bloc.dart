import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:rxdart/rxdart.dart';

import '../models/contact_model.dart';

typedef _Snapshot = QuerySnapshot<Map<String, dynamic>>;

extension UnWrap<T> on Stream<T?> {
  Stream<T> unWrap() => switchMap((optional) async* {
    if (optional != null) {
      yield optional;
    }
  });
}

@immutable
class ContactsBloc {
  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;

  final Sink<void> deleteAllContact;

  final Stream<Iterable<Contact>> contacts;

  final StreamSubscription<void> _createContactSubscription;

  final StreamSubscription<void> _deleteContactSubscription;

  final StreamSubscription<void> _deleteAllContactSubscription;

  void dispose() {
    userId.close();
    createContact.close();
    deleteContact.close();
    deleteAllContact.close();

    _createContactSubscription.cancel();
    _deleteContactSubscription.cancel();
    _deleteAllContactSubscription.cancel();
  }

  const ContactsBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.contacts,
    required this.deleteAllContact,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
    required StreamSubscription<void> deleteAllContactSubscription,
  }) : _createContactSubscription = createContactSubscription,
       _deleteContactSubscription = deleteContactSubscription,
       _deleteAllContactSubscription = deleteAllContactSubscription;

  factory ContactsBloc() {
    final backend = FirebaseFirestore.instance;

    // userId

    final userId = BehaviorSubject<String?>();

    // upon changes to user id, retrive our contacts

    final Stream<Iterable<Contact>> contacts = userId
        .switchMap<_Snapshot>((userId) {
          if (userId == null) {
            return const Stream<_Snapshot>.empty();
          } else {
            return backend.collection(userId).snapshots();
          }
        })
        .map<Iterable<Contact>>((snapshot) sync* {
          for (final doc in snapshot.docs) {
            yield Contact.fromJson(doc.data(), id: doc.id);
          }
        });

    // create contact

    final createContact = BehaviorSubject<Contact>();

    final StreamSubscription<void> createContactSubscription = createContact
        .switchMap(
          (Contact contactToCreate) => userId
              .take(1)
              .unWrap()
              .asyncMap(
                (userId) =>
                    backend.collection(userId).add(contactToCreate.data),
              ),
        )
        .listen((event) {});

    // delete contact

    final deleteContact = BehaviorSubject<Contact>();

    final StreamSubscription<void> deleteContactSubscription = deleteContact
        .switchMap(
          (Contact contactToDelete) => userId
              .take(1)
              .unWrap()
              .asyncMap(
                (userId) =>
                    backend.collection(userId).doc(contactToDelete.id).delete(),
              ),
        )
        .listen((event) {});

    // delete all contact

    final deleteAllContacts = BehaviorSubject<void>();

    final StreamSubscription<void> deleteAllContactSubscription =
        deleteAllContacts
            .switchMap((_) => userId.take(1).unWrap())
            .asyncMap((userId) => backend.collection(userId).get())
            .switchMap(
              (collection) => Stream.fromFutures(
                collection.docs.map((doc) => doc.reference.delete()),
              ),
            )
            .listen((_) {});

    return ContactsBloc._(
      userId: userId,
      createContact: createContact,
      deleteContact: deleteContact,
      contacts: contacts,
      deleteAllContact: deleteAllContacts,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription,
      deleteAllContactSubscription: deleteAllContactSubscription,
    );
  }
}
