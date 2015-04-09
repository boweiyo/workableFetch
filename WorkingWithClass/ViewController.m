//
//  ViewController.m
//  WorkingWithClass
//
//  Created by Bowei on 4/8/15.
//  Copyright (c) 2015 Teo Bowei. All rights reserved.
//

#import "ViewController.h"
#import "Phone.h"

@interface ViewController (){
        NSMutableData *jsonResponse;
        NSMutableArray *resultList;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    Phone *phone1 = [[Phone alloc]init];
//    [phone1 setModel:@"Desire 610"];
//    [phone1 setBrand:@"HTC"];
//    
//    Phone *phone2 = [[Phone alloc]init];
//    [phone2 setModel:@"One X"];
//    [phone2 setBrand:@"HTC"];
//    
//    NSLog(@"%@",phone1);

    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.meetup.com/2/groups?lat=51.509980&lon=-0.133700&page=20&key=1f5718c16a7fb3a5452f45193232"]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    jsonResponse = [NSMutableData data];

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [jsonResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
            resultList = [[NSMutableArray alloc]init];
    
    NSString *responseString = [[NSString alloc] initWithData:jsonResponse encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    id allDataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    if ([allDataDictionary isKindOfClass:[NSDictionary class]]){ //Added instrospection as suggested in comment.
        NSArray *meetup = allDataDictionary[@"results"];
        if ([meetup isKindOfClass:[NSArray class]]){//Added instrospection as suggested in comment.
            
            for (NSDictionary *dictionary in meetup) {
                Phone *temp= [[Phone alloc] init];
                NSLog(@"%@",[dictionary objectForKey:@"name"]);

                temp.model = [dictionary objectForKey:@"who"];
                temp.brand = [dictionary objectForKey:@"description"];

                [resultList addObject:temp];
            }
//            if(result.count>0)
//                [self.tableView reloadData];
        }
    }
    
    [self.tableView reloadData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(resultList.count!=0){
        return resultList.count;
    }
    else
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Phone *temp = [[Phone alloc]init];

//    self.testLabel.text = @"testing";
    
    [[cell detailTextLabel]setText:temp.brand];
    [[cell textLabel]setText:temp.model];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
