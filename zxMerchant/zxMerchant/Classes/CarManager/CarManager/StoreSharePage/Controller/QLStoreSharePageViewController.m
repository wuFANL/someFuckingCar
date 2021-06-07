//
//  QLStoreSharePageViewController.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/4/2.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLStoreSharePageViewController.h"
#import "QLShareAlertView.h"
#import "QLMyStoreViewController.h"
#import "QLStoreTextView.h"

@interface QLStoreSharePageViewController ()
@property (nonatomic, strong) QLShareAlertView *shareView;
@property (nonatomic, strong) QLStoreTextView *shareTxtView;
//分享类型 0:选车分享  1:分享店铺 2:分享车辆详情
@property (nonatomic, assign) NSInteger shareType;
@end

@implementation QLStoreSharePageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺分享";
    [self.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.isChooseCar?44:0);
    }];

}
#pragma mark- action
//微信分享
- (void)accBtnClick:(UIButton *)sender {
    QLCarInfoModel *model = self.dataArr[sender.tag];
    if (model) {
        self.chooseArr = [@[model] mutableCopy];
        //分享车辆文本
        WEAKSELF
        self.shareTxtView.contentTV.text = [NSString stringWithFormat:@"【上牌时间】 %@ \n【车辆信息】 %@ \n【行驶里程】%@万公里 \n【车辆排量] %.1fT \n【车辆价格】%@万 \n【联系方式】%@ \n【诚信车商】%@",model.production_year,model.model,model.driving_distance,[model.displacement floatValue],model.sell_price,[QLUserInfoModel getLocalInfo].account.mobile,[QLUserInfoModel getLocalInfo].account.nickname];
        self.shareTxtView.handler = ^(id result, NSError *error) {
            UMSocialPlatformType platformType = [result integerValue];
            
            [weakSelf share:platformType title:model.model desc:@"车辆详情" imgae:model.car_img];
        };
        [self.shareTxtView show];
        
    }
    
}
//选择
- (void)chooseBtnClick:(UIButton *)sender {
    NSInteger row = sender.tag;
    QLCarInfoModel *model = self.dataArr[row];
    if ([self.chooseArr containsObject:model]) {
        [self.chooseArr removeObject:model];
    } else {
        [self.chooseArr addObject:model];
    }
    [self.tableView reloadData];
}
//全选
- (void)numBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //全选
        self.chooseArr = [NSMutableArray arrayWithArray:self.dataArr];
    } else {
        //取消全选
        [self.chooseArr removeAllObjects];
    }
    [self.tableView reloadData];
}
//确定
- (void)submitBtnClick {
    if (self.chooseArr.count != 0) {
        self.shareView.descLB.text = [NSString stringWithFormat:@"%@向您推荐%lu辆好车,杜绝事故，精选优质--%@ 地址:%@",QLNONull([QLUserInfoModel getLocalInfo].account.nickname),(unsigned long)self.chooseArr.count,QLNONull([QLUserInfoModel getLocalInfo].business.business_name),QLNONull([QLUserInfoModel getLocalInfo].business.address)];
        [self.shareView.headImgView sd_setImageWithURL:[NSURL URLWithString:[QLUserInfoModel getLocalInfo].account.head_pic]];
        [self.shareView show];
    }
}
//分享
- (void)shareBtnClick:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"选车分享"]) {
        self.shareType = 0;
        self.isChooseCar = YES;
        [self.chooseArr removeAllObjects];
    } else {
        if ([sender.currentTitle isEqualToString:@"分享店铺"]) {
            self.shareType = 1;
            //分享我的店铺
           self.shareView.descLB.text = [NSString stringWithFormat:@"%@向您推荐好车,杜绝事故，精选优质--%@ 地址:%@",QLNONull([QLUserInfoModel getLocalInfo].account.nickname),QLNONull([QLUserInfoModel getLocalInfo].business.business_name),QLNONull([QLUserInfoModel getLocalInfo].business.address)];
           [self.shareView.headImgView sd_setImageWithURL:[NSURL URLWithString:[QLUserInfoModel getLocalInfo].account.head_pic]];
           [self.shareView show];
        } else {
            //取消
            self.isChooseCar = NO;
            [self.chooseArr removeAllObjects];
        }
    }
    self.submitBtn.hidden = !self.isChooseCar;
    [self.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.isChooseCar?44:0);
    }];
    [self.tableView reloadData];
}

- (void)share:(UMSocialPlatformType)platformType title:(NSString *)title desc:(NSString *)desc imgae:(id)image {
    NSMutableArray *car_id_list = [NSMutableArray array];
    for (QLCarInfoModel *model in self.chooseArr) {
        [car_id_list addObject:model.car_id];
    }
    //分享记录
    NSDictionary *dic = nil;
    if (self.shareType == 2) {
        dic = @{@"log_type":@"1002",@"about_id":[car_id_list componentsJoinedByString:@","]};
    } else {
        dic = @{@"log_type":@"1001",@"about_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id)};
    }
    [MBProgressHUD showCustomLoading:nil];
    [[QLToolsManager share] shareRecord:dic handler:^(id result, NSError *error) {
        [MBProgressHUD immediatelyRemoveHUD];
        NSString *share_id = @"";
        if (!error) {
            share_id = result[@"result_info"][@"share_id"];
        }
        //分享
        UMShareWebpageObject *webObj = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:image];
        NSString *shareUrl = @"";
        if (self.shareType == 0||self.shareType == 1) {
            shareUrl = [NSString stringWithFormat:@"http://%@/#/pages/%@?share_id=%@&id=%@&merchant_id=%@&flag=%@",WEB,self.shareType == 1?@"store/store":@"car-detail/car-detail",QLNONull(share_id),[car_id_list componentsJoinedByString:@","],[QLUserInfoModel getLocalInfo].account.account_id,[QLUserInfoModel getLocalInfo].account.flag];
            
        }
        webObj.webpageUrl = shareUrl;
        [[QLUMShareManager shareManager] shareToPlatformType:platformType shareObject:webObj currentVC:self];
    }];
}
#pragma mark- tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLCarPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.shareBtn.tag = indexPath.row;
    cell.showChooseBtn = self.isChooseCar;
    cell.chooseBtn.tag = indexPath.row;
    [cell.chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn addTarget:self action:@selector(accBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //选择变化
    QLCarInfoModel *model = self.dataArr[indexPath.row];
       cell.chooseBtn.selected = NO;
       for (QLCarInfoModel *chooseModel in self.chooseArr) {
           if ([model.car_id isEqualToString:chooseModel.car_id]) {
               cell.chooseBtn.selected = YES;
           }
       }
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isChooseCar) {
        QLCarPhotosCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.chooseBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [UIView new];
    //车数量
    QLBaseButton *numBtn = [QLBaseButton new];
    [numBtn setImage:self.isChooseCar?[UIImage imageNamed:@"noSelected"]:nil forState:UIControlStateNormal];
    [numBtn setImage:self.isChooseCar?[UIImage imageNamed:@"success"]:nil forState:UIControlStateSelected];
    NSString *numStr = [NSString stringWithFormat:@"  共%ld辆",(long)self.model.car_num.integerValue];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:numStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"]}];
    [numBtn setAttributedTitle:string forState:UIControlStateNormal];
    [numBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    numBtn.selected = self.dataArr.count==self.chooseArr.count&&self.dataArr.count!=0?YES:NO;
    [headView addSubview:numBtn];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.equalTo(headView).offset(16);
    }];
    //分享店铺
    QLBaseButton *moreBtn = [QLBaseButton new];
    [moreBtn roundRectCornerRadius:3 borderWidth:1 borderColor:ClearColor];
    [moreBtn setTitle:self.isChooseCar?@"取消":@"分享店铺" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [moreBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [moreBtn setBackgroundColor:GreenColor];
    [moreBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(-12);
        make.centerY.equalTo(headView);
        make.width.mas_equalTo([moreBtn.currentTitle widthWithFontSize:15]+20);
        
    }];
    
    //选车分享
    QLBaseButton *listBtn = [QLBaseButton new];
    [listBtn roundRectCornerRadius:3 borderWidth:1 borderColor:ClearColor];
    listBtn.hidden = self.isChooseCar;
    [listBtn setTitle:@"选车分享" forState:UIControlStateNormal];
    listBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [listBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [listBtn setBackgroundColor:GreenColor];
    [listBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:listBtn];
    [listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moreBtn.mas_left).offset(-12);
        make.centerY.equalTo(headView);
        make.width.mas_equalTo([listBtn.currentTitle widthWithFontSize:15]+20);
    }];
    
    
    
    
    return headView;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isChooseCar;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}
#pragma mark- lazyLoading
- (QLShareAlertView *)shareView {
    if(!_shareView) {
        _shareView = [QLShareAlertView new];
        WEAKSELF
        _shareView.handler = ^(id result, NSError *error) {
            UMSocialPlatformType platformType = [result integerValue];
            
            [weakSelf share:platformType title:weakSelf.shareView.descLB.text desc:@"店铺分享" imgae:weakSelf.shareView.headImgView.image];

        };
    }
    return _shareView;
}
- (QLStoreTextView *)shareTxtView {
    if (!_shareTxtView) {
        _shareTxtView = [QLStoreTextView new];
    }
    return _shareTxtView;
}
@end
