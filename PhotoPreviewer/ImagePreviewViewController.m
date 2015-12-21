//
//  ImagePreviewViewController.m
//  PhotoPreviewer



#import "ImagePreviewViewController.h"
#import "ImageZoomScroll.h"

#define kDisplayImageCount 7
#define kImageZoomScrollTagOffset 110

@interface ImagePreviewViewController ()

- (void)_setupScrollableScroll;
- (void)_setupZoomableScroll;
- (void)_setupPageIndexLabel;
- (void)_setup;

@end

@implementation ImagePreviewViewController

- (void)_setup{
    [self _setupScrollableScroll];
    [self _setupZoomableScroll];
    [self _setupPageIndexLabel];
}

- (void)_setupScrollableScroll{
    self.scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * kDisplayImageCount, self.view.bounds.size.height);
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

- (void)_setupZoomableScroll{
    for (int i = 0; i < kDisplayImageCount; i++) {
        CGRect frame = CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        NSString *_imageName = [NSString stringWithFormat:@"image%d.jpg", i + 1];
        ImageZoomScroll *_tempImageZoomScroll = [ImageZoomScroll imageZoomScrollWithFrame:frame imageName:_imageName tag:kImageZoomScrollTagOffset + i];
        _tempImageZoomScroll.delegate = self;
        [self.scrollView addSubview:_tempImageZoomScroll];
    }
}

- (void)_setupPageIndexLabel{
    self.pageIndexLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 20)] autorelease];
    self.pageIndexLabel.font = [UIFont boldSystemFontOfSize:16];
    self.pageIndexLabel.textColor = [UIColor whiteColor];
    self.pageIndexLabel.textAlignment = NSTextAlignmentCenter;
    self.pageIndexLabel.shadowColor = [UIColor blackColor];
    self.pageIndexLabel.shadowOffset = CGSizeMake(-1, 1);
    self.pageIndexLabel.text = [NSString stringWithFormat:@"%d/%d", 1, kDisplayImageCount];
    [self.view addSubview:self.pageIndexLabel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setup];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (scrollView != self.scrollView) {
        return [scrollView viewWithTag:scrollView.tag + kImageViewTagOffset];
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        UIImageView *_imageView = (UIImageView *)[scrollView viewWithTag:scrollView.tag + kImageViewTagOffset];
        CGSize boundsSize = self.view.bounds.size;
        CGRect frameToCenter = _imageView.frame;
        
        //如果图片的宽度比高度大
        if (frameToCenter.size.width < boundsSize.width){
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
        }else{
            frameToCenter.origin.x = 0;
        }
        
        //如果图片的高度比宽度大
        if (frameToCenter.size.height < boundsSize.height){
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
        }else{
            frameToCenter.origin.y = 0;
        }
        _imageView.frame = frameToCenter;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger currentIndex = (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width / 2) / self.scrollView.bounds.size.width;//1
        
        NSArray *_pageArray = [self.pageIndexLabel.text componentsSeparatedByString:@"/"];
        NSInteger previousIndex = [[_pageArray firstObject] integerValue];
        if (previousIndex != currentIndex + 1) {
            ImageZoomScroll *_previousZoomScrollView = (ImageZoomScroll *)[self.scrollView viewWithTag:kImageZoomScrollTagOffset + previousIndex - 1];
            [_previousZoomScrollView setZoomScale:1.0 animated:YES];
        }
        
        self.pageIndexLabel.text = [NSString stringWithFormat:@"%d/%d", currentIndex + 1, kDisplayImageCount];
    }
}



- (void)dealloc{
    [_scrollView release];
    [_pageIndexLabel release];
    [super dealloc];
}

@end
