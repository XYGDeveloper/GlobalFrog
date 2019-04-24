//
//  UpdownLoadMutibleImageApi.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/10.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "UpdownLoadMutibleImageApi.h"

@implementation UpdownLoadMutibleImageApi

- (void)uploadImage:(UIImage *)image
{

        [self startRequestWithParams:nil multipart:^(id<AFMultipartFormData> multipartBlock) {
            if (image) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filePath = [NSString stringWithFormat:@"%@/%f.jpg", path, [[NSDate date] timeIntervalSince1970]];
                [imageData writeToFile:filePath atomically:YES];
                NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
                [multipartBlock appendPartWithFileURL:fileUrl name:@"file" error:nil];
            }
            
        }];
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/user-main/upload");
    return command;
    
}

- (id)reformData:(id)responseObject {
    return responseObject[@"file_url"];
}

@end
