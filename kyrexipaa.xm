#import <UIKit/UIKit.h>

#define WATERMARK_TAG 0x4B595245
#define CHANNEL_URL   @"https://t.me/kyrexipaa"
#define DETAILS_URL   @"https://t.me/KYREXiPAA/503"

@interface KYREXWatermarkController : UIViewController
@end

@implementation KYREXWatermarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    // --- Полупрозрачная подложка ---
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.96];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:bgView];

    // --- Скролл на случай маленького экрана в ландшафте ---
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scroll.alwaysBounceVertical = YES;
    [self.view addSubview:scroll];

    // --- Вертикальный стек ---
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 18;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [scroll addSubview:stack];

    // --- Логотип KYREX IPA (картинка из бандла) ---
    UIImageView *logoView = [[UIImageView alloc] init];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *logoImg = [UIImage imageNamed:@"logo.png" inBundle:bundle compatibleWithTraitCollection:nil];
    if (!logoImg) {
        // резервный путь, если Theos положил ресурс в Resources/
        NSString *path = [bundle pathForResource:@"logo" ofType:@"png"];
        if (path) logoImg = [UIImage imageWithContentsOfFile:path];
    }
    logoView.image = logoImg;
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [logoView.widthAnchor constraintEqualToConstant:150].active = YES;
    [logoView.heightAnchor constraintEqualToConstant:150].active = YES;
    [stack addArrangedSubview:logoView];

    // --- Заголовок ---
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Скачано с @KYREXipaa";
    title.font = [UIFont boldSystemFontOfSize:28];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 0;
    [stack addArrangedSubview:title];

    // --- Описание ---
    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.text = @"Посетите наш канал, нажав на кнопку ниже, чтобы отключить это уведомление.";
    subtitle.font = [UIFont systemFontOfSize:16];
    subtitle.textColor = [UIColor darkGrayColor];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.numberOfLines = 0;
    subtitle.preferredMaxLayoutWidth = 300;
    [stack addArrangedSubview:subtitle];

    // --- Кнопка "Наш канал" ---
    UIButton *channelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [channelButton setTitle:@"Наш канал" forState:UIControlStateNormal];
    channelButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [channelButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    channelButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0].CGColor;
    channelButton.layer.borderWidth = 1.5;
    channelButton.layer.cornerRadius = 25;
    channelButton.contentEdgeInsets = UIEdgeInsetsMake(12, 40, 12, 40);
    [channelButton addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:channelButton];

    // --- Кнопка "Закрыть" ---
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"Закрыть" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [closeButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    closeButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0].CGColor;
    closeButton.layer.borderWidth = 1.5;
    closeButton.layer.cornerRadius = 25;
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(12, 40, 12, 40);
    [closeButton addTarget:self action:@selector(closeWatermark) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:closeButton];

    // --- Нижний текст ---
    UILabel *footer = [[UILabel alloc] init];
    footer.text = @"Также в нашем канале есть опция покупки личного сертификата. Если у вас его нет или он подходит к концу, можете ознакомиться по ссылке ниже.";
    footer.font = [UIFont systemFontOfSize:14];
    footer.textColor = [UIColor grayColor];
    footer.textAlignment = NSTextAlignmentCenter;
    footer.numberOfLines = 0;
    footer.preferredMaxLayoutWidth = 300;
    [stack addArrangedSubview:footer];

    // --- Кнопка "Подробнее" ---
    UIButton *detailsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [detailsButton setTitle:@"Подробнее" forState:UIControlStateNormal];
    detailsButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [detailsButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [detailsButton addTarget:self action:@selector(openDetails) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:detailsButton];

    // --- Раскладка стека внутри скролла ---
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:scroll.topAnchor constant:40],
        [stack.bottomAnchor constraintEqualToAnchor:scroll.bottomAnchor constant:-40],
        [stack.centerXAnchor constraintEqualToAnchor:scroll.centerXAnchor],
        [stack.widthAnchor constraintLessThanOrEqualToConstant:340],
        [stack.leadingAnchor constraintGreaterThanOrEqualToAnchor:scroll.leadingAnchor constant:20],
        [stack.trailingAnchor constraintLessThanOrEqualToAnchor:scroll.trailingAnchor constant:-20],
        [scroll.contentLayoutGuide.widthAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.widthAnchor],
    ]];
}

- (void)openChannel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CHANNEL_URL] options:@{} completionHandler:nil];
}

- (void)openDetails {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DETAILS_URL] options:@{} completionHandler:nil];
}

- (void)closeWatermark {
    for (UIWindow *w in [UIApplication sharedApplication].windows) {
        if (w.tag == WATERMARK_TAG) {
            w.hidden = YES;
            w.rootViewController = nil;
        }
    }
}

@end

// --- Показ окна вотермарка ---
static void ky_show_watermark(void) {
    for (UIWindow *w in [UIApplication sharedApplication].windows) {
        if (w.tag == WATERMARK_TAG && !w.hidden) return;
    }

    UIWindow *watermarkWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    watermarkWindow.tag = WATERMARK_TAG;
    watermarkWindow.windowLevel = UIWindowLevelAlert + 1.0;
    watermarkWindow.rootViewController = [[KYREXWatermarkController alloc] init];
    watermarkWindow.hidden = NO;
    [watermarkWindow makeKeyAndVisible];
}

__attribute__((constructor))
static void ky_init(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        ky_show_watermark();
    });
}
