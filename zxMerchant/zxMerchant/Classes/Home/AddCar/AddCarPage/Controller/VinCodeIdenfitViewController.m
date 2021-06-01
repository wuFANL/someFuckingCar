//
//  VinCodeIdenfitViewController.m
//  zxMerchant
//
//  Created by 张精申 on 2021/6/1.
//  Copyright © 2021 ql. All rights reserved.
//

#import "VinCodeIdenfitViewController.h"
#import <Masonry/Masonry.h>
@interface VinCodeIdenfitViewController ()
/** 证件*/
@property (nonatomic, strong) UIImageView *passImageView;
/** vin<##>*/
@property (nonatomic, strong) UITextField *vinCodeText;


@property (nonatomic, strong) NSString *vinCode;
@property (nonatomic, strong) NSString *date;
@end

@implementation VinCodeIdenfitViewController
#pragma mark -- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认VIN码";
    [self setUpUI];
}

- (void)setUpUI{
    // 重拍
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"请核对VIN码，确认无误" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    backButton.backgroundColor = [UIColor colorWithRed:183/255.0 green:185/255.0 blue:195/255.0 alpha:0.8];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *greenLab = [UILabel new];
    greenLab.textAlignment = NSTextAlignmentRight;
    [backButton addSubview:greenLab];
    [greenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backButton.mas_top);
        make.bottom.mas_equalTo(backButton.mas_bottom);
        make.right.mas_equalTo(backButton.mas_right).offset(-5);
        make.width.mas_equalTo(100);
    }];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"重拍   >"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:
     [UIColor colorWithRed:34/255.0 green:172/255.0 blue:56/255.0 alpha:1.0] range:NSMakeRange(0,2)];
    greenLab.attributedText = attributedString;
    
    // 直接就是个照片
    UIImageView * imgv = [[UIImageView alloc]init];
    [self.view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backButton.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.width);
    }];
    self.passImageView = imgv;
    self.passImageView.image = self.selectImg;
    
    // 识别label
    UITextField *text = [[UITextField alloc]init];
    text.userInteractionEnabled = NO;
    text.borderStyle = UITextBorderStyleLine;
    text.layer.borderColor = [UIColor grayColor].CGColor;
    text.layer.borderWidth = 1.0f;
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgv.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(25);
        make.right.mas_equalTo(self.view.mas_right).offset(-25);
        make.height.mas_equalTo(50);
    }];
    self.vinCodeText = text;
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [sure setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(text.mas_bottom).offset(25);
        make.left.mas_equalTo(text.mas_left).offset(25);
        make.right.mas_equalTo(text.mas_right).offset(-25);
        make.height.mas_equalTo(60);
    }];
    
    [sure setBackgroundImage:[UIImage imageNamed:@"greenBj_332"] forState:UIControlStateNormal];
}

- (void)sureAction {
    if (![self.vinCode isKindOfClass:[NSString class]] || self.vinCode.length !=17) {
        [MBProgressHUD showError:@"VIN码未成功识别"];
        return;
    }
    
    if (self.idBlock) {
        self.idBlock(self.selectImg, self.vinCode, self.date);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSelectImg:(UIImage *)selectImg {
    _selectImg = selectImg;
    WEAKSELF
    [MBProgressHUD showLoading:@"正在识别..."];
    [[QLOSSManager shared] asyncUploadImage:selectImg complete:^(NSArray *names, UploadImageState state) {
        if (state == UploadImageSuccess) {
            NSString* imgName = [names firstObject];
            [QLNetworkingManager postWithUrl:SysPath params:@{
                Operation_type:@"get_vehicle_detail",
                @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                @"file_path":imgName
            } success:^(id response) {
                [MBProgressHUD immediatelyRemoveHUD];
                NSDictionary *info = response[@"result_info"];
                if ([info isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *detail = info[@"detail"];
                    NSString *vin = EncodeStringFromDic(detail, @"vin");
                    NSString *regStr = EncodeStringFromDic(detail, @"register_date");
                    weakSelf.vinCodeText.text = vin;
                    weakSelf.vinCode = vin;
                    weakSelf.date = regStr;
                    if (vin.length != 17) {
                        [MBProgressHUD showError:@"VIN码不足17位 识别失败"];
                    }

                }
            } fail:^(NSError *error) {
                [MBProgressHUD showError:error.domain];
            }];
        } else {
            [MBProgressHUD showError:@"图片上传失败"];
        }
    }];
}
@end
