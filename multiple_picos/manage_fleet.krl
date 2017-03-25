ruleset manage_fleet {
    meta {
        name "Manage Fleet"
        description <<
Manages a fleet of vehicle picos
>>
        author "Ben Thompson"
        logging on
    }

    global {
        vehicle_id = 0
    }

    rule create_vehicle {
        select when car new_vehicle
        pre {
            vehicle_id = vehicle_id + 1;
            vehicle_name = "vehicle" + vehicle_id.as("String")
        }
        fired {
            raise pico event "new_child_request"
                attributes { "dname": vehicle_name, "color": "#FF69B4" };
            raise wrangler event "subscription"
                with name = vehicle
                    name_space = "fleet"
                    my_role = "controller"
                    subscriber_role = "vehicle"
                    channel_type = "subscription"
        }
    }
}