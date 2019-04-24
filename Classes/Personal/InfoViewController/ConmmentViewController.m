//
//  ConmmentViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ConmmentViewController.h"
#import "TableViewCell.h"
#import "CommentListApi.h"
#import "CommentModel.h"
#import "ToCommentViewController.h"
@interface ConmmentViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *commentTableView;
@property (nonatomic,strong)NSMutableArray *commentListArr;
@property (nonatomic,strong)CommentListApi *commentApi;
@property (nonatomic, strong) TableViewCell *tempCell;

@end

static NSString *const commentCellIdentity = @"commentCellIdentity";

@implementation ConmmentViewController

- (NSMutableArray *)commentListArr
{
    
    if (!_commentListArr) {
        
        _commentListArr = [NSMutableArray array];
        
    }
    return _commentListArr;
    
}

- (CommentListApi *)commentApi
{

    if (!_commentApi) {
        
        _commentApi = [[CommentListApi alloc]init];
        _commentApi.delegate = self;
        
    }

    return _commentApi;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentTableView = [[UITableView alloc]init];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [self.view addSubview:_commentTableView];
    self.commentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.commentTableView registerClass:[TableViewCell class] forCellReuseIdentifier:commentCellIdentity];
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.mas_equalTo(0);
        
    }];
    
    __weak typeof(self) wself = self;
    self.commentTableView.mj_header = [QQWRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.commentApi refresh];
        
    }];
    
    self.commentTableView.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.commentApi loadNextPage];
    }];
    
    [self.commentTableView.mj_header beginRefreshing];

}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    
    [self.commentTableView.mj_footer resetNoMoreData];
    [self.commentTableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.commentTableView];
    
    if (api == _commentApi) {
        NSArray *array = (NSArray *)responsObject;
        
        if (array.count <= 0) {
            
            [[EmptyManager sharedManager] showEmptyOnView:self.commentTableView withImage:[UIImage imageNamed:@"orderList_empty"] explain:@"评论列表为空" operationText:@"" operationBlock:^{
                
                ToCommentViewController *toComment = [ToCommentViewController new];
                
                toComment.title = @"回复";
                [self.navigationController pushViewController:toComment animated:YES];
                
            }];
            
        } else {
            
            [self.commentListArr removeAllObjects];
            [self.commentListArr addObjectsFromArray:responsObject];
            [self.commentTableView reloadData];
            
        }
        
    }
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    
    [Utils postMessage:command.response.msg onView:self.view];
    [self.commentTableView.mj_header endRefreshing];
    
    if (self.commentListArr.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.commentTableView response:command.response operationBlock:^{
            strongify(self)
            [self.commentTableView.mj_header beginRefreshing];
        }];
    }
    
}


- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.commentTableView.mj_footer endRefreshing];
    
    [self.commentListArr addObjectsFromArray:responsObject];
    [self.commentTableView reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.commentTableView.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

  return self.commentListArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentity];
    CommentModel *commentModel = [_commentListArr objectAtIndex:indexPath.row];
    [cell.arctile_img sd_setImageWithURL:[NSURL URLWithString:commentModel.pic] placeholderImage:[UIHelper smallPlaceholder]];
    cell.arctile_content.text = commentModel.info;
    cell.nikeName.text = commentModel.nickname;
    cell.timeLabel.text = commentModel.create_time;
    cell.commentContent.text = commentModel.content;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:commentModel.face] placeholderImage:[UIHelper smallPlaceholder]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.commentBlock = ^(){
        
        ToCommentViewController *toComment = [ToCommentViewController new];
        toComment.arctile_id =commentModel.article_id;
        toComment.title = @"回复";
        [self.navigationController pushViewController:toComment animated:YES];
        
    };
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TableViewCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
    
}


@end
