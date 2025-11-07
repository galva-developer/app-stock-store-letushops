import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../models/user_model.dart';

/// Fuente de datos concreta que implementa las operaciones de autenticación
/// usando Firebase Authentication y Cloud Firestore.
///
/// Esta clase se encarga de:
/// - Conectar con Firebase Auth para operaciones de autenticación
/// - Sincronizar datos del usuario con Firestore
/// - Convertir excepciones de Firebase a excepciones del dominio
/// - Manejar el estado de autenticación en tiempo real
class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  /// Constructor que permite inyectar instancias de Firebase para testing
  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream que emite cambios en el estado de autenticación
  ///
  /// Combina datos de Firebase Auth con datos extendidos de Firestore
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        // Crear modelo base desde Firebase User
        var userModel = UserModel.fromFirebaseUser(firebaseUser);

        // Intentar obtener datos extendidos de Firestore
        final userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          // Combinar datos de Firebase Auth con datos de Firestore
          final firestoreData = userDoc.data() ?? {};
          userModel = userModel.mergeWithFirestoreData(firestoreData);
        } else {
          // Si no existe documento en Firestore, crearlo
          await _createUserDocument(userModel);
        }

        return userModel;
      } catch (e) {
        // En caso de error, devolver modelo básico
        return UserModel.fromFirebaseUser(firebaseUser);
      }
    });
  }

  /// Obtiene el usuario actualmente autenticado
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      var userModel = UserModel.fromFirebaseUser(firebaseUser);

      // Obtener datos extendidos de Firestore
      final userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (userDoc.exists) {
        final firestoreData = userDoc.data() ?? {};
        userModel = userModel.mergeWithFirestoreData(firestoreData);
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Inicia sesión con email y contraseña
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Iniciando sesión para: $email');

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        throw const UnknownAuthException(
          message: 'Authentication successful but user is null',
        );
      }

      print('✅ Autenticación exitosa. UID: ${credential.user!.uid}');

      var userModel = UserModel.fromFirebaseUser(credential.user!);

      // Obtener datos completos de Firestore PRIMERO
      print('📄 Obteniendo datos de Firestore...');
      final userDoc =
          await _firestore.collection('users').doc(credential.user!.uid).get();

      if (userDoc.exists) {
        print('✅ Documento encontrado en Firestore');
        // Si existe, combinar con datos de Firestore (rol, estado, etc.)
        final firestoreData = userDoc.data() ?? {};
        print(
          '📋 Datos de Firestore: role=${firestoreData['role']}, status=${firestoreData['status']}',
        );

        userModel = userModel.mergeWithFirestoreData(firestoreData);
        print(
          '👤 Usuario final: role=${userModel.role}, status=${userModel.status}',
        );

        // Actualizar solo campos de autenticación (no el rol)
        await _firestore.collection('users').doc(credential.user!.uid).update({
          'lastSignInTime': FieldValue.serverTimestamp(),
          'emailVerified': credential.user!.emailVerified,
        });
      } else {
        print('⚠️ Documento NO encontrado en Firestore. Creando nuevo...');
        // Si no existe, crear documento nuevo con rol por defecto
        await _createUserDocument(userModel);
        print('✅ Documento creado con rol: ${userModel.role}');
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      print('❌ Error de autenticación: ${e.code} - ${e.message}');
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      print('❌ Error inesperado: $e');
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Cierra la sesión del usuario actual
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Envía un email para restablecer la contraseña
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Actualiza el perfil del usuario actual
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const SessionExpiredException();
      }

      // Actualizar perfil en Firebase Auth
      if (displayName != null) {
        await currentUser.updateDisplayName(displayName.trim());
      }
      if (photoURL != null) {
        await currentUser.updatePhotoURL(photoURL);
      }

      // Recargar datos del usuario
      await currentUser.reload();
      final updatedFirebaseUser = _firebaseAuth.currentUser!;

      var userModel = UserModel.fromFirebaseUser(updatedFirebaseUser);

      // Actualizar datos en Firestore
      await _updateUserDocument(userModel);

      // Obtener datos completos
      final userDoc =
          await _firestore
              .collection('users')
              .doc(updatedFirebaseUser.uid)
              .get();

      if (userDoc.exists) {
        final firestoreData = userDoc.data() ?? {};
        userModel = userModel.mergeWithFirestoreData(firestoreData);
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Actualiza la contraseña del usuario actual
  Future<void> updatePassword({required String newPassword}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const SessionExpiredException();
      }

      await currentUser.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Reautentica al usuario con su contraseña actual
  Future<void> reauthenticate({required String password}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null || currentUser.email == null) {
        throw const SessionExpiredException();
      }

      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );

      await currentUser.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Envía un email de verificación al usuario actual
  Future<void> sendEmailVerification() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const SessionExpiredException();
      }

      await currentUser.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Recarga los datos del usuario actual desde el servidor
  Future<UserModel> reloadUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const SessionExpiredException();
      }

      await currentUser.reload();
      final reloadedUser = _firebaseAuth.currentUser!;

      var userModel = UserModel.fromFirebaseUser(reloadedUser);

      // Obtener datos extendidos de Firestore
      final userDoc =
          await _firestore.collection('users').doc(reloadedUser.uid).get();

      if (userDoc.exists) {
        final firestoreData = userDoc.data() ?? {};
        userModel = userModel.mergeWithFirestoreData(firestoreData);
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Elimina la cuenta del usuario actual
  Future<void> deleteAccount() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const SessionExpiredException();
      }

      final uid = currentUser.uid;

      // Eliminar documento de Firestore primero
      await _firestore.collection('users').doc(uid).delete();

      // Eliminar cuenta de Firebase Auth
      await currentUser.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Verifica si el usuario actual tiene permisos para una acción específica
  Future<bool> hasPermission(UserRole requiredRole) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) return false;

      switch (requiredRole) {
        case UserRole.employee:
          return currentUser.isActive;
        case UserRole.manager:
          return currentUser.isManager && currentUser.isActive;
        case UserRole.admin:
          return currentUser.isAdmin && currentUser.isActive;
      }
    } catch (e) {
      return false;
    }
  }

  /// Actualiza el rol del usuario (solo para administradores)
  Future<void> updateUserRole({
    required String userId,
    required UserRole newRole,
  }) async {
    try {
      // Verificar que el usuario actual es admin
      final hasAdminPermission = await hasPermission(UserRole.admin);
      if (!hasAdminPermission) {
        throw const InsufficientPermissionsException();
      }

      await _firestore.collection('users').doc(userId).update({
        'role': newRole.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw const UserNotFoundException();
      }
      throw ServerException(message: e.message ?? 'Firestore error');
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Actualiza el estado del usuario (solo para administradores)
  Future<void> updateUserStatus({
    required String userId,
    required UserStatus newStatus,
  }) async {
    try {
      // Verificar que el usuario actual es admin
      final hasAdminPermission = await hasPermission(UserRole.admin);
      if (!hasAdminPermission) {
        throw const InsufficientPermissionsException();
      }

      await _firestore.collection('users').doc(userId).update({
        'status': newStatus.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw const UserNotFoundException();
      }
      throw ServerException(message: e.message ?? 'Firestore error');
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Obtiene la lista de todos los usuarios (solo para administradores)
  Future<List<UserModel>> getAllUsers({int? limit, String? startAfter}) async {
    try {
      // Verificar que el usuario actual es admin
      final hasAdminPermission = await hasPermission(UserRole.admin);
      if (!hasAdminPermission) {
        throw const InsufficientPermissionsException();
      }

      Query query = _firestore.collection('users').orderBy('email');

      if (limit != null) {
        query = query.limit(limit);
      }

      if (startAfter != null) {
        final startDoc =
            await _firestore.collection('users').doc(startAfter).get();
        if (startDoc.exists) {
          query = query.startAfterDocument(startDoc);
        }
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Busca usuarios por email o nombre (solo para administradores)
  Future<List<UserModel>> searchUsers({
    required String query,
    int? limit,
  }) async {
    try {
      // Verificar que el usuario actual es admin
      final hasAdminPermission = await hasPermission(UserRole.admin);
      if (!hasAdminPermission) {
        throw const InsufficientPermissionsException();
      }

      // Firestore no soporta búsqueda de texto completo nativa
      // Esta implementación busca por prefijo de email
      final searchQuery = query.toLowerCase().trim();

      Query firestoreQuery = _firestore
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: searchQuery)
          .where('email', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .orderBy('email');

      if (limit != null) {
        firestoreQuery = firestoreQuery.limit(limit);
      }

      final querySnapshot = await firestoreQuery.get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Obtiene los datos completos de un usuario específico
  Future<UserModel> getUserById(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw const UserNotFoundException();
      }

      return UserModel.fromFirestore(userDoc);
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw const UserNotFoundException();
      }
      throw ServerException(message: e.message ?? 'Firestore error');
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Verifica si un email está disponible para registro
  Future<bool> isEmailAvailable(String email) async {
    try {
      final signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(
        email.trim(),
      );
      return signInMethods.isEmpty;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Elimina un usuario del sistema (solo para administradores)
  ///
  /// NOTA: Firebase Admin SDK es necesario para eliminar usuarios desde el servidor.
  /// Esta implementación solo marca al usuario como inactivo en Firestore.
  /// Para eliminación completa, usar Cloud Functions con Admin SDK.
  Future<void> deleteUser({required String userId}) async {
    try {
      // Verificar que el usuario actual es admin
      final hasAdminPermission = await hasPermission(UserRole.admin);
      if (!hasAdminPermission) {
        throw const InsufficientPermissionsException();
      }

      // No se puede eliminar el propio usuario administrador
      final currentUser = await getCurrentUser();
      if (currentUser?.uid == userId) {
        throw const UnknownAuthException(
          message: 'No puedes eliminar tu propia cuenta de administrador',
        );
      }

      // Marcar como inactivo en Firestore
      await _firestore.collection('users').doc(userId).update({
        'status': UserStatus.inactive.value,
        'deletedAt': FieldValue.serverTimestamp(),
        'deletedBy': currentUser?.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // TODO: Implementar Cloud Function para eliminar del Authentication
      // usando Firebase Admin SDK
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw const UserNotFoundException();
      }
      throw ServerException(message: e.message ?? 'Firestore error');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Métodos privados para gestión de documentos de Firestore

  /// Crea un documento de usuario en Firestore
  Future<void> _createUserDocument(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toFirestore());
    } catch (e) {
      // Log error pero no fallar - el usuario puede seguir funcionando
      // sin datos extendidos en Firestore
      print('Error creating user document: $e');
    }
  }

  /// Actualiza el documento de usuario en Firestore
  Future<void> _updateUserDocument(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      // Log error pero no fallar
      print('Error updating user document: $e');
    }
  }
}
