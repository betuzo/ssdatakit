//
//  SSManagedTableViewController.m
//  SSDataKit
//
//  Created by Sam Soffes on 4/7/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSManagedTableViewController.h"

@implementation SSManagedTableViewController

#pragma mark - Accessors

@synthesize tableView = _tableView;
@synthesize clearsSelectionOnViewWillAppear = _clearsSelectionOnViewWillAppear;


#pragma mark - NSObject

- (id)init {
	return (self = [self initWithStyle:UITableViewStylePlain]);
}


- (void)dealloc {
	_tableView.dataSource = nil;
	_tableView.delegate = nil;
}


#pragma mark - UIViewController

- (void)loadView {
	_tableView.frame = [[UIScreen mainScreen] applicationFrame];
	self.view = _tableView;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// TODO: Only reload if data is empty
	[self.tableView reloadData];
	
	if (_clearsSelectionOnViewWillAppear) {
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView flashScrollIndicators];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:animated];
}


#pragma mark - Initializer

- (id)initWithStyle:(UITableViewStyle)style {
	if ((self = [super init])) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
		_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_clearsSelectionOnViewWillAppear = YES;
	}
	return self;
}


#pragma mark - Working with Cells

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	// Subclasses should override this method
}



#pragma mark - Accessing Objects

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [self.fetchedResultsController objectAtIndexPath:indexPath];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Subclasses should override this method
	return nil;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
		}
			
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
		}
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *tableView = self.tableView;
	
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
		}
			
        case NSFetchedResultsChangeDelete: {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
		}
			
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
		}
			
        case NSFetchedResultsChangeMove: {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
		}
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end