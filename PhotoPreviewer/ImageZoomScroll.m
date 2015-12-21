//
//  ImageZoomScroll.m
//  PhotoPreviewer
//


#import "ImageZoomScroll.h"


@implementation ImageZoomScroll

//根据当前图片的大小计算imageview的frame
- (CGRect)_calculateCurrentDisplayImageViewRectWithImageSize:(CGSize)size{
    CGSize scrollSize = self.bounds.size;
    if (size.width <= scrollSize.width && size.height <= scrollSize.height) {
        CGFloat x = (scrollSize.width - size.width) / 2;
        CGFloat y = (scrollSize.height - size.height) / 2;
        return CGRectMake(x, y, size.width, size.height);
    }
    
    if (size.width > scrollSize.width && size.height > scrollSize.height) {
        CGFloat width = scrollSize.width;
        CGFloat height = scrollSize.width * size.height / size.width;
        CGFloat x = 0;
        CGFloat y = 0;
        self.contentSize = CGSizeMake(width, height);
        self.contentOffset = CGPointZero;
        return CGRectMake(x, y, width, height);
    }
    
    if (size.width <= scrollSize.width && size.height >= scrollSize.height) {
        CGFloat width = scrollSize.height * size.width / size.height;
        CGFloat height = scrollSize.height;
        CGFloat x = (scrollSize.width - width) / 2;
        CGFloat y = (scrollSize.height - height) / 2;
        self.contentSize = CGSizeMake(width, height);
        return CGRectMake(x, y, width, height);
    }
    
    return self.bounds;
}

- (void)_setupAttributes{
    //配置scrollView的属性
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 3.0;
    self.zoomScale = 1.0;
    self.bouncesZoom = YES;
    self.contentSize = CGSizeZero;
    self.directionalLockEnabled = YES;
    self.backgroundColor = [UIColor blackColor];
}

- (void)_pakageDoubleClickGestureRecognizer{
    UITapGestureRecognizer *_doubleClickGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleClickAction:)];
    _doubleClickGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleClickGesture];
    [_doubleClickGesture release];
}

- (void)_handleDoubleClickAction:(UITapGestureRecognizer *)sender{
    if (self.zoomScale == 1.0) {
        if (self.currentDisplayImageView.bounds.size.width < self.bounds.size.width) {
            [self setZoomScale:self.bounds.size.width / self.currentDisplayImageView.bounds.size.width animated:YES];
        } else {
            [self setZoomScale:2.0 animated:YES];
        }
    } else {
        [self setZoomScale:1.0 animated:YES];
    }
}

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupAttributes];
        self.tag = tag;
        //获取图片的名称和扩展名
        NSArray *_nameArray = [imageName componentsSeparatedByString:@"."];
        NSString *_imagePath = [[NSBundle mainBundle] pathForResource:[_nameArray firstObject] ofType:[_nameArray lastObject]];
        UIImage *_image = [UIImage imageWithContentsOfFile:_imagePath];
        CGSize _imageSize = _image.size;
        CGRect _currentImageViewRect = [self _calculateCurrentDisplayImageViewRectWithImageSize:_imageSize];
        self.currentDisplayImageView = [[[UIImageView alloc] initWithImage:_image] autorelease];
        self.currentDisplayImageView.frame = _currentImageViewRect;
        self.currentDisplayImageView.tag = tag + kImageViewTagOffset;
//        self.currentDisplayImageView.center = self.center;
        [self addSubview:self.currentDisplayImageView];
        [self _pakageDoubleClickGestureRecognizer];
    }
    return self;
}

+ (id)imageZoomScrollWithFrame:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag{
    return [[[[self class] alloc] initWithFrame:frame imageName:imageName tag:tag] autorelease];
}

- (void)dealloc{
    [_currentDisplayImageView release];
    [super dealloc];
}



@end
