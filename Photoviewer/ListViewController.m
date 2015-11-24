//
//  ListViewController.m
//  Photoviewer
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "ListViewController.h"

@implementation ListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Flickr Photos";
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.session = [NSURLSession sessionWithConfiguration:config
                                                     delegate:self
                                                delegateQueue:nil];
        
        [self fetchFeed];
    }
    return self;
}


- (void)fetchFeed
{
    NSString *requestString = @"https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=a6d819499131071f158fd740860a5a88&extras=url_h,date_taken&format=json&nojsoncallback=1";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    self.dataBlock =  ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
        
        //NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        self.photos = [[jsonObject objectForKey:@"photos"]objectForKey:@"photo"];
        
        NSLog(@"%@", self.photos);
        //NSLog(@"%@", json);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler: self.dataBlock];
    
    [dataTask resume];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                            initWithTitle:@"Random Picture"
                            style:UIBarButtonItemStylePlain
                            target:self
                            action:@selector(randomPhoto:)];
    [self setToolbarItems:[NSArray arrayWithObjects:bbi, nil]];
}

- (IBAction)randomPhoto:(id)sender{
    NSUInteger randomIndex = arc4random() % [self.photos count];
    NSDictionary *photo = self.photos[randomIndex];
    NSURL *url = [NSURL URLWithString:photo[@"url_h"]];

    if(!url){
        [self randomPhoto:sender];
    }
    else{
        self.webViewController.title = photo[@"title"];
        self.webViewController.url = url;
        
        [[self navigationController] pushViewController:self.webViewController
                                               animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = photo[@"title"];
    
    return cell;
    //return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photo = self.photos[indexPath.row];
    NSURL *url = [NSURL URLWithString:photo[@"url_h"]];
    
    if(url){
    self.webViewController.title = photo[@"title"];
    self.webViewController.url = url;
    
    [[self navigationController] pushViewController:self.webViewController
                                           animated:YES];
    }
    else{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"No URL"
                                              message:@"The link for this picture is missing"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    return io == UIInterfaceOrientationPortrait;
}

@end
