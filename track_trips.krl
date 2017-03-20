ruleset track_trips {
    meta {
        name "Echo"
        description <<
Rule called process_trip that responds to the echo:message event with an attribute mileage. This rule should return a directive named trip with the option trip_length set to the value of the mileage attribute.
>>
        author "Ben Thompson"
        logging on
        shares __testing
    }

    global {
        __testing = {
            "events": [ { "domain": "echo", "type": "message", "attrs": [ "mileage" ] } ]
        }
    }

    rule process_trip {
        select when echo message
        pre{
            mileage = event:attr("mileage")
        }
        send_directive("trip") with
            trip_length = mileage
    }

}
