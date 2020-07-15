//  MIT License
//
//  Copyright (c) 2020 Thales DIS
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

// IMPORTANT: This source code is intended to serve training information purposes only.
//            Please make sure to review our IdCloud documentation, including security guidelines.

#import "Provisioning_Logic.h"
#import "FakeAppData.h"

@implementation Provisioning_Logic

+ (void)provisionWithUserId:(NSString *)userId
           registrationCode:(id<EMSecureString>)regCode
          completionHandler:(void (^)(id<EMOathToken>, NSError *))completionHandler
{
    NSError                 *managerErr = nil;
    id<EMOathTokenManager>  oathManager = [[EMOathService serviceWithModule:[EMOtpModule otpModule]] tokenManager:&managerErr];
    
    // Failed to get oath manager. Notify handler and exit.
    if (managerErr) {
        completionHandler(nil, managerErr);
        return;
    }
    
    @try
    {
        // Prepare fingerprint policy.
        EMDeviceFingerprintSource *deviceFingerprintSource = [[EMDeviceFingerprintSource alloc] initWithCustomData:FakeAppData.customFingerprintData];
        EMDeviceFingerprintTokenPolicy *deviceFingerprintTokenPolicy = [[EMDeviceFingerprintTokenPolicy alloc]
                                                                        initWithDeviceFingerprintSource:deviceFingerprintSource
                                                                        failIfInvalid:YES];
        
        // Prepare provisioning configuration based on app data.
        EMProvisioningConfiguration *config = [EMProvisioningConfiguration
                                               epsConfigurationWithURL:FakeAppData.epsUrl
                                               domain:FakeAppData.CFG_DOMAIN
                                               rsaKeyId:FakeAppData.rsaKeyId
                                               rsaExponent:FakeAppData.rsaKeyExponent
                                               rsaModulus:FakeAppData.rsaKeyModulus
                                               registrationCode:regCode
                                               provisioningProtocol:EMMobileProvisioningProtocolVersion5
                                               optionalParameters:^(EMEpsConfigurationBuilder *builder) {
            // We can waken TLS configuration for debug purposes ( forbidden in release mode ).
            builder.tlsConfiguration = FakeAppData.CFG_TLS_CONFIGURATION;
        }];
        
        // Provision token with given config.
        [oathManager createTokenWithName:userId
               provisioningConfiguration:config
            deviceFingerprintTokenPolicy:deviceFingerprintTokenPolicy
                              capability:EMTokenCapabilityDUAL_SEED
               extendedCompletionHandler:^(id<EMOathToken> token, NSDictionary *extensions, NSError *error) {
            completionHandler(token, error);
        }];
    }
    @catch (NSException *exception) {
        completionHandler(nil, [NSError errorWithDomain:NSStringFromClass(self)
                                                   code:-1
                                               userInfo:@{NSLocalizedDescriptionKey: exception.description}]);
    }
}

+ (id<EMDualSeedOathToken>)token: (NSString *)tokenName/*:(NSError *__autoreleasing *)error*/
{
    id<EMOathToken> retValue        = nil;
    NSError         *internalErr    = nil;
    
    do {
        
        // Try to get oath manager.
        id<EMOathTokenManager> oathManager = [[EMOathService serviceWithModule:[EMOtpModule otpModule]] tokenManager:&internalErr];
        BREAK_IF_NOT_NULL(internalErr);
        
        retValue = [oathManager tokenWithName:tokenName fingerprintCustomData:FakeAppData.customFingerprintData error:&internalErr];
        
    } while (false);
    
    // Application might want to handle invalid token in specific way. For example remove old one and ask for new provision.
    // Sample code will simple throw exception and crash.
    // Error here usually mean wrong password or SDK configuration.
    if (internalErr) {
        @throw [NSException
                exceptionWithName:@"InvalidTokenException"
                reason:internalErr.localizedDescription
                userInfo:nil];
    }
    //    if (internalErr && error) {
    //        *error = internalErr;
    //    }
    
    return retValue;
}

+ (BOOL)removeToken:(NSError **)error
{
    BOOL    retValue        = NO;
    NSError *internalErr    = nil;
    
    do {
        // Try to get oath manager.
        id<EMOathTokenManager> oathManager = [[EMOathService serviceWithModule:[EMOtpModule otpModule]] tokenManager:&internalErr];
        BREAK_IF_NOT_NULL(internalErr);
        NSSet<NSString*> *tokenNames = [oathManager tokenNames:&internalErr];
        if (tokenNames.count) {
            for (NSString* tokenName in tokenNames) {
                id<EMOathToken> token = [oathManager tokenWithName:tokenName fingerprintCustomData:FakeAppData.customFingerprintData error:&internalErr];
                // Try to remove it.
                retValue = [oathManager removeToken:token error:&internalErr];
            }
        }
        
    } while (NO);
    
    
    // Something went wrong? Propagate error.
    if (internalErr && error) {
        *error = internalErr;
    }
    
    return retValue;
}

@end
