#import <UIKit/UIKit.h>

#define WATERMARK_TAG 0x4B595245
#define TELEGRAM_URL  @"https://t.me/kyrexipaa"

static BOOL ky_alert_shown = NO;

static UIWindow *ky_key_window(void) {
    UIWindow *keyWindow = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows) {
            if (w.isKeyWindow) { keyWindow = w; break; }
        }
        if (keyWindow) break;
    }
    return keyWindow;
}

static void ky_show_watermark(void) {
    if (ky_alert_shown) return;

    UIWindow *keyWindow = ky_key_window();
    if (!keyWindow) return;

    for (UIView *v in keyWindow.subviews) {
        if (v.tag == WATERMARK_TAG) return;
    }

    UIViewController *root = keyWindow.rootViewController;
    if (!root) return;
    while (root.presentedViewController) root = root.presentedViewController;
    if ([root isKindOfClass:[UIAlertController class]]) return;

    ky_alert_shown = YES;

    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"KYREX IPA"
                                            message:@"Привет, этот файл был создан каналом KYREX IPA"
                                     preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Перейти"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:TELEGRAM_URL];
        if (url) {
            [UIApplication.sharedApplication openURL:url
                                             options:@{}
                                   completionHandler:nil];
        }
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Отменить"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];

    UIView *tagView = [[UIView alloc] initWithFrame:CGRectZero];
    tagView.tag = WATERMARK_TAG;
    [keyWindow addSubview:tagView];

    [root presentViewController:alert animated:YES completion:nil];
}

__attribute__((constructor))
static void ky_init(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        ky_show_watermark();
    });
}
