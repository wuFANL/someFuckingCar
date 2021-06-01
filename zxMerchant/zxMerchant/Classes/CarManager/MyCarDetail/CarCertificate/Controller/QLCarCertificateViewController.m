//
//  QLCarCertificateViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/15.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCertificateViewController.h"
#import "QLSubmitBottomView.h"
#import "QLShareImgItem.h"
#import <TZImagePickerController.h>
#import "QLPicturesDetailViewController.h"

@interface QLCarCertificateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, strong) QLSubmitBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *imgsArr;
@property (nonatomic, assign) NSInteger maxImgCount;

@end

@implementation QLCarCertificateViewController

-(id)initWithArray:(NSArray *)ar {
    self = [super init];
    if(self) {
        self.imgsArr = [[NSMutableArray alloc] initWithCapacity:0];
        [ar enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.imgsArr addObject:[obj objectForKey:@"pic_url"]];
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑牌证";
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
    
}
#pragma mark - action
//保存
- (void)saveBtnClick {
    //组装参数
    if(self.imgsArr && [self.imgsArr count] > 0)
    {
        __block NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
        [self.imgsArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dic setObject:@"证件照片" forKey:@"detecte_total_name"];
            [dic setObject:@"" forKey:@"detail_name"];
            [dic setObject:obj forKey:@"image_path"];
            [ar addObject:dic];
        }];
        
        
        [MBProgressHUD showCustomLoading:@""];
        [QLNetworkingManager postWithUrl:BasePath params:@{@"operation_type":@"submit_car_img_data",@"check_id":self.carID,@"staff_id":[QLUserInfoModel getLocalInfo].account.account_id,@"img_data":[ar yy_modelToJSONString]} success:^(id response) {
            [MBProgressHUD immediatelyRemoveHUD];
            
            [MBProgressHUD showSuccess:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } fail:^(NSError *error) {
            [MBProgressHUD showError:error.domain];
        }];
    }
}
//TZImagePickerController图片获取
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {

    [MBProgressHUD showCustomLoading:@""];
    [[QLOSSManager shared] syncUploadImages:photos complete:^(NSArray *names, UploadImageState state) {
        [MBProgressHUD immediatelyRemoveHUD];
        if (state == UploadImageSuccess) {
            [self.imgsArr addObjectsFromArray:names];
            [self.collectionView reloadData];
        } else {
            [MBProgressHUD showError:@"图片上传失败"];
        }
    }];
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
            if (!indexPath||indexPath.row == self.imgsArr.count) {
                break;
            }
            //开始移动
            [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程中更新位置坐标
            [_collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            if (indexPath.row == self.imgsArr.count) {
                [_collectionView cancelInteractiveMovement];
            }
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
    return self.imgsArr.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLShareImgItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseCell" forIndexPath:indexPath];
    cell.chooseBtn.hidden = YES;
    if (indexPath.row == self.imgsArr.count) {
        cell.imgView.image = [UIImage imageNamed:@"addImage"];
    } else {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgsArr[indexPath.row]]];
    }


    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.imgsArr.count) {
        TZImagePickerController *ipVC = [[TZImagePickerController alloc]initWithMaxImagesCount:self.maxImgCount delegate:self];
        [ipVC.navigationBar setBackgroundImage:[UIImage createImageWithColor:GreenColor] forBarMetrics:UIBarMetricsDefault];
        ipVC.allowPickingVideo = NO;
        ipVC.allowTakeVideo = NO;
        [self presentViewController:ipVC animated:YES completion:nil];
    } else {
        QLPicturesDetailViewController *pdVC = [QLPicturesDetailViewController new];
        pdVC.showDeleteItem = YES;
        pdVC.imgsArr = self.imgsArr;
        pdVC.intoIndex = indexPath.row;
        [self.navigationController pushViewController:pdVC animated:YES];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        UILabel *label = [[UILabel alloc] init];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"请上传正确的牌证照片(长按图片拖动排序)" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size: 13], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]} range:NSMakeRange(10, 10)];
        label.attributedText = attStr;
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(15);
        }];
        return headerView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.view.width, 40);
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
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.columnCount = 4;
        model.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        model.Spacing = QLMinimumSpacingMake(5, 5);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLShareImgItem";
        CGFloat width = (ScreenWidth-(model.columnCount-1)*5-15*2)/model.columnCount;
        model.itemSize = CGSizeMake(width, width*(54.0/80.0));
        _collectionView = [[QLBaseCollectionView alloc]initWithSize:CGSizeMake(self.view.width, self.view.height-44) ItemModel:model];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (NSMutableArray *)imgsArr {
    if (!_imgsArr) {
        _imgsArr = [NSMutableArray array];
    }
    return _imgsArr;
}
@end
