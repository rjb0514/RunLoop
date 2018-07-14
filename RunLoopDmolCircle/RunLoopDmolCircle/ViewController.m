//
//  ViewController.m
//  RunLoopDmolCircle
//
//  Created by ru on 2018/7/14.
//  Copyright © 2018年 ru. All rights reserved.
//

#import "ViewController.h"

#define KCount  10
#define KMultiple 1000

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UICollectionView         *collectionView;

@property (nonatomic, strong) UIPageControl         *pageControl;

@property (nonatomic, strong) NSTimer         *timer;

@property (nonatomic, strong) UITableView         *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
    
    [self fireTimer];
    
//    [self addObserver];
}


- (void)coculate {
    
    CGFloat width = self.collectionView.bounds.size.width;
    NSInteger temp = self.collectionView.contentOffset.x / width;
    
    [self.collectionView setContentOffset:CGPointMake((temp + 1) *width, 0) animated:YES];
    
}

- (void)fireTimer {
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

- (void)addObserver {
    
    /*
     typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
     kCFRunLoopEntry = (1UL << 0),
     kCFRunLoopBeforeTimers = (1UL << 1),
     kCFRunLoopBeforeSources = (1UL << 2),
     kCFRunLoopBeforeWaiting = (1UL << 5),
     kCFRunLoopAfterWaiting = (1UL << 6),
     kCFRunLoopExit = (1UL << 7),
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     };
     */
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        switch (activity) {
            case kCFRunLoopEntry:
                {
                    NSLog(@"进入runloop");
                }
                break;
            case kCFRunLoopBeforeTimers:
            {
                NSLog(@"即将处理timer");
            }
                break;
            case kCFRunLoopBeforeSources:
            {
                NSLog(@"即将处理source");
            }
                break;
            case kCFRunLoopBeforeWaiting:
            {
                NSLog(@"进入睡眠");
            }
                break;
            case kCFRunLoopAfterWaiting:
            {
                NSLog(@"唤醒");
            }
                break;
            case kCFRunLoopExit:
            {
                NSLog(@"退出runloop");
            }
                break;
                
            default:
                break;
        }
    });
    
    CFRunLoopAddObserver([NSRunLoop currentRunLoop].getCFRunLoop, observer, kCFRunLoopCommonModes);
    

    
}

#pragma mark - table Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.textView) {
        NSLog(@"%@",[NSRunLoop currentRunLoop].currentMode);
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@",[NSRunLoop currentRunLoop].currentMode);
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (KCount) * 50;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor =  [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger temp = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = temp % KCount;
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger temp = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = temp % KCount;
}


#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 300);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 290 + 100, self.view.bounds.size.width, 10)];
        _pageControl.numberOfPages = KCount;
    }
    return _pageControl;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(coculate) userInfo:nil repeats:YES];
    }
    return _timer;
}



@end
