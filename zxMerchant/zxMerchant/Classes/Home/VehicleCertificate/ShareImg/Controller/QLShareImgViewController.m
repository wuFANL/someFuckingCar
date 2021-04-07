//
//  QLShareImgViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/25.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLShareImgViewController.h"
#import "QLShareImgBottomView.h"
#import "QLShareImgItem.h"
#import "QLPicturesDetailViewController.h"
#import "QLShareAlertView.h"


@interface QLShareImgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, strong) QLShareImgBottomView *bottomView;
@property (nonatomic, strong) NSString *merchant_url;
@property (nonatomic, strong) QLShareAlertView *shareView;
@property (nonatomic, strong) NSMutableArray *chooseArr;

@end

@implementation QLShareImgViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor groupTableViewBackgroundColor]]];
    [self.navigationController.navigationBar setTintColor:[UIColor darkTextColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择图片";
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(44);
    }];
    //collectionView
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    //长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGesture.minimumPressDuration = 0.1;
    [self.collectionView addGestureRecognizer:longPressGesture];
    //多图分享
    if (self.type == 1) {
        [self getCarAttr];
    }
}
#pragma mark -network
- (void)getCarAttr {
//    NSMutableArray *car_id_s = [NSMutableArray array];
//    for (QLCarInfoModel *model in self.carInfoArr) {
//        if (model) {
//            [car_id_s addObject:model.car_id];
//        }
//    }
//    NSString *carIdsStr = [car_id_s componentsJoinedByString:@","];
//    [MBProgressHUD showCustomLoading:nil];
//    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_car_attr_list",@"car_id_s":QLNONull(carIdsStr),@"type":car_id_s.count>=2?@"1":@"-2"} success:^(id response) {
//        [self.imgsArr removeAllObjects];
//        //车辆图片
//        [self.imgsArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[QLCarBannerModel class] json:response[@"result_info"][@"attr_list"]]];
//        //记录分享
//        [[QLToolsManager share] shareRecord:@{@"log_type":@"1002",@"about_id":QLNONull(carIdsStr)} handler:^(id result, NSError *error) {
//             [MBProgressHUD immediatelyRemoveHUD];
//            if (!error) {
//                NSString *share_id = result[@"result_info"][@"share_id"];
//                //店铺二维码
//                if ([QLUserInfoModel getLocalInfo].merchant_staff.merchant_url.length != 0) {
//                    self.merchant_url = [NSString stringWithFormat:@"%@&share_id=%@&id=%@&merchant_id=%@&member_sub_id=%@",[QLUserInfoModel getLocalInfo].merchant_staff.merchant_url,QLNONull(share_id),carIdsStr,[QLUserInfoModel getLocalInfo].merchant_staff.member_id,[QLUserInfoModel getLocalInfo].merchant_staff.sub_id];
//                    UIImage *codeImg = [UIImage generateQRCodeWithString:self.merchant_url Size:88];
//                    if (codeImg) {
//                        if (self.imgsArr.count >= 5) {
//                            [self.imgsArr insertObject:codeImg atIndex:4];
//                        } else {
//                            [self.imgsArr addObject:codeImg];
//                        }
//
//                    }
//                }
//                [self.collectionView reloadData];
//            }
//        }];
//    } fail:^(NSError *error) {
//        [MBProgressHUD showError:error.domain];
//    }];
}
#pragma mark -action
//图片合成
- (UIImage *)pictureSynthesis {
    CGFloat cellSpace = 10;
    CGFloat margin = 5;
    CGFloat imgWidth = 100;
    CGFloat picWidth = cellSpace*2+imgWidth*3+margin*2;
    CGSize size = CGSizeMake(picWidth,picWidth);

    UIGraphicsBeginImageContextWithOptions(size, NO,[UIScreen mainScreen].scale);
    //黑背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, picWidth, picWidth)];
    [[UIColor blackColor] setFill];
    [path fill];
    //绘制图片
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:self.chooseArr];
    [temArr sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2];//升序
    }];
    for (int i = 0; i < temArr.count; i++) {
        NSInteger index = [temArr[i] integerValue];
        QLShareImgItem *cell = (QLShareImgItem *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        NSInteger row = i/3;
        NSInteger column = i%3;
        CGRect imgRect = CGRectMake(column*imgWidth+column*cellSpace+margin, row*imgWidth+row*cellSpace+margin, imgWidth, imgWidth);
        [[self convertViewToImage:cell.imgView] drawInRect:imgRect];
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
//截图
- (UIImage *)convertViewToImage:(UIView*)v {
    CGSize s = v.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//选择按钮
- (void)chooseBtnClick:(UIButton *)sender {
    NSInteger row = sender.tag;
    if ([self.chooseArr containsObject:@(row)]) {
        [self.chooseArr removeObject:@(row)];
    } else {
        if (self.chooseArr.count >= 9) {
            [MBProgressHUD showError:@"最多选择9张图片"];
            return;
        }
        [self.chooseArr addObject:@(row)];
    }
    [self.collectionView reloadData];
    
}
//下载
- (void)downloadBtnClick {
    if (self.chooseArr.count != 0) {
        QLCustomAlertView *alert =[[QLCustomAlertView alloc]init];
        alert.title = @"请先下载图片";
        alert.result = ^(id result, NSError *error) {
            if (!error) {
                NSMutableArray *temArr = [NSMutableArray array];
                for (NSNumber *chooseIndex in self.chooseArr) {
                    NSInteger row = chooseIndex.integerValue;
                    QLShareImgItem *item = (QLShareImgItem *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
                    [temArr addObject:item.imgView.image];
                }
                [[QLSaveImgManager share] saveImgs:temArr complete:^(id result, NSError *error) {
                    if (!error) {
                        [MBProgressHUD showSuccess:@"图片保存成功"];
                        [self performSelector:@selector(openWX) withObject:nil afterDelay:HUDDefaultShowTime];
                    } else {
                        [MBProgressHUD showError:@"图片保存失败"];
                    }
                }];
            }
        };
        [alert show];
    } else {
        [MBProgressHUD showError:@"请选择图片"];
    }
}
//分享
- (void)shareBtnClick {
    if (self.type == 1) {
        if (self.chooseArr.count == 0) {
            [MBProgressHUD showError:@"请选择分享图片"];
            return;
        }
        
//        self.shareView.descLB.text = [NSString stringWithFormat:@"%@向您推荐%lu辆好车--%@ 地址:%@",QLNONull([QLUserInfoModel getLocalInfo].merchant_staff.sub_name),(unsigned long)self.chooseArr.count,QLNONull([QLUserInfoModel getLocalInfo].merchant_staff.member_name),QLNONull([QLUserInfoModel getLocalInfo].merchant_staff.address)];
//        [self.shareView.headImgView sd_setImageWithURL:[NSURL URLWithString:[QLUserInfoModel getLocalInfo].merchant_staff.head_pic]];
         self.shareView.tag = 0;
        [self.shareView show];
    } else {
        
        //下载图片
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int i = 0; i < self.chooseArr.count; i++) {
            NSInteger index = [self.chooseArr[i] integerValue];
            QLShareImgItem *cell = (QLShareImgItem *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            [imgArr addObject:cell.imgView.image];
        }
        if (imgArr) {
            [[QLSaveImgManager share] saveImgs:imgArr complete:^(id result, NSError *error) {
                if (!error) {
                    [MBProgressHUD showSuccess:@"图片保存成功"];
                    [self performSelector:@selector(openWX) withObject:nil afterDelay:HUDDefaultShowTime];
                } else {
                    [MBProgressHUD showError:@"图片保存失败"];
                }
            }];
        } else {
            [MBProgressHUD showError:@"暂无图片"];
        }
        
        
    }
}
- (void)openWX {
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen) {
        //打开微信
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [MBProgressHUD showError:@"您的设备未安装微信APP"];
    }
}
//长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:_collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    //根据长按手势的状态进行处理。
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            //当没有点击到cell的时候不进行处理
            if (!indexPath) {
                break;
            }
            //开始移动
            [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        case UIGestureRecognizerStateChanged:
            //取消选择
            for (int i = 0; i < self.chooseArr.count; i++) {
                NSInteger index = [self.chooseArr[i] integerValue];
                QLShareImgItem *cell = (QLShareImgItem *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
                cell.chooseBtn.selected = NO;
            }
            [self.chooseArr removeAllObjects];
            //移动过程中更新位置坐标
            [_collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            //停止移动调用此方法
            [_collectionView endInteractiveMovement];
            break;
        default:
            //取消移动
            [_collectionView cancelInteractiveMovement];
            break;
    }
}
#pragma mark -collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLShareImgItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseCell" forIndexPath:indexPath];
    cell.chooseBtn.tag = indexPath.row;
    [cell.chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.chooseBtn.selected = [self.chooseArr containsObject:@(indexPath.row)]?YES:NO;
    id value = self.imgsArr[indexPath.row];
    
//    if ([value isKindOfClass:[QLCarBannerModel class]]) {
//        QLCarBannerModel *model = value;
//        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
//    } else
    
    if ([value isKindOfClass:[UIImage class]]) {
        cell.imgView.image = value;
    }

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QLShareImgItem *cell = (QLShareImgItem *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.chooseBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.view.width, 0.01);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeZero;
}
//能否移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//移动cell变化
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    NSInteger fromIndex = sourceIndexPath.row;
    id objA = self.imgsArr[fromIndex];
    [self.imgsArr removeObjectAtIndex:fromIndex];
    NSInteger toIndex = destinationIndexPath.row;
    [self.imgsArr insertObject:objA atIndex:toIndex];
    [self.collectionView reloadData];
    
}
#pragma mark -lazyLoading
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.columnCount = 3;
        model.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        model.Spacing = QLMinimumSpacingMake(15, 15);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLShareImgItem";
        CGFloat width = (ScreenWidth-(model.columnCount+1)*15)/model.columnCount;
        model.itemSize = CGSizeMake(width, width);
        _collectionView = [[QLBaseCollectionView alloc]initWithSize:CGSizeMake(self.view.width, self.view.height-44) ItemModel:model];
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}
- (QLShareImgBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLShareImgBottomView new];
        if (self.type == 0) {
            _bottomView.downloadBtnWidth.constant = 0;
            _bottomView.downloadBtn.hidden = YES;
        } else {
            _bottomView.downloadBtnWidth.constant = self.view.width*0.5;
            _bottomView.downloadBtn.hidden = NO;
        }
        [_bottomView.downloadBtn addTarget:self action:@selector(downloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (QLShareAlertView *)shareView {
    if(!_shareView) {
        _shareView = [QLShareAlertView new];
        WEAKSELF
        _shareView.handler = ^(id result, NSError *error) {
            UMSocialPlatformType platformType = [result integerValue];
            UMShareObject *obj = nil;
            NSString *title = weakSelf.shareView.descLB.text;
            NSString *des = @"店铺分享";
            UIImage *thumImage = weakSelf.shareView.headImgView.image;
            if (self.type == 1) {
                if (weakSelf.shareView.tag == 0) {
                    //分享点击，分享图片
                    UMShareImageObject *imgObj = [UMShareImageObject shareObjectWithTitle:title descr:des thumImage:thumImage];
                    imgObj.shareImage = [weakSelf pictureSynthesis];
                    obj = imgObj;
                } else {
                    //下载点击
                    if (platformType == UMSocialPlatformType_WechatTimeLine) {
                        //朋友圈分享图片
                        UMShareImageObject *imgObj = [UMShareImageObject shareObjectWithTitle:title descr:des thumImage:thumImage];
                        imgObj.shareImage = [weakSelf pictureSynthesis];
                        obj = imgObj;
                    } else {
                        //分享文本
                        UMSocialMessageObject *txtObj = [UMSocialMessageObject messageObject];
                        txtObj.text = title;
                        [[QLUMShareManager shareManager] shareToPlatformType:platformType messageObject:txtObj currentVC:weakSelf];
                    }
                    
                }
                
            } else {
                //分享网址
                UMShareWebpageObject *webObj = [UMShareWebpageObject shareObjectWithTitle:title descr:des thumImage:thumImage];
                webObj.webpageUrl = weakSelf.merchant_url;
                obj = webObj;
            }
            //分享
            if (obj) {
                [[QLUMShareManager shareManager] shareToPlatformType:platformType shareObject:obj currentVC:weakSelf];
            }
            
        };
    }
    return _shareView;
}
- (NSMutableArray *)imgsArr {
    if (!_imgsArr) {
        _imgsArr = [NSMutableArray array];
    }
    return _imgsArr;
}
- (NSMutableArray *)chooseArr {
    if (!_chooseArr) {
        _chooseArr = [NSMutableArray array];
    }
    return _chooseArr;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
