ruleset echo {
    meta {
        name "Echo"
        description <<
Rule named hello that responds to a echo::hello event by returning a directive named say and the option something set to Hello World

Rule named message that responds to a echo:message event with an attribute input by returning a directive named say with the option something set to the value of the input attribute.
>>
        author "Ben Thompson"
        logging on
        shares echo, __testing
    }

    global {

    }

    rule hello {
        select when echo hello
        send_directive("say") with
            something = "Hello World"
    }

}