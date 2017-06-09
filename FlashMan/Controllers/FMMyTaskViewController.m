//
//  FMMyTaskViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/17.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMMyTaskViewController.h"
#import "SMOrderTitleCollectionViewCell.h"
#import "FMMyTaskPageViewController.h"
#import "FMMyTaskMoreViewController.h"

@interface FMMyTaskViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
//数据源
//@property(nonatomic,strong) SMOrderTitleJsonModel *porderTitleJsonModel;
//水平滚动的按钮数组--背景scrollview
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UICollectionView *titleCollectionView;

//当前页
@property(nonatomic,assign) NSInteger curPage;
//控制器数组
@property(nonatomic,strong) NSMutableArray *vcArr;

//分页控制器
@property(nonatomic,strong) UIPageViewController *pageVC;

//用于标记title中的哪个cell被选中
@property (nonatomic,strong) NSIndexPath *myIndexPath;
@end

@implementation FMMyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的任务";
    
    _titleArr = @[@"待取货",@"配送中",@"返还中",@"更多"];
    
    [self createSubviews];
    [self setpPageVC];

}
#pragma mark- 创建title
-(void)createSubviews
{
    //布局类
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //滚动方向
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    // 如果是水平滚动，那么此属性是上下项之间的间距
    // 如果是垂直滚动，那么此属性是左右项之间的间距
    // 此间距有时会根据ItemSize和EdgesInset自动调节
    layout.minimumInteritemSpacing=0;
    // 如果是水平滚动,那么此属性是左右列之间的间距
    // 如果是垂直滚动,那么此属性是上下行之间的间距
    layout.minimumLineSpacing=0;
    
    
    //创建collectionview
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,45) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = YES;
    
    //提前注册Cell
    [collectionView registerNib:[UINib nibWithNibName:@"SMOrderTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[SMOrderTitleCollectionViewCell identifier]];
    [self.view addSubview:collectionView];
    
    _titleCollectionView=collectionView;
}

#pragma mark- 初始化分页控制器
-(void)setpPageVC
{
    _vcArr=[NSMutableArray array];
  
    for (int i=0; i<3; i++) {
        FMMyTaskPageViewController *orderPVC=[[FMMyTaskPageViewController alloc]init];
     
        if(i == 0)
        {
            //待取货
            orderPVC.controllType = JMViewControllerToBePickedUp;
            
        }
        else if (i == 1)
        {
            //配货中
            orderPVC.controllType = JMViewControllerDelivery;
            
        }
        else if (i == 2)
        {
            //返还中订单
            orderPVC.controllType = JMViewControllerReturning;
        }
        else
        {
            //更多
            orderPVC.controllType = JMViewControllerMore;
            
        }
        
        [_vcArr addObject:orderPVC];
    }
    
    FMMyTaskMoreViewController *vc = [[FMMyTaskMoreViewController alloc]init];
    [_vcArr addObject:vc];
    
    [self createPageViewController];
    
}
#pragma mark- 创建分页控制器
-(void)createPageViewController
{
    
    UIPageViewController *pageVC=[[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [pageVC setViewControllers:@[_vcArr[_curPage]]
                     direction:UIPageViewControllerNavigationDirectionForward
                      animated:NO
                    completion:nil];
    pageVC.view.userInteractionEnabled=YES;
    pageVC.delegate=self;
    pageVC.dataSource=self;
    
    [self.view addSubview:pageVC.view];
    _pageVC=pageVC;
    
    [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.view);
        make.top.equalTo(_titleCollectionView.mas_bottom);
        
    }];
    
    
}
#pragma mark - CollectionView Delegate & DataSource
// 多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每组多少格
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 4;

    
}
//填充cell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMOrderTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SMOrderTitleCollectionViewCell identifier] forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMOrderTitleCollectionViewCell" owner:self options:nil] lastObject];
    }
    
    cell.titleLabel.text = _titleArr[indexPath.row];
    
    if(indexPath.section == self.myIndexPath.section && indexPath.row == self.myIndexPath.row )
    {
        cell.blueView.hidden = NO;
        cell.titleLabel.textColor = kFMBlueColor;
        cell.titleLabel.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [_titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else{
        cell.blueView.hidden = YES;
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//指定每格的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth/4, 45);
}
//设置每一项距离其它项的上下左右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0,0, 0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    _myIndexPath = indexPath;
    
    NSInteger jumpToPage=indexPath.row;
    FMMyTaskPageViewController *qianggouCurPVC=_vcArr[jumpToPage];
    
    // 当前可视的pagevc
    [_pageVC setViewControllers:@[qianggouCurPVC] direction:_curPage>jumpToPage animated:YES completion:^(BOOL finished) {
        _curPage=jumpToPage;
    }];
    
    
    [_titleCollectionView reloadData];
}

#pragma mark- UIPageViewController delegate
//到下一页
-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    //查找当前界面viewcontroller是数组中的第几个
    NSInteger index=[_vcArr indexOfObject:viewController];
    if (index==_vcArr.count-1) {
        return nil;
    }
    
    return _vcArr[index+1];
    
}
//返回上一页的界面
-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSInteger index=[_vcArr indexOfObject:viewController];
    if (index==0) {
        return nil;
    }
    
    return _vcArr[index-1];
}
//翻页结束之后调用的方法
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    UIViewController *vc=pageViewController.viewControllers[0];
    NSInteger index=[_vcArr indexOfObject:vc];
    _curPage=index;
    
    _myIndexPath = [NSIndexPath indexPathForRow:_curPage inSection:0];
    
    [_titleCollectionView reloadData];
    
}


#pragma mark- 响应事件
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
