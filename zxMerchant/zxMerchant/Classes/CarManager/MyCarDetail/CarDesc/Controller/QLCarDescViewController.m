//
//  QLCarDescViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/15.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLCarDescViewController.h"
#import "QLUpdateVedioCell.h"
#import "QLCarDescTypeCell.h"
#import <AVKit/AVKit.h>
#import <TZImagePickerController.h>
@interface QLCarDescViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet QLBaseTableView *tableView;
@property (nonatomic, strong) QLBaseTextView *tv;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (nonatomic, strong) NSMutableDictionary *videoDic;

@property (nonatomic, strong) NSMutableDictionary *sourceDic;
@property (nonatomic, strong) NSString *chooseTag;
@end

@implementation QLCarDescViewController

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self) {
        self.sourceDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [self.sourceDic addEntriesFromDictionary:dic];
        self.chooseTag = @"";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.title = @"车辆描述";
    //tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLUpdateVedioCell" bundle:nil] forCellReuseIdentifier:@"uploadCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDescTypeCell" bundle:nil] forCellReuseIdentifier:@"typeCell"];
}
#pragma mark - network
//提交信息
- (void)submitInfoRequest:(NSString *)videoUrl {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:VehiclePath params:@{@"operation_type":@"save_car_desc",@"car_desc":self.tv.text.length>0?self.tv.text:@"",
                                                          @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                                                          @"car_id":self.carID,
                                                          @"car_video":videoUrl,
                                                          @"flag_type":self.chooseTag
    } success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        
        [MBProgressHUD showSuccess:@"保存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//上传视频
- (void)uploadControlClick {
    if (self.videoDic[@"asset"]==nil&&self.car_video.length != 0) {
        NSURL *url = [NSURL URLWithString:self.car_video];
        //预览视频
        AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:url];
        //监听状态属性
        [avPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        self.playerVC.player = avPlayer;
        [self presentViewController:self.playerVC animated:YES completion:nil];
    } else {
        PHAsset *asset = self.videoDic[@"asset"];
        if (!asset) {
            //选择视频
            TZImagePickerController *ipVC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
            [ipVC.navigationBar setBackgroundImage:[UIImage createImageWithColor:GreenColor] forBarMetrics:UIBarMetricsDefault];
            ipVC.allowPickingImage = NO;
            [self presentViewController:ipVC animated:YES completion:nil];
        } else {
            //预览视频
            [[TZImageManager manager] getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
                AVPlayer *avPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
                AVPlayerViewController *playerVC =[[AVPlayerViewController alloc] init];
                playerVC.player = avPlayer;
                [self presentViewController:playerVC animated:YES completion:nil];
            }];
        }
    }
}
//获取视频代理
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    if (coverImage) {
        self.videoDic[@"coverImage"] = coverImage;
        self.videoDic[@"asset"] = asset;
    }
    [self.tableView reloadData];
}
//删除
- (void)deleteBtnClick {
    PHAsset *asset = self.videoDic[@"asset"];
    if (asset||self.car_video.length!=0) {
        [[QLToolsManager share] alert:@"您确认删除该视频?" handler:^(NSError *error) {
            if (!error) {
                self.car_video = @"";
                self.videoDic = nil;
                [self.tableView reloadData];
            }
        }];
    } else {
        [MBProgressHUD showError:@"请先选择视频"];
    }
    
}
//保存
- (IBAction)saveBtnClick:(id)sender {
    if (self.tv.text.length == 0) {
        [MBProgressHUD showError:@"请输入车辆描述"];
        return;
    }
    [MBProgressHUD showCustomLoading:nil];
    PHAsset *asset = self.videoDic[@"asset"];
    if (asset) {
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            //视频
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                NSURL *videoURL = urlAsset.URL;
                NSLog(@"%@",videoURL.absoluteString);
                NSString *filePath = [videoURL.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                [[QLOSSManager shared] uploadFile:filePath complete:^(NSArray *names, UploadImageState state) {
                    if (state == UploadImageSuccess) {
                        [self submitInfoRequest:names.count==0?@"":names.firstObject];
                    } else {
                        [MBProgressHUD showError:@"视频上传失败"];
                    }
                }];
            }];
        } else {
            [MBProgressHUD showError:@"请选择视频上传"];
        }
    } else {
        [self submitInfoRequest:self.car_video];
    }
}

//输入框
- (void)textViewDidChange:(UITextView *)textView {
    
}

//监听播放状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"准备好播放");
            [self.playerVC.player play];
        }
    }
}
#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?2:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!self.tv) {
                QLBaseTextView *tv = [QLBaseTextView new];
                tv.tag = 100+indexPath.row;
                tv.text = [self.sourceDic objectForKey:@"car_desc"];
                tv.countLimit = 100;
                NSString *str = [self.sourceDic objectForKey:@"car_desc"];
                self.tv.constraintLB.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)str.length];
                tv.delegate = self;
                self.tv = tv;
            }

            [cell.contentView addSubview:self.tv];
            [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(5, 15, 5, 15));
            }];
            return cell;
        } else {
            QLUpdateVedioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uploadCell" forIndexPath:indexPath];
            [cell.uploadControl addTarget:self action:@selector(uploadControlClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
            if (self.videoDic[@"asset"] == nil&&self.car_video.length != 0) {
                cell.uploadImgView.image = [UIImage videoFramerateWithPath:self.car_video];
            } else {
                UIImage *coverImg = self.videoDic[@"coverImage"];
                cell.uploadImgView.image = coverImg==nil?[UIImage imageNamed:@"uploadImg"]:coverImg;
            }
            
            return cell;
        }
    } else {
        QLCarDescTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell" forIndexPath:indexPath];
        
        int tag = [[self.sourceDic objectForKey:@"flag_type"] intValue];
        cell.handler = ^(id result) {
            NSNumber *res = result;
            NSInteger index = res.integerValue;
            
            self.chooseTag =index ==0?@"103":@"105";
        };
        
        //105=低首付推荐，103=新上架推荐
        if(tag == 105)
        {
            [cell typeBtnClick:cell.bBtn];
        }
        else if (tag ==  103)
        {
            [cell typeBtnClick:cell.aBtn];
        }
        else
        {
            cell.bBtn.selected = NO;
            cell.aBtn.selected = NO;
        }

        
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==1) {
        UIView *headerView =[UIView new];
        headerView.backgroundColor = WhiteColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"车辆推荐\r\n勾选后将车辆推荐到分发公众号首页的首付最低和新上架位置" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size: 16],NSForegroundColorAttributeName:[UIColor blackColor]}];
        [string addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size: 13], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:NSMakeRange(4, 1)];
        [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 10], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(5, string.length-5)];
        label.attributedText = string;
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(15);
            make.centerY.equalTo(headerView);
        }];
        
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?0.01:44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (void)dealloc {
    [self.playerVC.player.currentItem removeObserver:self forKeyPath:@"status"];
}
#pragma mark - Lazy
- (AVPlayerViewController *)playerVC {
    if (!_playerVC) {
        _playerVC = [[AVPlayerViewController alloc] init];
    }
    return _playerVC;
}
- (NSMutableDictionary *)videoDic {
    if (!_videoDic) {
        _videoDic = [NSMutableDictionary dictionary];
    }
    return _videoDic;
}


@end
