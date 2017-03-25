ruleset trip_store {
    meta {
        name "Track Trips"
        description <<
A rule named collect_trips that looks for explicit:trip_processed events and stores the mileage and a timestamp in an entity variable. The entity variable should contain all the trips that have been processed.

A rule named collect_long_trips that looks for explicit:found_long_trip events and stores the mileage and a timestamp in a different entity variable that collects long trips.

A rule named clear_trips that looks for a car:trip_reset event and resets both of the entity variables from the rules in (1) and (2).
>>
        author "Ben Thompson"
        logging on
        shares trips, long_trips, short_trips
    }

    global {
        idx = 0
        idxl = 0

        trips = function () {
            ent:trips
        }

        long_trips = function () {
            ent:long_trips
        }

        short_trips = function () {
            ent:trips
        }
    }

    rule collect_trips {
        select when explicit trip_processed
        pre{
            mileage = event:attr("mileage")
        }
        fired {
            ent:trips{[idx, "mileage"]} := mileage;
            ent:trips{[idx, "timestamp"]} := timestamp;
            idx = idx + 1
        }
    }

    rule collect_long_trips {
        select when explicit found_long_trip
        pre{
            mileage = event:attr("mileage")
        }
        fired {
            ent:long_trips{[idxl, "mileage"]} := mileage;
            ent:long_trips{[idxl, "timestamp"]} := timestamp;
            idxl = idxl + 1
        }
    }

    rule clear_trips {
        select when car trip_reset
        always {
            idx = 0;
            idxl = 0;
            ent:trips := {};
            ent:long_trips := {}
        }
    }

}
