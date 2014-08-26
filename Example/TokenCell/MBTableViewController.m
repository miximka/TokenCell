//
//  MBTableViewController.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTableViewController.h"
#import "MBTokenCollectionTableViewCell.h"
#import "MBRecipientTokenCollection.h"
#import "MBRecipientToken.h"
#import "MBRecipientTokenView.h"

#define MIN_CELL_HEIGHT 44.0

@interface MBTableViewController () <MBTokenCollectionTableViewCellDelegate>
@property (nonatomic) NSMutableDictionary *rowHeightCache;
@property (nonatomic) MBRecipientTokenCollection *tokenCollection;
@end

@implementation MBTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _rowHeightCache = [NSMutableDictionary new];

    MBRecipientTokenCollection *tokenCollection = [[MBRecipientTokenCollection alloc] initWithTitle:@"To:"];
    
    MBRecipientToken *token = [[MBRecipientToken alloc] initWithEmail:nil name:@"Token"];
    [tokenCollection addToken:token];

    _tokenCollection = tokenCollection;
}

- (void)configureTokenCollectionCell:(MBTokenCollectionTableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
        return;
    
    MBRecipientTokenCollection *collection = self.tokenCollection;
    
    cell.delegate = self;
    cell.title = collection.title;
    [cell addTokens:collection.tokens animated:NO];
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
    CGFloat cellHeight = rowHeight.floatValue;
    
    if (cellHeight <= MIN_CELL_HEIGHT) {
        cellHeight = MIN_CELL_HEIGHT;
    }

    return cellHeight;
}

- (void)addTokenFromContentsOfTextFieldInCell:(MBTokenCollectionTableViewCell *)cell
{
    NSString *text = cell.editingText;
    
    if (text.length == 0) {
        return;
    }
    
    MBRecipientTokenCollection *collection = self.tokenCollection;
    
    //Add new token to model
    MBRecipientToken *token = [[MBRecipientToken alloc] initWithEmail:text name:nil];
    [collection addToken:token];
    
    //Add token to view
    [cell addTokens:@[token] animated:YES];
    
    cell.editingText = @"";
}

#pragma mark - MBTokenCollectionTableViewCellDelegate

- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell didEndEditingWithText:(NSString *)text
{
    [self addTokenFromContentsOfTextFieldInCell:cell];
}

- (void)tokenCollectionTableViewCellTextFieldShouldReturn:(MBTokenCollectionTableViewCell *)cell
{
    [self addTokenFromContentsOfTextFieldInCell:cell];
}

- (void)tokenCollectionTableViewCellDeleteBackwardsInEmptyField:(MBTokenCollectionTableViewCell *)cell
{
    NSIndexSet *indexes = [cell selectedTokenIndexes];
    
    if (indexes.count > 0) {
        //Delete selected tokens
        MBRecipientTokenCollection *collection = self.tokenCollection;
        [collection removeTokensAtIndexes:indexes];
        
        [cell removeTokensAtIndexes:indexes animated:YES];
    }
}

- (MBTokenCollectionItemView *)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell viewForToken:(id<MBToken>)token
{
    MBRecipientTokenView *view = [[MBRecipientTokenView alloc] init];
    view.token = (MBRecipientToken *)token;
    
    return view;
}

- (void)tokenCollectionTableViewCellDidChangeContentSize:(MBTokenCollectionTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (!indexPath) {
        return;
    }
    
    CGSize newContentSize = cell.contentSize;
    
    //Cache cell content view size height
    [_rowHeightCache setObject:@(newContentSize.height) forKey:@(indexPath.row)];
    
    //Let table view reload cell heights
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)tokenCollectionTableViewCellDidTapAddButton:(MBTokenCollectionTableViewCell *)cell
{
    MBRecipientTokenCollection *collection = self.tokenCollection;
    
    //Add new token to model
    MBRecipientToken *token = [[MBRecipientToken alloc] initWithEmail:@"fnord@fnord.com" name:@"Token with Accessory"];
    token.accessoryImage = [[UIImage imageNamed:@"Check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    token.accessoryType = kTokenAccessoryImageView;
    [collection addToken:token];
    
    //Add token to view
    [cell addTokens:@[token] animated:YES];
}

@end
