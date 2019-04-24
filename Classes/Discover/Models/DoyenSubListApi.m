//
//  DoyenSubListApi.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenSubListApi.h"
#import "DoyenListItem.h"

@interface DoyenSubListApi ()

@property (nonatomic, copy) NSString *doyen_type;

@end

@implementation DoyenSubListApi

- (id)initWithDoyenType:(NSString *)doyen_type {
    if (self = [super init]) {
        self.doyen_type = doyen_type;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = @{@"doyen_type": self.doyen_type ?: @""};
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{@"doyen_type": self.doyen_type ?: @""};
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = APIURL(@"/butler-doyen/list");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *jsonArray = responseObject[@"list"];
    return [DoyenItem mj_objectArrayWithKeyValuesArray:jsonArray];
}

@end
