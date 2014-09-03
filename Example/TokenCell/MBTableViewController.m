//
//  MBTableViewController.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTableViewController.h"
#import "MBTokenCollectionTableViewCell.h"
#import "MBSimpleToken.h"

@interface MBTableViewController () <MBTokenCollectionTableViewCellDelegate>
@property (nonatomic) NSMutableDictionary *rowHeightCache;
@property (nonatomic) NSMutableArray *tokens;
@end

@implementation MBTableViewController

- (void)addTokenForCell:(MBTokenCollectionTableViewCell *)cell withText:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    
    //Add token to the model
    MBSimpleToken *token = [[MBSimpleToken alloc] init];
    token.title = text;
    [self.tokens addObject:token];
    
    //Add token to the view
    [cell addTokens:@[token] animated:YES];
}

- (void)configureTokenCollectionCell:(MBTokenCollectionTableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
        return;
    
    cell.delegate = self;
    cell.titleLabel.text = @"Title:";
    [cell addTokens:self.tokens animated:NO];
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _rowHeightCache = [NSMutableDictionary new];
}

- (void)viewDidAppear:(BOOL)animated
{
    MBTokenCollectionTableViewCell *cell = (MBTokenCollectionTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell startEditing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger row = indexPath.row;
    
    if (row < 1) {
        
        MBTokenCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBTokenCollectionTableViewCell" forIndexPath:indexPath];
        [self configureTokenCollectionCell:cell forItemAtIndexPath:indexPath];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *rowHeight = [_rowHeightCache objectForKey:@(indexPath.row)];
    
    if (rowHeight) {
        return rowHeight.floatValue;
    }

    return 44.0;
}

#pragma mark - MBTokenCollectionTableViewCellDelegate

- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell didEndEditingWithText:(NSString *)text
{
    [self addTokenForCell:cell withText:text];
}

- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell textFieldShouldReturnWithText:(NSString *)text
{
    [self addTokenForCell:cell withText:text];
}

- (void)tokenCollectionTableViewCellDeleteBackwardsInEmptyField:(MBTokenCollectionTableViewCell *)cell
{
    NSIndexSet *indexes = [cell selectedTokenIndexes];
    
    if (indexes.count > 0) {
        //Delete selected tokens
        [cell removeTokensAtIndexes:indexes animated:YES];
    }
}

- (void)tokenCollectionTableViewCellDidChangeContentSize:(MBTokenCollectionTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (!indexPath) {
        return;
    }
    
    //Cache cell's height
    [_rowHeightCache setObject:@(cell.contentSize.height) forKey:@(indexPath.row)];
    
    //Update table view
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)tokenCollectionTableViewCellDidTapAddButton:(MBTokenCollectionTableViewCell *)cell
{
    [self addTokenForCell:cell withText:@"Plus"];
}

@end
