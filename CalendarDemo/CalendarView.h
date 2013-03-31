//
//  CalendarView.h
//  NeverSkip
//
//  Created by Shri on 3/16/13.
//  Copyright (c) 2013 Natalyst. All rights reserved.
//
//	License for usage - MIT license
/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@interface CalendarView : UIView {
	NSDate* 		localDate;
    NSDate* 		calDate;
    NSCalendar* 	nsCalendar;
	int				highlightRow;
    int				highlightColumn;
    int 			startGridPos;
    int 			numDaysThisMonth;
	NSMutableArray*	labelArray;
    NSMutableArray* calBGArray;
    UILabel* 		dateLabel;
    bool 			showButtonBar;
    UIColor*		topBarBGColor;
    UIColor* 		calendarBGColor;
}

-(void) 	setThisMonth;
-(void) 	setLocalToday;
-(IBAction)	setNextMonth:(id) sender;
-(IBAction) setPreviousMonth:(id) sender;
-(void) 	highlightDay:(int)day;
//implement thse to pass the color
-(id) 		initWithFrame:(CGRect)frame bgColor:(UIColor*) bgColor;
-(id) 		initWithFrame:(CGRect)frame bgColor:(UIColor*) bgColor topBarBGColor:(UIColor*) topBarBGColor;


@end
