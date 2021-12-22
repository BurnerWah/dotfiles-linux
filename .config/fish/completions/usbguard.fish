# Usbguard completions
set -l seen __fish_seen_subcommand_from
set -l needs_subcmd __fish_use_subcommand

complete -c usbguard -s h -l help -d "Show help"

function __usbguard_rules
    usbguard list-rules | string replace ': ' \t
end

complete -c usbguard -n "$needs_subcmd" -xa get-parameter -d "Get the value of a runtime parameter"
complete -c usbguard -n "$needs_subcmd" -xa set-parameter -d "Set the value of a runtime parameter"
complete -c usbguard -n "$needs_subcmd" -xa list-devices -d "List all USB devices recognized by the USBGuard daemon"
complete -c usbguard -n "$needs_subcmd" -xa allow-device -d "Authorize a device to interact with the system"
complete -c usbguard -n "$needs_subcmd" -xa block-device -d "Deauthorize a device"
complete -c usbguard -n "$needs_subcmd" -xa reject-device -d "Deauthorize and remove a device from the system"
complete -c usbguard -n "$needs_subcmd" -xa list-rules -d "List the rule set (policy) used by the USBGuard daemon"
complete -c usbguard -n "$needs_subcmd" -xa append-rule -d "Append a rule to the rule set"
complete -c usbguard -n "$needs_subcmd" -xa remove-rule -d "Remove a rule from the rule set"
complete -c usbguard -n "$needs_subcmd" -xa generate-policy -d "Generate a rule set (policy) based on the connected USB devices"
complete -c usbguard -n "$needs_subcmd" -xa watch -d "Watch for IPC interface events and print them to stdout"
complete -c usbguard -n "$needs_subcmd" -xa read-descriptor -d "Read a USB descriptor from a file and print it in human-readable form"
complete -c usbguard -n "$needs_subcmd" -xa add-user -d "Add USBGuard IPC user/group"
complete -c usbguard -n "$needs_subcmd" -xa remove-user -d "Remove USBGuard IPC user/group"

complete -c usbguard -n "$seen get-parameter" -x

complete -c usbguard -n "$seen set-parameter" -x
complete -c usbguard -n "$seen set-parameter" -s v -l verbose -d "Print the previous and new attribute value"

complete -c usbguard -n "$seen allow-device block-device reject-device" -s p -l permanent -d "Make the decision permanent"

complete -c usbguard -n "$seen list-devices" -f
complete -c usbguard -n "$seen list-devices" -s a -l allowed -d "List allowed devices"
complete -c usbguard -n "$seen list-devices" -s b -l blocked -d "List blocked devices"

complete -c usbguard -n "$seen list-rules" -f
complete -c usbguard -n "$seen list-rules" -s d -l show-devices -d "Show all devices which are affected by the specific rule"
complete -c usbguard -n "$seen list-rules" -s l -d label -x -d "Only show rules having a specific label"

complete -c usbguard -n "$seen append-rule" -x
complete -c usbguard -n "$seen append-rule" -s a -l after -x -a "(__usbguard_rules)" -d "Append the new rule after a rule with the specified id"
complete -c usbguard -n "$seen append-rule" -s t -l temporary -d "Make the decision temporary"

complete -c usbguard -n "$seen remove-rule" -x -a "(__usbguard_rules)"

# TODO
complete -c usbguard -n "$seen generate-policy" -f

complete -c usbguard -n "$seen watch" -f
complete -c usbguard -n "$seen watch" -s w -l wait -d "Wait for IPC connection to become available"
complete -c usbguard -n "$seen watch" -s o -l once -d "Wait only when starting, if needed"
complete -c usbguard -n "$seen watch" -s e -l exec -r -F -d "Run an executable file located at <path> for every event"
