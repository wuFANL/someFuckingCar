//
//  QLPicturesDetailViewController.m
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/1/25.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLPicturesDetailViewController.h"
#import "QLImageItem.h"
#import "QLFullScreenImgView.h"

@interface QLPicturesDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) QLBaseCollectionView *smallCollectionView;
@property (nonatomic, strong) UILabel *progressLB;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *btnArr;
@end

@implementation QLPicturesDetailViewController

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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //默认选中图片
    [self scrollByIndex:self.intoIndex];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //背景色
    self.showBackgroundView = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    //导航栏
    [self setNavi];
    //小图
    [self.view addSubview:self.smallCollectionView];
    [self.smallCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(120);
    }];
    //进度
    [self.view addSubview:self.progressLB];
    [self.progressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self.smallCollectionView.mas_top);
    }];
    //大图
    [self.view addSubview:self.bigScrollView];
    [self.bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.progressLB.mas_top);
    }];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //滚动层设置
    self.bigScrollView.contentSize = CGSizeMake(self.bigScrollView.width*self.imgsArr.count, self.bigScrollView.height);
    //大图布局
    for (UIButton *btn in self.btnArr) {
        NSInteger i = [self.btnArr indexOfObject:btn];
        btn.center = CGPointMake((i+0.5)*self.bigScrollView.width, self.bigScrollView.height*0.5);
        btn.size = CGSizeMake(self.view.width, self.view.width*(5.00/7.00));
    }
}
#pragma mark -setter
- (void)setImgsArr:(NSMutableArray *)imgsArr {
    _imgsArr = imgsArr;
    [self btnLayout];
}
#pragma mark -action
//大图点击
- (void)bigImgClick:(UIButton *)sender {
    QLFullScreenImgView *fsiView = [QLFullScreenImgView new];
    fsiView.img = sender.currentImage;
    [fsiView show];
}
//重新布局
- (void)btnLayout {
    //清除样式
    for (UIButton *btn in self.btnArr) {
        [btn removeFromSuperview];
    }
    [self.btnArr removeAllObjects];
    //新增图片
    for (int i = 0; i < self.imgsArr.count; i++) {
        id obj = self.imgsArr[i];
        QLBaseButton *btn = [QLBaseButton new];
        btn.tag = 100+i;
        btn.light = NO;
        btn.contentMode = UIViewContentModeScaleAspectFill;
        [btn addTarget:self action:@selector(bigImgClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([obj isKindOfClass:[UIImage class]]) {
            [btn setImage:obj forState:UIControlStateNormal];
        } else {
            [btn sd_setImageWithURL:[NSURL URLWithString:obj] forState:UIControlStateNormal];
        }
        [self.bigScrollView addSubview:btn];
        [self.btnArr addObject:btn];
    }
    [self.bigScrollView layoutIfNeeded];
    [self.bigScrollView setNeedsLayout];
    [self.smallCollectionView reloadData];
}
//删除图片
- (void)deleteItemClick {
    [UIAlertController showAlertController:UIAlertControllerStyleAlert Title:nil DetailTitle:@"是否确认删除该图片" DefaultTitle:@[@"确认"] CancelTitle:@"取消" Delegate:self DefaultAction:^(NSString *selectedTitle) {
        [self.imgsArr removeObjectAtIndex:self.currentIndex];
        //重新布局
        [self btnLayout];
        
        [self scrollByIndex:self.currentIndex];
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(imgDataChange:)]) {
            [self.delegate imgDataChange:self.imgsArr];
        }
    } CancelAction:^{
        
    }];
}
//下载图片
- (void)downloadItemClick {
    [UIAlertController showAlertController:UIAlertControllerStyleAlert Title:nil DetailTitle:@"是否确认下载该图片" DefaultTitle:@[@"确认"] CancelTitle:@"取消" Delegate:self DefaultAction:^(NSString *selectedTitle) {
        [MBProgressHUD showCustomLoading:nil];
        id obj = self.imgsArr[self.currentIndex];
        UIImage *saveImg = nil;
        if ([obj isKindOfClass:[UIImage class]]) {
            saveImg = obj;
            if (saveImg) {
                UIImageWriteToSavedPhotosAlbum(saveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            } else {
                [MBProgressHUD showError:@"图片不存在"];
            }
        } else {
            NSString *imgUrl = @"";
            if ([obj isKindOfClass:[NSString class]]) {
                imgUrl = obj;
            }
            if (imgUrl.length != 0) {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (!error) {
                        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                    } else {
                        [MBProgressHUD showError:@"图片保存失败"];
                    }
                }];
            } else {
                [MBProgressHUD showError:@"图片不存在"];
            }
        }

    } CancelAction:^{
        
    }];
    
}
//下载返回
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [MBProgressHUD showSuccess:@"图片保存成功"];
    } else {
        [MBProgressHUD showError:@"图片保存失败"];
    }
}

//导航栏设置
- (void)setNavi {
    self.navigationItem.title = @"照片浏览";
    NSMutableArray *items = [NSMutableArray array];
    if (self.showDeleteItem) {
        UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"delete_white"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemClick)];
        [items addObject:deleteItem];
    }
    if (self.showDownloadItem) {
        UIBarButtonItem *downloadItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"download_white"] style:UIBarButtonItemStyleDone target:self action:@selector(downloadItemClick)];
        [items addObject:downloadItem];
    }

    self.navigationItem.rightBarButtonItems = items;
}
#pragma mark -collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgsArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLImageItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseCell" forIndexPath:indexPath];
    cell.deleteBtn.hidden = YES;
    [cell roundRectCornerRadius:1 borderWidth:1 borderColor:ClearColor];
    if (self.currentIndex == indexPath.row) {
        [cell roundRectCornerRadius:1 borderWidth:1 borderColor:OrangeColor];
    }
    if (indexPath.row < self.imgsArr.count) {
        id obj = self.imgsArr[indexPath.row];
        if ([obj isKindOfClass:[UIImage class]]) {
            cell.imgView.image = obj;
        } else {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:obj]];
        }
    } else {
        cell.imgView.image = nil;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == self.smallCollectionView.tag) {
        [self scrollByIndex:indexPath.row];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bigScrollView) {
        CGFloat offX = scrollView.mj_offsetX;
        if (offX >= 0) {
            NSInteger index = offX/self.view.width;
            if (self.currentIndex != index) {
                [self scrollByIndex:index];
            }
            
        }
    }
}
- (void)scrollByIndex:(NSInteger)index {
    if (self.imgsArr.count <= index) {
        index = self.imgsArr.count-1;
    }
    if (self.imgsArr.count > 0) {
        UIButton *btn = self.btnArr[index];
        [self.bigScrollView scrollRectToVisible:btn.frame animated:NO];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.smallCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        NSInteger currentProgress = index+1;
        self.progressLB.text = [NSString stringWithFormat:@"%ld/%lu",(long)currentProgress,(unsigned long)self.imgsArr.count];
    } else {
         self.progressLB.text = [NSString stringWithFormat:@"%d/%lu",0,(unsigned long)self.imgsArr.count];
    }
    self.currentIndex = index;
    [self.smallCollectionView reloadData];
    [self.bigScrollView layoutIfNeeded];
    [self.bigScrollView setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
}
#pragma mark - Lazy
- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        _bigScrollView = [[UIScrollView alloc] init];
        _bigScrollView.backgroundColor = [UIColor blackColor];
        _bigScrollView.pagingEnabled = YES;
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.showsHorizontalScrollIndicator = NO;
        _bigScrollView.minimumZoomScale = 1.0;
        _bigScrollView.maximumZoomScale = 3.0;
        _bigScrollView.delegate = self;
        
    }
    return _bigScrollView;
}
- (UICollectionView *)smallCollectionView {
    if (!_smallCollectionView) {
        QLItemModel *model = [QLItemModel new];
        model.columnCount = 3;
        model.rowCount = 1;
        model.sectionInset = UIEdgeInsetsMake(15, 15, 15, 0);
        model.Spacing = QLMinimumSpacingMake(10, 10);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLImageItem";
        model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _smallCollectionView = [[QLBaseCollectionView alloc]initWithSize:CGSizeMake(ScreenWidth, 120) ItemModel:model];
        [_smallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _smallCollectionView.backgroundColor = [UIColor blackColor];
        _smallCollectionView.tag = 101;
        _smallCollectionView.pagingEnabled = YES;
        _smallCollectionView.delegate = self;
        _smallCollectionView.dataSource = self;
        
    }
    return _smallCollectionView;
}
- (UILabel *)progressLB {
    if (!_progressLB) {
        _progressLB = [UILabel new];
        _progressLB.font = [UIFont systemFontOfSize:13];
        _progressLB.textColor = WhiteColor;
    }
    return _progressLB;
}
- (NSMutableArray *)btnArr {
    if(!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}


@end
