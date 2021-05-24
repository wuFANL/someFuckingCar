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

@interface QLStoreSharePageViewController ()
@property (nonatomic, strong) QLShareAlertView *shareView;
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
        //分享车辆详情
        self.shareType = 2;
        self.shareView.descLB.text = [NSString stringWithFormat:@"%@--%@ 地址:%@",QLNONull(model.model),QLNONull([QLUserInfoModel getLocalInfo].account.nickname),QLNONull([QLUserInfoModel getLocalInfo].business.address)];
        [self.shareView.headImgView sd_setImageWithURL:[NSURL URLWithString:model.car_img]];
        [self.shareView show];
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
        self.shareView.descLB.text = [NSString stringWithFormat:@"%@向您推荐%lu辆好车--%@ 地址:%@",QLNONull([QLUserInfoModel getLocalInfo].account.nickname),(unsigned long)self.chooseArr.count,QLNONull([QLUserInfoModel getLocalInfo].business.business_name),QLNONull([QLUserInfoModel getLocalInfo].business.address)];
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
           self.shareView.descLB.text = [NSString stringWithFormat:@"%@向您推荐好车--%@ 地址:%@",QLNONull([QLUserInfoModel getLocalInfo].account.nickname),QLNONull([QLUserInfoModel getLocalInfo].business.business_name),QLNONull([QLUserInfoModel getLocalInfo].business.address)];
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
#pragma mark- tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLCarPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.showChooseBtn = self.isChooseCar;
    cell.chooseBtn.tag = indexPath.row;
    [cell.chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //分享按钮
    cell.accessoryView = nil;
    if (!self.isChooseCar) {
        QLBaseButton *accBtn = [[QLBaseButton alloc] initWithFrame:CGRectMake(0, 0, 52, 20)];
        accBtn.tag = indexPath.row;
        [accBtn addTarget:self action:@selector(accBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [accBtn setImage:[UIImage imageNamed:@"wxShare"] forState:UIControlStateNormal];
        cell.accessoryView = accBtn;
    }
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
            
            NSMutableArray *car_id_list = [NSMutableArray array];
            for (QLCarInfoModel *model in weakSelf.chooseArr) {
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
                UMShareWebpageObject *webObj = [UMShareWebpageObject shareObjectWithTitle:weakSelf.shareView.descLB.text descr:@"店铺分享" thumImage:weakSelf.shareView.headImgView.image];
                NSString *shareUrl = @"";
                if (self.shareType == 0) {
                    shareUrl = [NSString stringWithFormat:@"%@/store_details.html?merchant_id=%@&member_sub_id=%@&id=%@&share_id=%@",UrlPath,QLNONull([QLUserInfoModel getLocalInfo].business.business_id),QLNONull([QLUserInfoModel getLocalInfo].account.account_id),[car_id_list componentsJoinedByString:@","],share_id];
                } else if (self.shareType == 2) {
                    shareUrl = [NSString stringWithFormat:@"%@/car_detail.html?merchant_id=%@&member_sub_id=%@&car_id=%@&share_id=%@",UrlPath,[QLUserInfoModel getLocalInfo].business.business_id,[QLUserInfoModel getLocalInfo].account.account_id,[car_id_list componentsJoinedByString:@","],share_id];
                } else {
                    shareUrl = [NSString stringWithFormat:@"%@/personal_stores.html?merchant_id=%@&member_sub_id=%@&share_id=%@",UrlPath,[QLUserInfoModel getLocalInfo].business.business_id,[QLUserInfoModel getLocalInfo].account.account_id,share_id];
                }
                webObj.webpageUrl = shareUrl;
                [[QLUMShareManager shareManager] shareToPlatformType:platformType shareObject:webObj currentVC:weakSelf];
            }];
            
        };
    }
    return _shareView;
}
@end
