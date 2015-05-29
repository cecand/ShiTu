//
//  MCDianpingMapResult.m
//  mycity
//
//  Created by openapp on 15/5/28.
//  Copyright (c) 2015年 openapp. All rights reserved.
//

#import "MCDianpingMapResult.h"
#import "AFNetworking.h"

@implementation MCDianpingMapResult

+ (NSString *)extractNode:(NSString *)nodeName fromXml:(NSString *)xml  {
    NSString *reg = [NSString stringWithFormat:@"<%@><!\\[CDATA\\[(.*?)\\]\\]><\\/%@>", nodeName, nodeName];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg options:0 error:NULL];
    NSTextCheckingResult *newSearchString = [regex firstMatchInString:xml options:0 range:NSMakeRange(0, [xml length])];
    return [xml substringWithRange:[newSearchString rangeAtIndex:1]];
}

- (void)getInfoWithGPS:(CLLocationCoordinate2D)gps {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-javascript"];
    NSString *url = [@"http://wap.sogou.com/tworeq?queryString=%E7%BE%8E%E9%A3%9F&ie=utf8&qoInfo=query%3Dclass%253A%253A%25E7%25BE%258E%25E9%25A3%259F%253A%253A0%257C%257Ccity%253A%253A%25E5%258C%2597%25E4%25BA%25AC%253A%253A0%26vrQuery%3Dclass%253A%253A%25E7%25BE%258E%25E9%25A3%259F%253A%253A0%257C%257Ccity%253A%253A%25E5%258C%2597%25E4%25BA%25AC%253A%253A0%26classId%3D70008801%26classTag%3DMULTIHIT.LIFE.CATEGORY70008801%26location%3D2%26tplId%3D70008800%26start%3D0%26item_num%3D10%26gpsItemNum%3D150%26pageTurn%3D1%26isGps%3D1%26searchScope%3D500%26locationStr%3D%25E5%258C%2597%25E4%25BA%25AC%25E5%25B8%2582%26gps%3D" stringByAppendingFormat:@"%f%%257C%f", gps.longitude, gps.latitude];
    NSLog(@"%@", url);
    [manager
     GET:url
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSArray *poixmls = [response componentsSeparatedByString:@"<subitem>"];
         NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];
         for (int i = 1; i < poixmls.count; i++){
             NSString *xml = [poixmls objectAtIndex:i];
             [results addObject:[NSDictionary dictionaryWithObjects:
                [NSArray arrayWithObjects:
                    [MCDianpingMapResult extractNode:@"img_link" fromXml:xml],
                    [MCDianpingMapResult extractNode:@"key" fromXml:xml],
                    [MCDianpingMapResult extractNode:@"latlng" fromXml:xml],
                    [MCDianpingMapResult extractNode:@"dishname" fromXml:xml],
                    nil
                 ]
                forKeys:
                [NSArray arrayWithObjects:
                    @"image", @"title", @"gps", @"dish", nil
                ]
            ]];
         }
         [self.delegate doneWithShops:results];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [self.delegate doneWithShops:nil];
     }
     ];

}

@end