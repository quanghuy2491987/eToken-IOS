/* -----------------------------------------------------------------------------
 *
 *     Copyright (c)  2013  -  GEMALTO DEVELOPEMENT - R&D
 *
 * -----------------------------------------------------------------------------
 * GEMALTO MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF
 * THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 * TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE, OR NON-INFRINGEMENT. GEMALTO SHALL NOT BE
 * LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING,
 * MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
 *
 * THIS SOFTWARE IS NOT DESIGNED OR INTENDED FOR USE OR RESALE AS ON-LINE
 * CONTROL EQUIPMENT IN HAZARDOUS ENVIRONMENTS REQUIRING FAIL-SAFE
 * PERFORMANCE, SUCH AS IN THE OPERATION OF NUCLEAR FACILITIES, AIRCRAFT
 * NAVIGATION OR COMMUNICATION SYSTEMS, AIR TRAFFIC CONTROL, DIRECT LIFE
 * SUPPORT MACHINES, OR WEAPONS SYSTEMS, IN WHICH THE FAILURE OF THE
 * SOFTWARE COULD LEAD DIRECTLY TO DEATH, PERSONAL INJURY, OR SEVERE
 * PHYSICAL OR ENVIRONMENTAL DAMAGE ("HIGH RISK ACTIVITIES"). GEMALTO
 * SPECIFICALLY DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY OF FITNESS FOR
 * HIGH RISK ACTIVITIES.
 *
 * -----------------------------------------------------------------------------
 */


#import <Foundation/Foundation.h>
#import <EzioMobile/EzioMobile.h>

@interface FakeAppData : NSObject

+ (NSURL *)epsUrl;

+ (NSString *)rsaKeyId;

+ (NSData *)rsaKeyModulus;

+ (NSData *)rsaKeyExponent;

+ (NSData *)customFingerprintData;

+ (NSData *)activationVicEnabledSecurePinpadDisabled;

+ (NSData *)activationAllEnabled;
+ (NSString *) CFG_DOMAIN;
+ (NSString *) PROVISION_KEY;
+ (NSString *) PIN_KEY;
+ (NSString *) PIN_SUCCESS;
+ (NSString *) PIN_DIFFERENT;
+ (NSString *) CFG_TLS_CONFIGURATION;
+ (id<EMSecureString> ) CFG_OCRA_SUITE;


typedef enum : NSInteger {
    // Face Id service was not even started.
    ProtectorFaceIdStateUndefined,
    // Face id is not supported
    ProtectorFaceIdStateNotSupported,
    // Failed to registered.
    ProtectorFaceIdStateUnlicensed,
    // Sucesfully registered.
    ProtectorFaceIdStateLicensed,
    // Failed to init service.
    ProtectorFaceIdStateInitFailed,
    // Registered and initialised.
    ProtectorFaceIdStateInited,
    // Registered, initialised and configured with at least one user enrolled.
    ProtectorFaceIdStateReadyToUse
} ProtectorFaceIdState;

__unused static NSString * ProtectorFaceIdState_ToString(ProtectorFaceIdState state)
{
    switch (state)
    {
        case ProtectorFaceIdStateUndefined:
            return NSLocalizedString(@"STRING_PROTECTOR_FACE_ID_STATE_UNDEFINED", nil);
        case ProtectorFaceIdStateNotSupported:
            return NSLocalizedString(@"STRING_PROTECTOR_FACE_ID_STATE_NOT_SUPPORTED", nil);
        case ProtectorFaceIdStateReadyToUse:
            return NSLocalizedString(@"STRING_PROTECTOR_FACE_ID_STATE_READY", nil);
        case ProtectorFaceIdStateInited:
            return NSLocalizedString(@"STRING_PROTECTOR_FACE_ID_STATE_INITED", nil);
        case ProtectorFaceIdStateLicensed:
            return NSLocalizedString(@"STRING_PROTECTOR_FACE_ID_STATE_LICENSED", nil);
        case ProtectorFaceIdStateUnlicensed:
            return NSLocalizedString(@"STRING_PROTECTOR_FACE_ID_STATE_UNLICENSED", nil);
        case ProtectorFaceIdStateInitFailed:
            return NSLocalizedString(@"STRING_PROTECTOR_FACE_ID_STATE_INIT_FAILED", nil);
    }
    
    return @"";
}

typedef struct
{
    NSInteger current;
    NSInteger max;
}Lifespan;

typedef void (^GenericOtpHandler)(BOOL success, NSString *result, Lifespan lifespan);
typedef void (^GenericHandler)(BOOL success, NSString *result);
typedef void (^AuthPinHandler)(id<EMPinAuthInput> pin);

@end
