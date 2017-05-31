//

#import "MoreViewController.h"
@interface MoreViewController ()

@property(nonatomic,strong) NSMutableArray *dataArray;/**<存储数据的数组*/
@end

@implementation MoreViewController
{
    NSString *selectedFunc;/**< 选择的功能 */
    NSInteger _nums;
}

- (instancetype)initWithNuberItems:(NSInteger)items
{
    if (self = [super init])
    {
        self.title = @"更多";
        _nums = items;
        [self handleData];
    }
    return self;
}

- (void)handleData
{
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"moreGrid.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
    if (array == nil)
    {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"moreGrid.plist" ofType:nil];
        array = [NSArray arrayWithContentsOfFile:filepath];
    }
    _dataArray = array.mutableCopy;
}

- (void)themeDidChange
{
    [_dataArray insertObject:_Datadic atIndex:_dataArray.count];
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"moreGrid.plist"];
    [_dataArray writeToFile:filepath atomically:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"更多";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatViews];
}

- (void)creatViews
{
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"moreGrid.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
    if (array == nil)
    {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"moreGrid.plist" ofType:nil];
        array = [NSArray arrayWithContentsOfFile:filepath];
    }
    _dataArray = array.mutableCopy;
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"moreGrid.plist"];
    [MoveCollectionHandle MoveCollectionHandle:self
                                      withView:self.view
                                      withData:_dataArray
                                     withFrame:frame
                                    numOfItems:_nums
                                   OperateType:DemonOperateTypeAdd
                                DelectBtnBlock:^(NSIndexPath *indexPath)
     {
         NSDictionary *dic = _dataArray[indexPath.row];
         [_dataArray removeObjectAtIndex:indexPath.row];
         [_dataArray writeToFile:path atomically:YES];
         _addBlock(dic);
     }
                                  moveEndBlock:^(NSIndexPath *beginIndex, NSIndexPath *endIndex)
     {
         id dataModel = _dataArray[beginIndex.row];
         [_dataArray removeObjectAtIndex:beginIndex.row];
         [_dataArray insertObject:dataModel atIndex:endIndex.row];
         [_dataArray writeToFile:path atomically:YES];
     }
                              selectedBtnBlock:^(NSIndexPath *selectedIndex, NSString *seletTitle)
     {
         
    }];
}

- (void)setDatadic:(NSDictionary *)Datadic
{
    if (_Datadic != Datadic)
    {
        _Datadic = Datadic;
    }
    [self themeDidChange];
}
@end
