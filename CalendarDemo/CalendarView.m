//
//  CalendarView.m
//  NeverSkip
//
//  Created by Shri on 3/16/13.
//  Copyright (c) 2013 Natalyst. All rights reserved.
//
//	License for usage - MIT license
//
/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "CalendarView.h"

@implementation CalendarView

-(id) initWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor topBarBGColor:(UIColor *)topBGColor {
	topBarBGColor = topBGColor;
    return [self initWithFrame:frame bgColor:bgColor];
}

-(id) initWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor {
	calendarBGColor = bgColor;
    return [self initWithFrame:frame];
}

- (id) initWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    showButtonBar = TRUE; // make this parameter
    self = [super initWithFrame:frame];
    if (self) {
        // page loaded -> set to current month
        nsCalendar = [NSCalendar currentCalendar];
        [self setThisMonth];
        //int numRows = (startGridPos + numDaysThisMonth) > 35 ? 6 : 5;
        int numRows = 6;
        labelArray = [[NSMutableArray alloc] initWithCapacity:42];
        calBGArray = [[NSMutableArray alloc] initWithCapacity:42];
        float dayBoxH = (frame.size.height - 50) / (numRows + 1);
        float dayBoxW = (frame.size.width - 10) / 7;
        // Initialization code
        // draw the calendar here
        //horizonatal cal
        NSString* weekdays = @"SMTWTFS";
        for (int j = 0; j < 7; j++) {
            UILabel* textLabel  = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(frame.origin.x + j*dayBoxW + 5,
                                         frame.origin.y,
                                         dayBoxW - 1,
                                         dayBoxH - 1);
            textLabel.font = [UIFont fontWithName:@"Verdana" size: 13];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.text = [NSString stringWithFormat:@"%C", [weekdays characterAtIndex:j]];
            if(topBarBGColor == nil)
                topBarBGColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:0.9];
            textLabel.backgroundColor = topBarBGColor;
            textLabel.textColor = [UIColor whiteColor];
            
            [self addSubview: textLabel];
        }
        for (int i = 0; i < numRows; i++) {
            for (int j = 0; j < 7; j++) {
                UIView* calBG = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x + j*dayBoxW + 5,
                                                                        frame.origin.y + dayBoxH + i*dayBoxH + 5,
                                                                        dayBoxW - 1,
                                                                        dayBoxH - 1)];
                calBG.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.65 alpha:0.9];;
                [calBGArray addObject:calBG];
                [self addSubview:calBG];
            	UILabel* textLabel  = [[UILabel alloc] init];
                textLabel.frame = CGRectMake(frame.origin.x + j*dayBoxW + 5,
                                             frame.origin.y + dayBoxH + i*dayBoxH + 5,
                                             dayBoxW - 5,
                                             dayBoxH - 1);
                textLabel.font = [UIFont fontWithName:@"Arial-Bold" size: 12];
                textLabel.textAlignment = NSTextAlignmentRight;
                //textLabel.text = [NSString stringWithFormat:@"%d", (j + 1)+(i*7)];
                textLabel.backgroundColor = [UIColor clearColor];
                if(j==0)
                	textLabel.textColor = [UIColor orangeColor];
                else
                    textLabel.textColor = [UIColor darkTextColor];
                textLabel.alpha = 0.7;
                [labelArray addObject:textLabel];
                [self addSubview: textLabel];
            }
        }
        
        [self populateDates];
        
        // enclose lines below  only if bar at bottom needed
        self.userInteractionEnabled = YES;
        
        dateLabel  = [[UILabel alloc] init];
        dateLabel.frame = CGRectMake(frame.origin.x + frame.size.width/2 - 50,
                                     frame.origin.y + frame.size.height - dayBoxH - 5,
                                     100,
                                     dayBoxH);
        dateLabel.font = [UIFont fontWithName:@"Verdana-Bold" size: 12];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM, YYYY"];
        dateLabel.text = [dateFormatter stringFromDate:localDate];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor grayColor];
        [self addSubview: dateLabel];
        
        UIButton* nextmonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    	[nextmonthButton setFrame: CGRectMake(frame.origin.x + frame.size.width - dayBoxW - 2, frame.origin.y + frame.size.height - dayBoxH -5, dayBoxW - 5, dayBoxH - 5)];
        [nextmonthButton setTitle:@">" forState:UIControlStateNormal];
        [nextmonthButton addTarget:self action:@selector(setNextMonth:) forControlEvents:UIControlEventTouchUpInside];
        [nextmonthButton setBackgroundColor:[UIColor lightGrayColor]];
        nextmonthButton.tag = 1;
        UIButton* prevmonthButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        
    	[prevmonthButton setFrame:CGRectMake(frame.origin.x + 5, frame.origin.y + frame.size.height - dayBoxH - 5, dayBoxW - 5, dayBoxH - 5)];
        [prevmonthButton setTitle:@"<" forState:UIControlStateNormal];
        prevmonthButton.tag = 1;
        [prevmonthButton addTarget:self action:@selector(setPreviousMonth:) forControlEvents:UIControlEventTouchUpInside];
        [prevmonthButton setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview: nextmonthButton];
        [self addSubview: prevmonthButton];
//        [self bringSubviewToFront:nextmonthButton];
//        [self bringSubviewToFront:prevmonthButton];
    }
    return self;
}

-(void) updateDateLabel{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM, YYYY"];
    dateLabel.text = [dateFormatter stringFromDate:calDate];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void) setThisMonth {
    unsigned int units2 = ( NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  );
    NSDateComponents *components = [nsCalendar components:units2 fromDate:[[NSDate alloc] init]];
    localDate = [nsCalendar dateFromComponents:components];
    [components setDay:1];
    NSDate *firstDayOfMonthDate = [nsCalendar dateFromComponents:components];
    calDate = firstDayOfMonthDate;
    NSDateComponents *components2 = [nsCalendar components:units2 fromDate:firstDayOfMonthDate];
    startGridPos = [components2 weekday];
    
    NSRange days = [nsCalendar rangeOfUnit:NSDayCalendarUnit
                                    inUnit:NSMonthCalendarUnit
                                   forDate:firstDayOfMonthDate];
    numDaysThisMonth = days.length;
	NSLog(@"\nCal desc: %@\n todaydesc - %@ Day: %i %i", [nsCalendar description], [firstDayOfMonthDate description], startGridPos, numDaysThisMonth);
    [self checkHighlightToday];
}

-(void) populateDates {
    
   	// dim background
    for(int i = 0; i < [calBGArray count] ; i++) {
        UIView* calBG = (UIView*)[calBGArray objectAtIndex:i];
        calBG.alpha = 0.5; // dim it
    }
    int j = 1;
    for(int i = startGridPos - 1; j <= numDaysThisMonth ; i++,j++) {
    	UILabel* caldateLabel = (UILabel*)[labelArray objectAtIndex:i];
        caldateLabel.text = [NSString stringWithFormat:@"%d", j];
        UIView* calBG = (UIView*)[calBGArray objectAtIndex:i];
        calBG.alpha = 1.0; // dim it
    }
}

-(void) clearDates{
    // first clear?
    for(int i = 0;i<[labelArray count] ;i++) {
    	UILabel* caldateLabel = (UILabel*)[labelArray objectAtIndex:i];
        caldateLabel.text = @"";
    }
    
}


-(void) setLocalToday {
    
    
}
-(IBAction)  setNextMonth:(id) sender{
    [self undoHighlightDay];
    unsigned int units2 = ( NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  );
    NSDateComponents *components = [nsCalendar components:units2 fromDate:calDate];
    
    [components setMonth:components.month + 1];
    [components setDay:1];
    NSDate *firstDayOfMonthDate = [nsCalendar dateFromComponents:components];
    calDate = firstDayOfMonthDate; // to save state
    NSDateComponents *components2 = [nsCalendar components:units2 fromDate:firstDayOfMonthDate];
    startGridPos = [components2 weekday];
    
    NSRange days = [nsCalendar rangeOfUnit:NSDayCalendarUnit
                                    inUnit:NSMonthCalendarUnit
                                   forDate:firstDayOfMonthDate];
    numDaysThisMonth = days.length;
	NSLog(@"\nCal desc: %@\n todaydesc - %@ Day: %i %i", [nsCalendar description], [firstDayOfMonthDate description], startGridPos, numDaysThisMonth);
    [self clearDates];
    [self populateDates];
    [self updateDateLabel];
    [self checkHighlightToday];
    
    
}
-(IBAction)  setPreviousMonth:(id) sender {
    [self undoHighlightDay];
    unsigned int units2 = ( NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  );
    NSDateComponents *components = [nsCalendar components:units2 fromDate:calDate];
    
    [components setMonth:components.month - 1];
    [components setDay:1];
    NSDate *firstDayOfMonthDate = [nsCalendar dateFromComponents:components];
    calDate = firstDayOfMonthDate;
    NSDateComponents *components2 = [nsCalendar components:units2 fromDate:firstDayOfMonthDate];
    startGridPos = [components2 weekday];
    
    NSRange days = [nsCalendar rangeOfUnit:NSDayCalendarUnit
                                    inUnit:NSMonthCalendarUnit
                                   forDate:firstDayOfMonthDate];
    numDaysThisMonth = days.length;
	NSLog(@"\nCal desc: %@\n todaydesc - %@ Day: %i %i", [nsCalendar description], [firstDayOfMonthDate description], startGridPos, numDaysThisMonth);
    [self clearDates];
    [self populateDates];
    [self updateDateLabel];
    [self checkHighlightToday];
}

-(void) checkHighlightToday {
    // clear first
    NSDateComponents *components2 = [nsCalendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:localDate];
    NSDateComponents *calComponents = [nsCalendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:calDate];
    if(calComponents.month == components2.month && calComponents.year == components2.year){
    	[self highlightDay:components2.day];
    }
}

-(void) highlightDay: (int) day {
    UIView* calBG = (UIView*)[calBGArray objectAtIndex:startGridPos+day-2];
    if(calBG != nil) {
    	calBG.backgroundColor = [UIColor colorWithRed:0.6 green:0.7 blue:0.2 alpha:0.9];;
    }
}

-(void) undoHighlightDay {
    NSDateComponents *components2 = [nsCalendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:localDate];
    int day = components2.day;
    UIView* calBG = (UIView*)[calBGArray objectAtIndex:startGridPos+day-2];
    if(calBG != nil) {
    	calBG.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.65 alpha:0.9];;
    }
}

@end
