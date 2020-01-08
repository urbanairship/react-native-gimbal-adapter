#import "UARCTGimbalVisitEvent.h"

static NSDateFormatter *dateFormatter_;
static dispatch_once_t createDateFormatter;

@interface UARCTGimbalVisitEvent()
@property (nonatomic, strong) GMBLVisit *visit;
@property (nonatomic, strong) NSString *name;
@end

@implementation UARCTGimbalVisitEvent

- (instancetype)initWithVisit:(GMBLVisit *)visit name:(NSString *)name {
    self = [super init];
    if (self) {
        self.visit = visit;
        self.name = name;
    }
    return self;
}


+ (instancetype)enterEventWithVisit:(GMBLVisit *)visit {
    return [[self alloc] initWithVisit:visit name:@"com.urbanairship.gimbal.visit_enter"];
}

+ (instancetype)exitEventWithVisit:(GMBLVisit *)visit {
    return [[self alloc] initWithVisit:visit name:@"com.urbanairship.gimbal.visit_exit"];
}


- (NSString *)eventName {
    return self.name;
}

- (id)eventBody {
    NSDateFormatter *dateFormatter = [UARCTGimbalVisitEvent dateFormatter];
    NSMutableDictionary *visit = [NSMutableDictionary dictionary];
    [visit setValue:self.visit.visitID forKey:@"identifier"];
    [visit setValue:[dateFormatter stringFromDate:self.visit.departureDate] forKey:@"departureTime"];
    [visit setValue:[dateFormatter stringFromDate:self.visit.arrivalDate] forKey:@"arrivalTime"];
    [visit setValue:@(self.visit.dwellTime ?: 0) forKey:@"dwellTime"];

    if (self.visit.place) {
        NSMutableDictionary *place = [NSMutableDictionary dictionary];
        [place setValue:self.visit.place.identifier forKey:@"identifier"];
        [place setValue:self.visit.place.name forKey:@"name"];


        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        for (NSString *key in self.visit.place.attributes.allKeys) {
            [attributes setValue:[self.visit.place.attributes stringForKey:key] forKey:key];
        }

        [place setValue:attributes forKey:@"attributes"];
        [visit setValue:place forKey:@"place"];
    }

    return visit;
}


+ (NSDateFormatter *)dateFormatter {
    dispatch_once(&createDateFormatter, ^{
        dateFormatter_ = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter_ setLocale:enUSPOSIXLocale];
        [dateFormatter_ setTimeStyle:NSDateFormatterFullStyle];
        dateFormatter_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        [dateFormatter_ setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });

    return dateFormatter_;
}

@end
