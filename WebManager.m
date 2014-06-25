//
//  WebManager.m
//  myYIDA
//
//  Created by xiaojia on 4/3/14.
//  Copyright (c) 2014 sirius. All rights reserved.
//

#import "WebManager.h"
#import "TFHpple.h"

#define WEB_URL_INDEX       @"http://jwc.wyu.edu.cn/student/logon.asp"
#define WEB_URL_CLASSLIST   @"http://jwc.wyu.edu.cn/student/f3.asp"
#define WEB_URL_SCORELIST   @"http://jwc.wyu.edu.cn/student/f4_myscore.asp"
#define WEB_HTTPHEADER      @"http://jwc.wyu.edu.cn/student/body.htm"

@implementation WebManager

@synthesize classList = _classList;

#pragma mark - Conection

-(Boolean)ConcWebWithUserCode:(NSString *)usercode Password:(NSString *)password
{
    NSLog(@"conetion");
    
    NSURL *URL = [NSURL URLWithString:WEB_URL_INDEX];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString *postString = [NSString stringWithFormat:@"UserCode=%@&UserPwd=%@",usercode,password];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *contentType = [NSString stringWithFormat:WEB_HTTPHEADER];
    
    [request addValue:contentType forHTTPHeaderField:@"referer"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *pageSource = [[NSString alloc] initWithData:responseData encoding:gbkEncoding];
    
    if(response){
        NSLog(@"response = %@",pageSource);
    }
    
    //验证登录是否成功 利用判断返回的网页内容来判断
    if ([pageSource rangeOfString:@"welcome"].location != NSNotFound) {
        [self GetClass];
        [self GetScore];
        return YES;
    }else{
        return NO;
    }
    
    return NO;
}

-(void)GetClass
{
    NSURL *URL = [NSURL URLWithString:WEB_URL_CLASSLIST];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    //NSString *contentType = [NSString stringWithFormat:WEB_HTTPHEADER];
    //[request addValue:contentType forHTTPHeaderField:@"referer"];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    /*
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *pageSource = [[NSString alloc] initWithData:responseData encoding:gbkEncoding];
    
    NSString *utf8HtmlStr = [pageSource
                             stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">"
                             withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    NSData *htmlData = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if(response){
        //NSLog(@"GetClass %@",pageSource);
    }
    */
    
    
    [self ParsingHTMLWithData:responseData];
    
}

-(void)GetScore
{
    NSURL *URL = [NSURL URLWithString:WEB_URL_SCORELIST];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"http://jwc.wyu.edu.cn/student/menu.asp" forHTTPHeaderField:@"Referer"];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *pageSource = [[NSString alloc] initWithData:responseData encoding:gbkEncoding];
    
    NSString *utf8HtmlStr = [pageSource
                             stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">"
                             withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    
    NSData *htmlData = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if(response){
        //NSLog(@"GetScore %@",pageSource);
    }

    [self ParsingHTMLWithScoreData:responseData];
    
}


#pragma mark - Parsing

-(void)ParsingHTMLWithData:(NSData *)Data
{
    TFHpple *Parser = [TFHpple hppleWithHTMLData:Data];
    NSString *XpathQueryString = @"//tbody/tr/td";
    NSArray  *elements = [Parser searchWithXPathQuery:XpathQueryString];
    
    NSMutableArray *saveClass = [[NSMutableArray alloc] initWithCapacity:0];
 
    if(elements){
        
        for(int index = 15 ;index < 54; index++){
            
            TFHppleElement *element = [elements objectAtIndex:index];
            
            NSMutableString *finalInfo = [[NSMutableString alloc] init];
            //NSArray *elementschlid = [element children];
            
            for(TFHppleElement *child in element.children){
                
                NSString *content = [child content];;
                
                if(content){
                    //NSLog(@"content2 %@",content);
                    //NSMutableString *fincontent = [NSMutableString stringWithString:content];
                    [finalInfo appendString:content];
                    [finalInfo appendString:@"\n"];
                }
    
            }
            [saveClass addObject:finalInfo];
        }
        
    }
    
    _classList = [NSArray arrayWithArray:saveClass];
    //NSLog(@"%@",saveClass);
}

-(void)ParsingHTMLWithScoreData:(NSData *)Data
{
    TFHpple *Parser = [[TFHpple alloc] initWithHTMLData:Data];
    NSString *XpathQueryString = @"//div[@class='Section1']/table/tr/td/p/span";
    //NSString *XpathQueryString = @"//p";
    
    NSArray *elements = [Parser searchWithXPathQuery:XpathQueryString];
    
    //NSMutableArray *scorelist = [[NSMutableArray alloc] init];
    
    if(elements){
        
        NSLog(@"is not null");
        
        for(int index = 0 ; index < 200; index++){
            
            TFHppleElement *element = [elements objectAtIndex:index];
            
           //NSString *content = [element content];
            
            //NSLog(@"parent %@",content);
            
            for(TFHppleElement *child in element.children){
                NSString *content = [child content];
                
                if(content){
                   // NSLog(@"content %@",content);
                }
            }
            
     
        }
        
    }
    
    
}


@end
