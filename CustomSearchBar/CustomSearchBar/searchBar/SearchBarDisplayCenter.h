//
//  SearchBarDisplayCenter.h
//  KunShanETDZ
//
//  Created by 云联智慧 on 2019/5/20.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchBarDisplayCenterDelegate<NSObject>
-(void)getSearchKeyWord:(NSString *)searchWord;
@end
@interface SearchBarDisplayCenter : UIView
/** 搜索框提示语 */
@property(nonatomic,copy)NSString *placeholderStr;
@property(nonatomic,weak)id<SearchBarDisplayCenterDelegate>delegate;
@end
