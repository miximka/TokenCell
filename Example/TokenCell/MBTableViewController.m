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
#import "MBTokenCollectionLabel.h"

@interface MBTableViewController () <MBTokenCollectionTableViewCellDataSource, MBTokenCollectionTableViewCellDelegate>
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
    [cell addTokens:@[token]];
}

- (void)configureTokenCollectionCell:(MBTokenCollectionTableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.dataSource = self;
    cell.delegate = self;
    cell.titleLabel.text = [NSString stringWithFormat:@"Title %i:", (unsigned int)indexPath.row + 1];
    [cell addTokens:self.tokens];
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tokens = [NSMutableArray new];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _rowHeightCache = [NSMutableDictionary new];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MBTokenCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBTokenCollectionTableViewCell" forIndexPath:indexPath];
    [self configureTokenCollectionCell:cell forItemAtIndexPath:indexPath];
    
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

#pragma mark - MBTokenCollectionTableViewCellDataSource

- (MBTokenCollectionTokenView *)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell viewForToken:(id<MBToken>)token
{
    MBTokenCollectionLabel *view = [[MBTokenCollectionLabel alloc] initWithToken:token];
    return view;
}

#pragma mark - MBTokenCollectionTableViewCellDelegate

- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell didEndEditingWithText:(NSString *)text
{
    [self addTokenForCell:cell withText:text];
}

- (BOOL)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell textFieldShouldReturnWithText:(NSString *)text
{
    [self addTokenForCell:cell withText:text];
    return YES;
}

- (void)tokenCollectionTableViewCellDeleteBackwardsInEmptyField:(MBTokenCollectionTableViewCell *)cell
{
    NSIndexSet *indexes = [cell selectedTokenIndexes];
    
    if (indexes.count > 0) {
        //Delete selected tokens
        [self.tokens removeObjectsAtIndexes:indexes];
        [cell removeTokensAtIndexes:indexes];
    
    } else {
        NSInteger index = self.tokens.count - 1;
        
        if (index >= 0) {
            //Select the last token
            [cell selectTokenAtIndex:index animated:YES];
        }
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
