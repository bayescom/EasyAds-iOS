// To parse this JSON:
//
//   NSError *error;
//   BYExamCellModel *examCellModel = BYExamCellModelFromJSON(json, NSUTF8Encoding, &error);

#import <Foundation/Foundation.h>

@class BYExamCellModelElement;

NS_ASSUME_NONNULL_BEGIN

typedef NSArray<BYExamCellModelElement *> BYExamCellModel;

#pragma mark - Top-level marshaling functions

BYExamCellModel *_Nullable BYExamCellModelFromData(NSData *data, NSError **error);
BYExamCellModel *_Nullable BYExamCellModelFromJSON(NSString *json, NSStringEncoding encoding, NSError **error);
NSData          *_Nullable BYExamCellModelToData(BYExamCellModel *examCellModel, NSError **error);
NSString        *_Nullable BYExamCellModelToJSON(BYExamCellModel *examCellModel, NSStringEncoding encoding, NSError **error);

#pragma mark - Object interfaces

@interface BYExamCellModelElement : NSObject
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *subtitle;
@property (nonatomic, copy)   NSString *tag;
@property (nonatomic, copy)   NSString *ctime;
@property (nonatomic, assign) NSInteger cellh;
@property (nonatomic, assign) NSInteger showtype;
@end

NS_ASSUME_NONNULL_END
