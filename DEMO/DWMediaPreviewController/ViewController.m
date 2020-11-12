//
//  ViewController.m
//  DWMediaPreviewController
//
//  Created by Wicky on 2019/6/20.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "ViewController.h"
#import <DWMediaPreviewController/DWMediaPreviewHeader.h>
#import "DWAlbumPreviewToolBar.h"
#import "DWAlbumPreviewNavigationBar.h"
#import <Photos/Photos.h>

@interface ViewController ()<DWMediaPreviewDataSource>

@property (nonatomic ,strong) DWMediaPreviewController * previewVC;

@property (nonatomic ,strong) UIImageView * imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
}
- (IBAction)push:(id)sender {
    
     [self.navigationController pushViewController:self.previewVC animated:YES];
}
- (IBAction)present:(id)sender {
    [self presentViewController:self.previewVC animated:YES completion:nil];
}

-(NSUInteger)countOfMediaForPreviewController:(DWMediaPreviewController *)previewController {
    return 4;
}

-(DWMediaPreviewType)previewController:(DWMediaPreviewController *)previewController previewTypeAtIndex:(NSUInteger)index {
    if (index == 0) {
        return DWMediaPreviewTypeImage;
    } else if (index == 1) {
        return DWMediaPreviewTypeAnimateImage;
    } else if (index == 2) {
        return DWMediaPreviewTypeLivePhoto;
    } else if (index == 3) {
        return DWMediaPreviewTypeCustomize;
    } else {
        return DWMediaPreviewTypeImage;
    }
}

-(void)previewController:(DWMediaPreviewController *)previewController fetchMediaAtIndex:(NSUInteger)index previewType:(DWMediaPreviewType)previewType progressHandler:(DWMediaPreviewFetchMediaProgress)progressHandler fetchCompletion:(DWMediaPreviewFetchMediaCompletion)fetchCompletion {
    __block id media = nil;
    
    if (index == 0) {
        media = [UIImage imageNamed:@"image1.jpeg"];
    } else if (index == 1) {
        media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"animateImage2" ofType:@"gif"]];
    } else if (index == 2) {
        NSString * heicPath = [[NSBundle mainBundle] pathForResource:@"livePhoto3" ofType:@"HEIC"];
        NSString * movPath = [[NSBundle mainBundle] pathForResource:@"livePhoto3" ofType:@"MOV"];
        
        [PHLivePhoto requestLivePhotoWithResourceFileURLs:@[[NSURL fileURLWithPath:heicPath],[NSURL fileURLWithPath:movPath]] placeholderImage:[UIImage imageNamed:@"livePhoto3.HEIC"] targetSize:PHImageManagerMaximumSize contentMode:(PHImageContentModeAspectFill) resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nonnull info) {
            media = livePhoto;
            ///通过这种方式获取的livePhoto回调给最后的非缩略图的livePhoto对象的size会为0，我也不知道为什么，可能是我获取方式不对。实际通过相册获取的livePhoto得到的尺寸为实际尺寸
            if (media && fetchCompletion) {
                fetchCompletion(media,index);
            }
        }];
    } else if (index == 3) {
        media = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video4" ofType:@"mp4"]]];
    } else {
        media = [UIImage imageNamed:@"IMG_0045.PNG"];
    }
    if (media && fetchCompletion) {
        fetchCompletion(media,index);
    }
    
}

-(BOOL)previewController:(DWMediaPreviewController *)previewController usePosterAsPlaceholderForCellAtIndex:(NSUInteger)index previewType:(DWMediaPreviewType)previewType {
    if (previewType == DWMediaPreviewTypeCustomize || previewType == DWMediaPreviewTypeVideo || previewType == DWMediaPreviewTypeLivePhoto) {
        return YES;
    }
    return NO;
}

-(DWMediaPreviewCell *)previewController:(DWMediaPreviewController *)previewController cellForItemAtIndex:(NSUInteger)index previewType:(DWMediaPreviewType)previewType {
    if (previewType == DWMediaPreviewTypeCustomize) {
        return [previewController dequeueReusablePreviewCellWithReuseIdentifier:@"controlCell" forIndex:index];
    }
    return nil;
}

-(BOOL)previewController:(DWMediaPreviewController *)previewController shouldShowBadgeAtIndex:(NSUInteger)index previewType:(DWMediaPreviewType)previewType {
    return YES;
}

-(BOOL)previewController:(DWMediaPreviewController *)previewController isHDRAtIndex:(NSUInteger)index previewType:(DWMediaPreviewType)previewType {
    return YES;
}

-(DWMediaPreviewController *)previewVC {
    if (!_previewVC) {
        _previewVC = [[DWMediaPreviewController alloc] init];
        _previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
        _previewVC.dataSource = self;
        [_previewVC registerClass:[DWVideoControlPreviewCell class] forCustomizePreviewCellWithReuseIdentifier:@"controlCell"];
        _previewVC.topToolBar = [DWAlbumPreviewNavigationBar toolBar];
        _previewVC.bottomToolBar = [DWAlbumPreviewToolBar toolBar];
        [_previewVC configLongPressOnCellAction:^(DWMediaPreviewController * _Nonnull previewController, __kindof DWMediaPreviewCell * _Nonnull cell, NSInteger index, CGPoint touchLocationOnMedia) {
            NSLog(@"aaaa");
        }];
    }
    return _previewVC;
}


@end
