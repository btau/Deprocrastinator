//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Brett Tau on 1/18/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@property NSMutableArray *toDoListArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoListArray = [NSMutableArray arrayWithObjects: @"go to gym", @"get haircut", @"do laundry", nil];
    self.editing = false;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.toDoListArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"row %li", (long)indexPath.row];
    cell.textLabel.text = [self.toDoListArray objectAtIndex:indexPath.row];
    
    return cell;
}

//Changes text color when row is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *localCell = [tableView cellForRowAtIndexPath:indexPath];
    localCell.textLabel.textColor = [UIColor greenColor];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


//Allows user to delete rows
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete?" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel  handler:nil];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.toDoListArray removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    [self presentViewController:alertController animated:true completion:nil];
}


//Allows user to rearrange their to do list after they click the "edit" button
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *toDoListItem = [self.toDoListArray objectAtIndex:sourceIndexPath.row];
    [self.toDoListArray removeObject:toDoListItem];
    [self.toDoListArray insertObject:toDoListItem atIndex:destinationIndexPath.row];
}


//Adds user input to their to do list
- (IBAction)onAddButtonPressed:(UIButton *)sender {
    NSMutableString *userInput = [NSMutableString stringWithFormat:@"%@", self.textField.text];
    [self.toDoListArray addObject:userInput];
    [self.tableView reloadData];
    self.textField.text = @"";
    [self.textField endEditing:YES];
}



//Allows user to click "Edit" and edit their to do list
- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender {
    if(self.editing)
    {
        self.editing = false;
        [self.tableView setEditing:false animated:true];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    }
    else
    {
        self.editing = true;
        [self.tableView setEditing:true animated:true];
        sender.style = UIBarButtonItemStyleDone;
        sender.title = @"Done";
    }
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.textLabel.textColor == [UIColor blackColor]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else if (cell.textLabel.textColor == [UIColor redColor]) {
        cell.textLabel.textColor = [UIColor yellowColor];
    } else if (cell.textLabel.textColor == [UIColor yellowColor]) {
        cell.textLabel.textColor = [UIColor greenColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }

    
}


@end
