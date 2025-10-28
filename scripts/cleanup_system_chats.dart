import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Script to clean up system user test data from Firestore
///
/// This script will:
/// 1. Delete all chats where is_system_chat = true
/// 2. Delete all chat_messages where is_system_message = true
///
/// Run with: dart run scripts/cleanup_system_chats.dart

Future<void> main() async {
  print('🧹 System Chat Cleanup Script');
  print('=' * 50);

  try {
    // Initialize Firebase
    print('🔧 Initializing Firebase...');
    await Firebase.initializeApp();
    print('✅ Firebase initialized');

    final firestore = FirebaseFirestore.instance;

    // Step 1: Delete system chats
    print('\n📂 Step 1: Deleting system chats...');
    await deleteSystemChats(firestore);

    // Step 2: Delete system messages
    print('\n💬 Step 2: Deleting system messages...');
    await deleteSystemMessages(firestore);

    print('\n✅ Cleanup completed successfully!');
    print('=' * 50);
  } catch (e) {
    print('\n❌ Error during cleanup: $e');
    print('=' * 50);
  }
}

/// Delete all chats where is_system_chat = true
Future<void> deleteSystemChats(FirebaseFirestore firestore) async {
  try {
    // Query for system chats
    final snapshot =
        await firestore.collection('chats').where('is_system_chat', isEqualTo: true).get();

    print('📊 Found ${snapshot.docs.length} system chats');

    if (snapshot.docs.isEmpty) {
      print('ℹ️  No system chats to delete');
      return;
    }

    // Delete in batches (Firestore batch limit is 500)
    final batches = <WriteBatch>[];
    var currentBatch = firestore.batch();
    var operationCount = 0;
    var batchCount = 0;

    for (var doc in snapshot.docs) {
      currentBatch.delete(doc.reference);
      operationCount++;

      // Create new batch every 500 operations
      if (operationCount == 500) {
        batches.add(currentBatch);
        currentBatch = firestore.batch();
        operationCount = 0;
        batchCount++;
      }
    }

    // Add remaining operations
    if (operationCount > 0) {
      batches.add(currentBatch);
      batchCount++;
    }

    // Commit all batches
    print('🔄 Committing ${batches.length} batch(es)...');
    for (var i = 0; i < batches.length; i++) {
      await batches[i].commit();
      print('  ✅ Batch ${i + 1}/${batches.length} committed');
    }

    print('✅ Deleted ${snapshot.docs.length} system chats');
  } catch (e) {
    print('❌ Error deleting system chats: $e');
    rethrow;
  }
}

/// Delete all chat messages where is_system_message = true
Future<void> deleteSystemMessages(FirebaseFirestore firestore) async {
  try {
    // Query for system messages
    final snapshot = await firestore
        .collection('chat_messages')
        .where('is_system_message', isEqualTo: true)
        .get();

    print('📊 Found ${snapshot.docs.length} system messages');

    if (snapshot.docs.isEmpty) {
      print('ℹ️  No system messages to delete');
      return;
    }

    // Delete in batches (Firestore batch limit is 500)
    final batches = <WriteBatch>[];
    var currentBatch = firestore.batch();
    var operationCount = 0;
    var batchCount = 0;

    for (var doc in snapshot.docs) {
      currentBatch.delete(doc.reference);
      operationCount++;

      // Create new batch every 500 operations
      if (operationCount == 500) {
        batches.add(currentBatch);
        currentBatch = firestore.batch();
        operationCount = 0;
        batchCount++;
      }
    }

    // Add remaining operations
    if (operationCount > 0) {
      batches.add(currentBatch);
      batchCount++;
    }

    // Commit all batches
    print('🔄 Committing ${batches.length} batch(es)...');
    for (var i = 0; i < batches.length; i++) {
      await batches[i].commit();
      print('  ✅ Batch ${i + 1}/${batches.length} committed');
    }

    print('✅ Deleted ${snapshot.docs.length} system messages');
  } catch (e) {
    print('❌ Error deleting system messages: $e');
    rethrow;
  }
}
