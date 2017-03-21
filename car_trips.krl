ruleset car_trips {
    meta {
        name "Car Trips"
        description <<
Rule called process_trip that responds to the echo:message event with an attribute mileage. This rule should return a directive named trip with the option trip_length set to the value of the mileage attribute.
>>
        author "Ben Thompson"
        logging on
        shares __testing
    }

    global {
        __testing = {
            "events": [ { "domain": "car", "type": "new_trip", "attrs": [ "mileage" ] } ]
        }
        long_trip = "100"
    }

    rule process_trip {
        select when car new_trip
        fired {
            raise explicit event "trip_processed"
                attributes { "attrs": event:attrs() }
        }
    }

    rule find_long_trips {
        select when explicit trip_processed
        pre{
            mileage = event:attr("mileage")
        }
        if mileage < long_trip then
            end_directive("trip") with
                trip_length = mileage
        fired {}
        else {
            raise explicit event "found_long_trip"
                attributes { "attrs": event:attrs() }
        }
    }
}
