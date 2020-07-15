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

#import "SDKStateView.h"
#import "AdvancedSetup_Logic.h"

@interface SDKStateView()

@property (weak, nonatomic) IBOutlet UILabel    *labelStateValue;
@property (weak, nonatomic) IBOutlet UITextView *textLog;

@end

@implementation SDKStateView

// MARK: - Life Cycle

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setupWithFrame:self.bounds];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupWithFrame:frame];
    }
    
    return self;
}

- (void)setupWithFrame:(CGRect)frame
{
    // Color is used as placeholder in case of disabled IB_DESIGNABLE
    self.backgroundColor = [UIColor clearColor];
        
    // Get our view from storyboard.
    UIView *contentView = [[[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
    contentView.frame = frame;
    
    // Add it as child of current View.
    [self addSubview:contentView];
    
    // Register notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onFaceStateChanged:)
                                                 name:C_NOTIFICATION_ID_FACE_STATE_CHANGED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLogStateChanged:)
                                                 name:C_NOTIFICATION_ID_LOG_STATE_CHANGED
                                               object:nil];
    
    // Load current values
    [self onFaceStateChanged:nil];
    [self onLogStateChanged:nil];
}

- (void) dealloc
{
    // Unregister all notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - Notifications

- (void)onFaceStateChanged:(NSNotification *) notification
{
    ProtectorFaceIdState state = [AdvancedSetup_Logic state];
    
    _labelStateValue.text       = ProtectorFaceIdState_ToString(state);
    _labelStateValue.textColor  = ProtectorFaceIdState_ToColor(state);
}

- (void)onLogStateChanged:(NSNotification *) notification
{
    NSString *log = [AdvancedSetup_Logic log];
    
    [_textLog setText:log];
    [_textLog scrollRangeToVisible:NSMakeRange(log.length, 0)];
}

// MARK: - IBInspectable

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

@end
