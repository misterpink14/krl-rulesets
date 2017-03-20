ruleset track_trips {
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
    }

    rule process_trip {
        select when car new_trip
        pre{
            mileage = event:attr("mileage")
        }
        send_directive("trip") with
            trip_length = mileage
    }

}
