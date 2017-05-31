//
//  AFNetClient.m
//  AFNetClient
//
//  Created by l.h on 14-9-23.
//  Copyright (c) 2014年 sibu. All rights reserved.
//

#import "AFNetClient.h"
#import "AFURLResponseSerialization.h"

@implementation AFNetClient

//单例  GCD
+ (instancetype)client
{
    static AFNetClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[AFNetClient alloc]init];
    });
    return client;
}


//get请求  无参数
+ (void)GET_Path:(NSString *)path completed:(HHSuccessBlock )successBlock failed:(HHFailedBlock )faileBlock
{
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10;

//    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //3.发送Get请求
  [manager  GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      successBlock(operation.responseData,responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      faileBlock(error);
//      [MBProgressHUD showMessage:@"网络连接失败，请重试!"];
  }];
}

//get请求  有参数
+(void)GET_Path:(NSString *)path  params:(NSDictionary *)params  completed:(HHSuccessBlock )successBlock failed:(HHFailedBlock )failed
{
    //1.获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //http://www.cocoachina.com/bbs/read.php?tid=176000
    //申明返回的结果是json类型
    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"text/javascript",nil];
    
    //    @"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css"
    
   [manager  GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
          successBlock(operation.responseData,responseObject);
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       failed(error);
   }];
}



//POST 无参数
+(void)POST_Path:(NSString *)path completed:(HHSuccessBlock)successBlock failed:(HHFailedBlock)failed
{
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 添加 text/html 类型到可接收内容类型中
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
   [manager  POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation.responseData,responseObject);
       
//       NSLog(@"-----------%@",operation.responseString);
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error);
//       [MBProgressHUD showMessage:@"网络连接失败，请重试!"];

   }];
}

//POST 无参数
+(void)POST_Path2:(NSString *)path completed:(HHSuccessBlock)successBlock failed:(HHFailedBlock)failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];

//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil]];
    
    [manager  POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation.responseData,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error);
    }];
}


//POST 请求有参数
+(void)POST_Path:(NSString *)path params:(id)paramsDic completed:(HHSuccessBlock)successBlock failed:(HHFailedBlock)failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    // 添加 text/html 类型到可接收内容类型中
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//    //如果报接受类型不一致请替换一致text/html或别的
//    //application/json, text/json
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", nil];
    [manager  POST:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation.responseData,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error);
    }];
}

//POST2 请求有参数
+(void)POST_Path2:(NSString *)path params:(id)paramsDic completed:(HHSuccessBlock)successBlock failed:(HHFailedBlock)failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];

    
    [manager  POST:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation.responseData,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error);
    }];
}

//文件下载
+(void)downloadFile:(NSString *)UrlAddress  completed:(HHSuccessBlock)successBlock failed:(HHFailedBlock)failed  progress:(HHSpeedBlock)progressBlock;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:UrlAddress]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *pdfName = @"The_PDF_Name_I_Want.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:pdfName];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filepath append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", [NSURL  URLWithString:filepath]);
        successBlock(operation.responseData,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(error);
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float  speed=(float)totalBytesRead / totalBytesExpectedToRead;
        NSLog(@"Download = %f", (float)totalBytesRead / totalBytesExpectedToRead);
        progressBlock(speed);
        
    }];
    [operation start];
}


#pragma mark---------以下一代码封装尚未测试-------
+(void)POST_Path:(NSString *)path arams:(NSDictionary *)paramsDi completed:(HHSuccessBlock)successBlock failed:(HHFailedBlock)failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo": @"bar"};
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    [manager POST:@"http://example.com/resources.json" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)dealloc
{
    NSLog(@"line<%d> %s release siglton",__LINE__,__func__);
}

@end
