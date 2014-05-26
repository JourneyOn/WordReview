//
//  DicCell.m
//  WordReview
//
//  Created by shupeng on 5/15/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "DicCell.h"

#define DESCRIPTION_FONT    [UIFont systemFontOfSize:16]
#define EXAMPLE_FONT        [UIFont systemFontOfSize:14]
#define EXPLAIN_FONT        [UIFont systemFontOfSize:14]

#define TOP                 3
#define BOTTOM              TOP
#define MARGIN              3

@interface DicCell ()
{
    UILabel *_descriptionLabel;
    UILabel *_exampleLabel;
    UILabel *_expalinLabel;
    
    NSDictionary *_dicEntry;
}
@end

@implementation DicCell

+ (CGFloat)heightForDicEntry:(NSDictionary *)dicEntry
{
    CGFloat height = TOP;
    
    NSString *description = [dicEntry objectForKey:ENTRY_DESCRIPTION];
    CGRect rectDesc = [description boundingRectWithSize:CGSizeMake(300, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: DESCRIPTION_FONT} context:nil];
    height += rectDesc.size.height - rectDesc.origin.y;
    
    NSString *example = [dicEntry objectForKey:ENTRY_EXAMPLE];
    CGRect rectExam = [example boundingRectWithSize:CGSizeMake(300, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: EXAMPLE_FONT} context:nil];
    height += MARGIN + rectExam.size.height  - rectExam.origin.y;
    
    NSString *explain = [dicEntry objectForKey:ENTRY_EXAMPLE];
    CGRect rectExplain = [explain boundingRectWithSize:CGSizeMake(300, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: EXPLAIN_FONT} context:nil];
    height += MARGIN + rectExplain.size.height  - rectExplain.origin.y;
    
    height += BOTTOM;
    
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _descriptionLabel = [[UILabel alloc] init];
        [_descriptionLabel setFont:DESCRIPTION_FONT];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_descriptionLabel];

        _exampleLabel = [[UILabel alloc] init];
        [_exampleLabel setFont:EXAMPLE_FONT];
        _exampleLabel.numberOfLines = 0;
        _exampleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_exampleLabel];

        _expalinLabel = [[UILabel alloc] init];
        [_expalinLabel setFont:EXPLAIN_FONT];
        _expalinLabel.numberOfLines = 0;
        _expalinLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_expalinLabel];
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews{
    NSString *description = [_dicEntry objectForKey:ENTRY_DESCRIPTION];
    CGRect rectDesc = [description boundingRectWithSize:CGSizeMake(300, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: DESCRIPTION_FONT} context:nil];
    _descriptionLabel.frame = CGRectMake((self.contentView.frameWidth - 300)/2, TOP, 300, CGRectGetHeight(rectDesc) - rectDesc.origin.y);
    
    NSString *example = [_dicEntry objectForKey:ENTRY_EXAMPLE];
    CGRect rectExam = [example boundingRectWithSize:CGSizeMake(300, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: EXAMPLE_FONT} context:nil];
    _exampleLabel.frame = CGRectMake((self.contentView.frameWidth - 300)/2, _descriptionLabel.frameY + _descriptionLabel.frameHeight + MARGIN, 300, CGRectGetHeight(rectExam) - rectExam.origin.y);
    
    NSString *explain = [_dicEntry objectForKey:ENTRY_EXAMPLE];
    CGRect rectExplain = [explain boundingRectWithSize:CGSizeMake(300, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: EXPLAIN_FONT} context:nil];
    _expalinLabel.frame = CGRectMake((self.contentView.frameWidth - 300)/2, _exampleLabel.frameY + _exampleLabel.frameHeight + MARGIN, 300, CGRectGetHeight(rectExplain) - rectExplain.origin.y);
}

- (void)configWithDicEntry:(NSDictionary *)dicEntry
{
    _dicEntry = dicEntry;
    _descriptionLabel.text = [_dicEntry objectForKey:ENTRY_DESCRIPTION];
    _exampleLabel.text = [_dicEntry objectForKey:ENTRY_EXAMPLE];
    _expalinLabel.text = [_dicEntry objectForKey:ENTRY_EXPLAIN];
    
    [self setNeedsLayout];
}
@end
