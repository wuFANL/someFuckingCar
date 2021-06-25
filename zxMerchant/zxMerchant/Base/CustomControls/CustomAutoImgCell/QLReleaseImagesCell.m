//
//  QLReleaseImagesCell.m
//  BORDRIN
//
//  Created by 乔磊 on 2018/7/16.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLReleaseImagesCell.h"
#import "QLImageItem.h"
#import <TZImagePickerController.h>

@interface QLReleaseImagesCell()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
/**
 *图片数组
 */
@property (nonatomic, strong) NSMutableArray *imagesArr;
/**
 *当前控制器
 */
@property (nonatomic, strong) UIViewController<QLReleaseImagesCellDelegate> *currentVC;
@property (nonatomic, weak) QLBaseCollectionView *collectionView;
@end
@implementation QLReleaseImagesCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //默认添加图片
        self.addImg = [UIImage imageNamed:@"addImg"];
        //增加collectionView
        QLItemModel *model = [QLItemModel new];
        model.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        model.Spacing = QLMinimumSpacingMake(5, 5);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLImageItem";
        CGFloat itemWidth = (ScreenWidth-32*2-5*2)/3;
        model.itemSize = CGSizeMake(itemWidth, itemWidth);
        self.listStyleModel = model;
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPressGesture.minimumPressDuration = 0.1;
        [self.collectionView addGestureRecognizer:longPressGesture];
    }

    return self;
}
#pragma mark - setter
//设置collectionView样式
- (void)setListStyleModel:(QLItemModel *)listStyleModel {
    _listStyleModel= listStyleModel;
    //删除之前的collectionView
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    //重新设置collectionView
    QLBaseCollectionView *collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero ItemModel:listStyleModel];
    collectionView.backgroundColor = ClearColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.contentView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 32, 15, 32));
        make.height.mas_equalTo(listStyleModel.itemSize.width);
    }];
    self.collectionView = collectionView;
}
//设置添加图片
- (void)setAddImg:(UIImage *)addImg {
    _addImg = addImg;
    if (addImg) {
        if (self.imagesArr.count != 0) {
            self.imagesArr[0] = addImg;
        } else {
            [self.imagesArr addObject:addImg];
        }
        
        [self.collectionView reloadData];
    }
}
//图片设置
- (void)setSetImgArr:(NSMutableArray *)setImgArr {
    _setImgArr = setImgArr;
    [self.imagesArr removeAllObjects];
    [self.imagesArr addObject:self.addImg];
    if (self.setImgArr.count != 0) {
        [self.imagesArr addObjectsFromArray:setImgArr];
    }
    self.collectionView.dataArr = self.imagesArr;
    [self.collectionView reloadData];
    //改变collectionView高度
    [self imgChangeImpactHeight];
}
//设置当前控制器
- (void)setDelegate:(id<QLReleaseImagesCellDelegate>)delegate {
    _delegate = delegate;
    //代理设置
    self.currentVC = (UIViewController <QLReleaseImagesCellDelegate> *)delegate;
}
#pragma mark - action
//长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:self.collectionView];
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
            //移动过程中更新位置坐标
            [_collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            
            if (indexPath.row != self.imagesArr.count-1) {
                //停止移动调用此方法
                [_collectionView endInteractiveMovement];
            } else {
                //取消移动
                [_collectionView cancelInteractiveMovement];
            }
            
            break;
        default:
            //取消移动
            [_collectionView cancelInteractiveMovement];
            break;
    }
}
//获取图片的方式
- (void)chooseGetImgWay {
    if (!self.canMultipleChoice) {
        //单选
        [[QLToolsManager share] getPhotoAlbum:self.currentVC resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
            UIImage *img = info[UIImagePickerControllerOriginalImage];
            [self.imagesArr addObject:[UIImage simpleImage:img]];
            [self.collectionView reloadData];
            //改变collectionView高度
            [self imgChangeImpactHeight];
        }];
    } else {
        //多选
        [self getImgByMultipleChoice];
    }
    
}
//相册可以多选的获取图片方式
- (void)getImgByMultipleChoice {
    TZImagePickerController *ipVC = [[TZImagePickerController alloc]initWithMaxImagesCount:self.maxImgCount delegate:self];
    [ipVC.navigationBar setBackgroundImage:[UIImage createImageWithColor:GreenColor] forBarMetrics:UIBarMetricsDefault];
    ipVC.allowPickingVideo = NO;
    ipVC.allowTakeVideo = NO;
    [self.currentVC presentViewController:ipVC animated:YES completion:nil];
}
//TZImagePickerController图片获取
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (self.maxImgCount != 0&&(self.imagesArr.count+photos.count > self.maxImgCount+1)) {
       [MBProgressHUD showError:[NSString stringWithFormat:@"最多选择%ld张图片",(long)self.maxImgCount]];
       return;
   }
    [self.imagesArr addObjectsFromArray:[[photos reverseObjectEnumerator] allObjects]];
    [self.collectionView reloadData];
    //改变collectionView高度
    [self imgChangeImpactHeight];
}
//改变collectionView高度
- (void)imgChangeImpactHeight {
    CGFloat itemWidth = self.listStyleModel.itemSize.width;
    NSInteger row = self.imagesArr.count/3+(self.imagesArr.count%3>0&&self.imagesArr.count%3<=3?1:0);
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(row*itemWidth+(row-1)*5);
    }];
    //结果代理回调
    if (self.delegate) {
        NSMutableArray *resultArr = [NSMutableArray array];
        for (NSInteger i = self.imagesArr.count-1; i > 0; i--) {
            [resultArr addObject:self.imagesArr[i]];
        }
        if ([self.delegate respondsToSelector:@selector(imgChange:)]) {
            [self.delegate imgChange:resultArr];
        }
        
        if ([self.delegate respondsToSelector:@selector(imgChange:isCarPic:)]) {
            [self.delegate imgChange:resultArr isCarPic:self.isCarPic];
        }
        
    }
}
//删除图片
- (void)deleteBtnClick:(UIButton *)sender {
    [[QLToolsManager share] alert:@"您确定要删除吗?" handler:^(NSError *error) {
        if (!error) {
            UIImage *deleteImg = self.imagesArr[self.imagesArr.count-1-sender.tag];
            [self.imagesArr removeObject:deleteImg];
            [self.collectionView reloadData];
            [self imgChangeImpactHeight];
        }
    }];
}
#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLImageItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseCell" forIndexPath:indexPath];
    item.deleteBtn.tag = indexPath.row;
    item.imgView.image = self.imagesArr[self.imagesArr.count-1-indexPath.row];
    item.deleteBtn.hidden = indexPath.row == self.imagesArr.count-1?YES:NO;
    [item roundRectCornerRadius:3 borderWidth:1 borderColor:[UIColor clearColor]];
    [item.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QLImageItem *item = (QLImageItem *)[collectionView cellForItemAtIndexPath:indexPath];
    if (item.imgView.image == self.imagesArr[0]) {
        if (self.maxImgCount != 0&&(self.imagesArr.count == self.maxImgCount+1)) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"最多选择%ld张图片",(long)self.maxImgCount]];
            return;
        }
        //获取图片的方式
        [self chooseGetImgWay];
    } else {
        //结果代理回调
        if (self.delegate) {
            NSMutableArray *resultArr = [NSMutableArray array];
            for (NSInteger i = self.imagesArr.count-1; i > 0; i--) {
                [resultArr addObject:self.imagesArr[i]];
            }
            if ([self.delegate respondsToSelector:@selector(imgChange:)]) {
                [self.delegate imgChange:resultArr];
            }
            
            if ([self.delegate respondsToSelector:@selector(imgChange:isCarPic:)]) {
                [self.delegate imgChange:resultArr isCarPic:self.isCarPic];
            }
            if ([self.delegate respondsToSelector:@selector(imgClick:)]) {
                [self.delegate imgClick:indexPath.row];
            }
            
        }
        
    }
}
//能否移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == self.imagesArr.count-1?NO:YES;
}
//移动cell变化
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath.row != self.imagesArr.count-1) {
        NSInteger fromIndex = self.imagesArr.count- 1- sourceIndexPath.row;
        NSInteger toIndex = self.imagesArr.count- 1- destinationIndexPath.row;
        id objA = self.imagesArr[fromIndex];
        id objB = self.imagesArr[toIndex];
        [self.imagesArr replaceObjectAtIndex:fromIndex withObject:objB];
        [self.imagesArr replaceObjectAtIndex:toIndex withObject:objA];
    
    }
    [collectionView reloadData];
    //改变collectionView高度
    [self imgChangeImpactHeight];

}
#pragma mark - Lazy
- (NSMutableArray *)imagesArr {
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
