import 'dart:typed_data';

import 'package:ffi_mina_signer/encrypt/kdf/kdf.dart';
import 'package:ffi_mina_signer/encrypt/model/keyiv.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:pointycastle/export.dart';

/// pbkdf2 Key derivation function with a random salt
///
/// Password hashing has moved to Argon2id(v13).
/// This was only for the old users who has his data encrypted by old method.
/// Any new users would discard this method.
class PBKDF2 extends KDF {
  /// Derive a KeyIV with given password and optional salt
  /// Expects password to be a utf-8 string
  /// If salt is not provided, a single null byte will be used for the salt
  KeyIV deriveKey(String password, {Uint8List? salt}) {
    Uint8List pwBytes = MinaHelper.stringToBytesUtf8(password);
    Uint8List saltBytes = salt == null ? Uint8List(1) : salt;

    // Use pbkdf2 from pointycastle
    KeyDerivator kdf = KeyDerivator("SHA-1/HMAC/PBKDF2");
    Pbkdf2Parameters params = Pbkdf2Parameters(saltBytes, 100, 48);
    kdf.init(params);
    Uint8List pbkdfKey = kdf.process(pwBytes);

    return KeyIV(pbkdfKey.sublist(0, 32), pbkdfKey.sublist(32, 48));
  }
}
