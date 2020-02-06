#import "HappilyScientificPensioner.h"
#import "SprainTimberRelevant.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonCrypto.h>
static const int AES_256_IV_SIZE = 16;
@implementation NSData (AES)
- (NSData *)AES256EncryptWithKey:(NSString *)key {
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    NSMutableData *data = [[NSData randomDataWithLength:AES_256_IV_SIZE] mutableCopy];  
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key cStringUsingEncoding:NSUTF8StringEncoding],
                                          [key length],
                                          [data bytes],
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *message = [NSData dataWithBytes:buffer
                                         length:numBytesEncrypted]; 
        NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
        NSData *hmac = [message doHmacWithKeyData:keyData];
        [data appendData:message];
        [data appendData:hmac];
        free(buffer);
        return data;
    }
    free(buffer);
    return nil;
}
- (NSData *)doHmacWithKeyData:(NSData *)salt {
    NSMutableData *macOut = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256,
           salt.bytes,
           salt.length,
           self.bytes,
           self.length,
           macOut.mutableBytes);
    return macOut;
}
- (NSData *)AES256DecryptWithKey:(NSString *)key {
    unsigned char hmacSvrBuffer[CC_SHA256_DIGEST_LENGTH];
    unsigned long hmacStartLoc = [self length]-CC_SHA256_DIGEST_LENGTH;
    [self getBytes:hmacSvrBuffer
             range:NSMakeRange(hmacStartLoc, CC_SHA256_DIGEST_LENGTH)];
    NSData *hmacSvr = [NSData dataWithBytes:hmacSvrBuffer
                                     length:CC_SHA256_DIGEST_LENGTH];
    NSData *messageData = [self subdataWithRange:NSMakeRange(AES_256_IV_SIZE, [self length]-CC_SHA256_DIGEST_LENGTH-AES_256_IV_SIZE)];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hmacApp = [messageData doHmacWithKeyData:keyData];
    if (![hmacApp isEqualToData:hmacSvr]) {
        NSLog(@"Authentication Code From Svr[%@] != Calc by Client[%@]", hmacSvr, hmacApp);
        return nil;
    }
    unsigned char iv[AES_256_IV_SIZE] = {0};
    memcpy(iv, [self bytes], sizeof(iv));
    NSUInteger dataLength = [self length]-AES_256_IV_SIZE-CC_SHA256_DIGEST_LENGTH;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key cStringUsingEncoding:NSUTF8StringEncoding],
                                          [key length],
                                          iv,
                                          [self bytes]+AES_256_IV_SIZE,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer
                                    length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}
@end
@implementation NSString (AES)
- (NSString *)AES256EncryptWithKey:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *entryptData = [data AES256EncryptWithKey:key];
    return [[NSString alloc] initWithData:entryptData
                                 encoding:NSUTF8StringEncoding];
}
- (NSString *)AES256DecryptWithKey:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [data AES256DecryptWithKey:key];
    return [[NSString alloc] initWithData:decryptData
                                 encoding:NSUTF8StringEncoding];
}
@end
