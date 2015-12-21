//
//  ImageZoomScroll.h
//  PhotoPreviewer
//


#import <UIKit/UIKit.h>

#define kImageViewTagOffset 100

@interface ImageZoomScroll : UIScrollView

@property (nonatomic, retain) UIImageView *currentDisplayImageView;

- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)imageName tag:(NSInteger)tag;
+ (id)imageZoomScrollWithFrame:(CGRect)frame
                     imageName:(NSString *)imageName tag:(NSInteger)tag;

@end
