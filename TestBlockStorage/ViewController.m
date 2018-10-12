//
//  ViewController.m
//  TestBlockStorage
//
//  Created by liujing on 2018/10/12.
//  Copyright © 2018 jean. All rights reserved.
//

#import "ViewController.h"

static NSString *globalStr=@"global";
typedef void(^blocakName)(int);
typedef int(^successBlock)(long);

@interface ViewController ()
@property (nonatomic, copy) blocakName someblock;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    int *a2;
    __block int b2;
    b2=3;
    a2=&b2;
    static NSString *localStr=@"local";
    //没有访问外部变量即为NSGlobalBlock
    successBlock b1 = ^int(long b){
        int a = 5;
        return a;
    };
    NSLog(@"b1 is at %@",b1);
    
    blocakName bl1=^void(int a){
        localStr=@"localstr1";//局部静态变量，通过指针传递
        globalStr=@"globalStr1";//全局静态变量和全局变量，通过值传递
        NSLog(@"a is %d,local str is %@,global str is %@",a,localStr,globalStr);
    };
    NSLog(@"bl1 is at %@",bl1);
  
    
    ViewController * vc = [ViewController new];
    //   self.successb = bl1;//用somemethod调 加这句没用
    vc.someblock = bl1;//这句不加的话很显然不对 somemethod里的self为vc 而vc的someblock没有赋值无法执行
    [vc somemethod];

    blocakName bl2 =^void(int a){
        localStr=@"localstr1";//局部静态变量，通过指针传递
        globalStr=@"globalStr1";//全局静态变量和全局变量，通过值传递
        b2=6;//局部变量,b2需要__block修饰 不然只可读
        NSLog(@"a is %d,a2 is %d,b2 is %d,local str is %@,global str is %@",a,*a2,b2,localStr,globalStr);
    };
    
    //访问了外部变量即为stack block，block的实现与上面的完全相同
    NSLog(@"这个block 没被引用时 is %@",^void(int a){
        localStr=@"localstr1";//局部静态变量，通过指针传递
        globalStr=@"globalStr1";//全局静态变量和全局变量，通过值传递
        b2=6;//局部变量,b2需要__block修饰 不然只可读
        NSLog(@"a is %d,a2 is %d,b2 is %d,local str is %@,global str is %@",a,*a2,b2,localStr,globalStr);
    });
    
    //引用了外部变量即为stackblock，arc下当引用此block变量时即有个指针指向它时则自动复制到堆上
    NSLog(@"这个block 被bl2引用时 is %@",bl2);
    
  
    bl1(5);//调用
    bl2(10);//调用
    
    __weak blocakName bl3 =^void(int a){
        localStr=@"localstr1";//局部静态变量，通过指针传递
        globalStr=@"globalStr1";//全局静态变量和全局变量，通过值传递
        b2=6;//局部变量,b2需要__block修饰 不然只可读
        NSLog(@"a is %d,a2 is %d,b2 is %d,local str is %@,global str is %@",a,*a2,b2,localStr,globalStr);
    };
    NSLog(@"bl3 is at %@",bl3);
}

//这个方法是用来验证 即使是堆上的对象也可以安全地访问global的block
//配置在全局变量的block，在变量作用域外通过指针可以安全地访问
-(void)somemethod{
   self.someblock(99);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
