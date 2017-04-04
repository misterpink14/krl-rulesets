ruleset manage_fleet {
    meta {
        name "Manage Fleet"
        description <<
Manages a fleet of vehicle picos
>>
        author "Ben Thompson"
        logging on
        shares __testing
    }

    global {
        vehicle_id = 0

        __testing = {
            "events": [ { "domain": "car", "type": "new_vehicle" } ]
        }

        get_vehicle_name = function () {
            vehicle_id = vehicle_id + 1;
            "vehicle" + vehicle_id.as("String")
        }
    }

    rule subscribe_vehicle {

            raise wrangler event "subscription"
                with name = vehicle_name
                    name_space = "fleet"
                    my_role = "fleet"
                    subscriber_role = "vehicle"
                    channel_type = "subscription"
                    subscriber_eci = vehicle_name
    }

    rule create_vehicle {
        select when car new_vehicle
        pre {
            vehicle_name = get_vehicle_name()
            eci = meta:eci
        }
        fired {
            raise pico event "new_child_request"
                attributes { "dname": vehicle_name, "color": "#FF69B4" }
        }
    }
}