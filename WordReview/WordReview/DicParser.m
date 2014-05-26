//
//  DicParser.m
//  WordReview
//
//  Created by shupeng on 5/13/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "DicParser.h"
#import "DataModelManager.h"
#import <RegexKitLite.h>

@implementation DicParser

@end






@implementation WRWordDic (YouDaoParse)

+ (WRWordDic *)wordDicWithYouDaoJson:(NSString *)json
{
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return [self wordDicWithYouDaoDic:dic];
}

+ (WRWordDic *)wordDicWithYouDaoDic:(NSDictionary *)dic
{
    WRWordDic *wordDic = [[self alloc] init];

    @try {

        wordDic.word = [[dic objectForKey:@"simple"] objectForKey:@"query"];
        wordDic.englishPronounce = [[[[dic objectForKey:@"simple"] objectForKey:@"word"] firstObject] objectForKey:@"ukphone"];
        wordDic.americaPronounce = [[[[dic objectForKey:@"simple"] objectForKey:@"word"] firstObject] objectForKey:@"usphone"];
        
        NSURL *ukPronounceURL = [NSURL URLWithString:[NSString stringWithFormat:[[DataModelManager sharedInstance] getServerByKey:SERVER_YOUDAO_PRONOUNCE_ENGLISH],(NSString *)[[[[dic objectForKey:@"simple"] objectForKey:@"word"] firstObject] objectForKey:@"ukspeech"]]];
        wordDic.englishPronounceVoiceData = [NSData dataWithContentsOfURL:ukPronounceURL];
        
        NSURL *usPronounceURL = [NSURL URLWithString:[NSString stringWithFormat:[[DataModelManager sharedInstance] getServerByKey:SERVER_YOUDAO_PRONOUNCE_AMERICA],(NSString *)[[[[dic objectForKey:@"simple"] objectForKey:@"word"] firstObject] objectForKey:@"usspeech"]]];
        wordDic.americaPronouceVoiceData = [NSData dataWithContentsOfURL:usPronounceURL];
        
        wordDic.collinsPronounce = [[[[dic objectForKey:@"collins"] objectForKey:@"collins_entries"] firstObject] objectForKey:@"phonetic"];
        
        NSMutableArray *entryArray = [NSMutableArray array];
        NSArray *entries = [[[[[dic objectForKey:@"collins"] objectForKey:@"collins_entries"] firstObject] objectForKey:@"entries"] objectForKey:@"entry"];
        for (NSDictionary *entryDic in entries) {
            NSMutableDictionary *parseEntryDic = [NSMutableDictionary dictionary];
            
            // parse desc
            NSString *entryDesc = [[[[entryDic objectForKey:@"tran_entry"] firstObject] objectForKey:@"pos_entry"] objectForKey:@"pos"];
            entryDesc = [entryDesc stringByAppendingFormat:@" %@", [[[entryDic objectForKey:@"tran_entry"] firstObject] objectForKey:@"tran"]];
            entryDesc = [entryDesc stringByAppendingFormat:@" %@",[[[entryDic objectForKey:@"tran_entry"] firstObject] objectForKey:@"box_extra"]];
            entryDesc = [entryDesc trimHtmlTag];
            
            [parseEntryDic setObject:entryDesc forKey:ENTRY_DESCRIPTION];
            
            
            // parse example
            NSString *example = [[[[[[entryDic objectForKey:@"tran_entry"] firstObject] objectForKey:@"exam_sents"] objectForKey:@"sent"] firstObject] objectForKey:@"eng_sent"];
            [parseEntryDic setObject:example forKey:ENTRY_EXAMPLE];
            
            
            // parse example explain
            NSString *explain = [[[[[[entryDic objectForKey:@"tran_entry"] firstObject] objectForKey:@"exam_sents"] objectForKey:@"sent"] firstObject] objectForKey:@"chn_sent"];
            [parseEntryDic setObject:explain forKey:ENTRY_EXPLAIN];
            
            
            [entryArray addObject:parseEntryDic];
        }
        wordDic.entries = [NSArray arrayWithArray:entryArray];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
    }
    
    return wordDic;

}
@end


@implementation NSString (WordProcess)

- (NSString *)trimedForWord
{
    if (self.length) {
//        NSMutableString *str = [NSMutableString stringWithString:self];
//        while ([[str substringToIndex:1] isEqualToString:@" "]) {
//            [str deleteCharactersInRange:NSMakeRange(0, 1)];
//        }
//        
//        while ([[str substringFromIndex:str.length - 1] isEqualToString:@" "]) {
//            [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
//        }
//        
//        return [NSString stringWithString:str];
        
        return [self stringByReplacingOccurrencesOfRegex:@"^\\s* | \\s*$" withString:@""];
    }
    else
    {
        return self;
    }

}

- (NSString *)trimHtmlTag
{
    return [self stringByReplacingOccurrencesOfRegex:@"<[^<>]*>" withString:@""];
}
@end