//
//  ImagePreviewViewController.h
//  PhotoPreviewer


#import <UIKit/UIKit.h>

@interface ImagePreviewViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *pageIndexLabel;

@end
