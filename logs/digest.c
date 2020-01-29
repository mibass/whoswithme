#include <sqlite3ext.h>
#include <stdio.h>
#include <string.h>

#if defined(__APPLE__) && defined(__MACH__)
    #define COMMON_DIGEST_FOR_OPENSSL
    #include <CommonCrypto/CommonDigest.h>
    #define SHA1 CC_SHA1
    #include <CommonCrypto/CommonHMAC.h>
    #define HMAC CCHmac
#else
    #include <openssl/hmac.h>
    #include <openssl/sha.h>
    #include <openssl/rc4.h>
    #include <openssl/aes.h>
#endif

SQLITE_EXTENSION_INIT1

/**
 * Creates a sha1 hash.
 */
static void sha1(
    sqlite3_context *context,
    int argc,
    sqlite3_value **argv)
{
    char *orig = 0;
    orig = (char *)sqlite3_value_text(argv[0]);

    int i = 0;

	unsigned char temp[SHA_DIGEST_LENGTH];
	char hash[SHA_DIGEST_LENGTH*2];

	memset(hash, 0x0, SHA_DIGEST_LENGTH*2);
	memset(temp, 0x0, SHA_DIGEST_LENGTH);

	SHA1((unsigned char *)orig, strlen(orig), temp);

	for (i=0; i < SHA_DIGEST_LENGTH; i++) {
		sprintf((char*)&(hash[i*2]), "%02x", temp[i]);
	}

    sqlite3_result_text(context, hash, strlen(hash), (void*) -1);
}


/**
 * SQLite invokes this routine once when it loads the extension.
 * Create new functions, collating sequences, and virtual table
 * modules here.  This is usually the only exported symbol in
 * the shared library.
 */
int sqlite3_extension_init(
  sqlite3 *db,
  char **pzErrMsg,
  const sqlite3_api_routines *pApi
) {
    SQLITE_EXTENSION_INIT2(pApi);
    sqlite3_create_function(db, "sha1", 1, SQLITE_ANY, 0, sha1, 0, 0);
    return 0;
}
