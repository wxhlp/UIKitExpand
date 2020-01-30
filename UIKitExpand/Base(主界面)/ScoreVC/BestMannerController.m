#import "BestMannerController.h"
#import "MJRefresh.h"
#import "WeaveAboutCheekboneManager.h"
#import "BestModel.h"
#import "NewTableViewCell.h"
#import "QuLeHomeDetailViewController.h"
#import "ZeroSDCycleView.h"
@interface BestMannerController ()<ZeroSDCycleViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic,strong)ZeroSDCycleView *zeroSDCycleView;
@end
@implementation BestMannerController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataSource];
    [self tableView];
    [self.tableView.mj_header beginRefreshing];
    self.title = @"足球赛事规则";
}

-(UITableView*)tableView{
    if (!_tableView) {
         if (@available(iOS 11.0, *)) {
              _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
          } else {
              self.automaticallyAdjustsScrollViewInsets = NO;
          }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView =  [self zeroSDCycleView];
         _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMassage)];
          [_tableView registerNib:[UINib nibWithNibName:@"NewTableViewCell" bundle:nil] forCellReuseIdentifier:@"Newcell"];
          [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSMutableArray*)dataSource{
    if (!_dataSource) {
       _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)getMassage{

    [[WeaveAboutCheekboneManager sharedManager]lendGate:URL_Gamerule params:@{} completed:^(BOOL ret, id obj) {
      
        [self.dataSource removeAllObjects];
        NSArray *arr = [obj objectForKey:@"game"];
             for (NSDictionary *dic in arr) {
                BestModel *model = [BestModel setModelWithDictionary:dic];
                [self.dataSource  addObject: model];
             }
            [_zeroSDCycleView setArrayStringUrl:@[@"https://n.sinaimg.cn/sports/transform/283/w650h433/20200102/1697-imkzenq6385157.jpg"]];
             dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                        [self.tableView reloadData];
             });
        
     }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Newcell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BestModel *model = self.dataSource[indexPath.row];
    cell.title.text = model.title;
    cell.title.numberOfLines = 0;
    cell.time.text = model.rule;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataSource.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     BestModel *model = self.dataSource[indexPath.row];
    
    QuLeHomeDetailViewController * homeDetailVC = [[QuLeHomeDetailViewController alloc] init];
           homeDetailVC.hidesBottomBarWhenPushed = YES;
           homeDetailVC.title = model.rule;
           [self.navigationController pushViewController:homeDetailVC animated:YES];
}

-(ZeroSDCycleView*)zeroSDCycleView{
    if (!_zeroSDCycleView) {
        _zeroSDCycleView = [ZeroSDCycleView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190) delegate:self];
        [_zeroSDCycleView setShowPageControl:YES];
        [_zeroSDCycleView  setPageControlStyle:ZeroSDCycleViewPageContolStyleAnimated];
        [_zeroSDCycleView setPageControlAliment:   ZeroSDCycleViewPageContolAlimentCenter];
         [_zeroSDCycleView setAutoScrollTimeInterval:15.0f];
    }
    return _zeroSDCycleView;
}
-(void)cycleScrollView:(ZeroSDCycleView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
