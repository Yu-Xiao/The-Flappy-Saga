//
//  Game.m
//  The Flappy Saga
//
//  Created by Yuxiao Ma on 2015-09-09.
//  Copyright (c) 2015 Yuxiao Ma. All rights reserved.
//

#import "Game.h"

@interface Game ()

@end

@implementation Game

-(IBAction)Start:(id)sender{
    
    Start.hidden = YES;
    TopObstacle.hidden = NO;
    BottomObstacle.hidden = NO;
    
    SagaMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(SagaMoving) userInfo:nil repeats:YES];
    
    [self PlaceObstacle];
    
    ObstacleMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(ObstacleMoving) userInfo:nil repeats:YES];
}

-(void)Score{
    ScoreNumber += 1;
    ScoreLabel.text =[NSString stringWithFormat:@"Score: %i", ScoreNumber];
}

-(void)GameOver{
    
    if (ScoreNumber > HighScoreNum){
        [[NSUserDefaults standardUserDefaults] setInteger:ScoreNumber forKey:@"HighScoreSaved"];
    }
    
    [ObstacleMovement invalidate];
    [SagaMovement invalidate];
    
    TryAgain.hidden = NO;
    Exit.hidden = NO;
    TopObstacle.hidden = YES;
    BottomObstacle.hidden = YES;
    Saga.hidden = YES;
    Background.hidden = YES;
    Dead.hidden = NO;
    GameOver.hidden = NO;
    
}

//Adjust the edge of RectBox
- (UIImageView *)RectBox:(UIImageView *)box
{
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:box];
    UIImageView *copy = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
    copy.frame = CGRectMake(copy.frame.origin.x,
                           copy.frame.origin.y + 12,
                           copy.frame.size.width - 32,
                           copy.frame.size.height - 23);
    return copy;
}

//Moving and regenerate the obstacles
-(void)ObstacleMoving{
    TopObstacle.center = CGPointMake(TopObstacle.center.x - 1, TopObstacle.center.y);
    BottomObstacle.center = CGPointMake(BottomObstacle.center.x - 1, BottomObstacle.center.y);
    
    if (TopObstacle.center.x < -35){
        [self PlaceObstacle];
    }
    
    if (TopObstacle.center.x == 60){
        [self Score];
    }
    
    if (CGRectIntersectsRect([self RectBox:Saga].frame, TopObstacle.frame)){
        [self GameOver];
    }
    
    if (CGRectIntersectsRect([self RectBox:Saga].frame, BottomObstacle.frame)){
        [self GameOver];
    }
    
}

//Place the top and bottom obstacle in random position off the screen
-(void)PlaceObstacle{
    //Set top obstacle to random y position between lowerBound and upperBound
    int lowerBound = -100;
    int upperBound = 80;
    RandomTopPos = lowerBound + arc4random() % (upperBound - lowerBound);
    
    RandomBotPos = RandomTopPos + 330;
    TopObstacle.center = CGPointMake(570, RandomTopPos);
    //TopObstacle.frame = CGRectMake(, 0, <#CGFloat width#>, <#CGFloat height#>)
    BottomObstacle.center =CGPointMake(570, RandomBotPos);
}

-(void)SagaMoving{
    
    Saga.center = CGPointMake(Saga.center.x, Saga.center.y - SagaFlight);
    
    //Saga will move down in a constant rate.
    SagaFlight = SagaFlight - 2.5;
    
    if (SagaFlight < -15) {
        SagaFlight = -15;
    }
    
    //Saga is moving upward, show upward saga image (useless for now)
    if (SagaFlight > 0) {
        Saga.image = [UIImage imageNamed:@"wukong.gif"];
    }
    //Saga is moving upward, show updown saga image
    if (SagaFlight < 0) {
        Saga.image = [UIImage imageNamed:@"wukong2.gif"];
    }
    
    if (Saga.center.y > 350){
        [self GameOver];
    }
    if (Saga.center.y < 5){
        Saga.center = CGPointMake(Saga.center.x, 5);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    SagaFlight = 12;
}

- (void)viewDidLoad {
    
    TopObstacle.hidden = YES;
    BottomObstacle.hidden = YES;
    Dead.hidden = YES;
    GameOver.hidden = YES;
    
    TryAgain.hidden = YES;
    Exit.hidden = YES;
    ScoreNumber = 0;
    
    HighScoreNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    
    Saga.translatesAutoresizingMaskIntoConstraints = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
