# completions for ykman
set -l seen __fish_seen_subcommand_from
set -l needs_subcmd __fish_use_subcommand

complete -c ykman -s h -l help -d "Show help info"

complete -xc ykman -s d -l device -d "Specify which YubiKey to interact with by serial number"
complete -xc ykman -s r -l reader -d "Use an external smart card reader"
complete -xc ykman -s l -l log-level -d "Enable logging at given verbosity level" -a "DEBUG INFO WARNING ERROR CRITICAL"
complete -Fc ykman -l log-files -d "Write logs to the given FILE instead of standard error"
complete -c ykman -l diagnose -d "Show diagnostics information useful for troubleshooting"
complete -c ykman -s v -l version -d "Show version information about the app"
complete -c ykman -l full-help -d "Show --help, including hidden commands"

complete -xc ykman -n "$needs_subcmd" -a apdu -d "Execute arbitary APDUs"
complete -xc ykman -n "$needs_subcmd" -a info -d "Show general information"
complete -xc ykman -n "$needs_subcmd" -a list -d "List connected YubiKeys"
complete -xc ykman -n "$needs_subcmd" -a config -d "Enable or disable applications"
complete -xc ykman -n "$needs_subcmd" -a fido -d "Manage the FIDO applications"
complete -xc ykman -n "$needs_subcmd" -a oath -d "Manage the OATH application"
complete -xc ykman -n "$needs_subcmd" -a openpgp -d "Manage the OpenPGP application"
complete -xc ykman -n "$needs_subcmd" -a otp -d "Manage the YubiOTP application"
complete -xc ykman -n "$needs_subcmd" -a piv -d "Manage the PIV application"

# TODO ykman apdu

complete -c ykman -n "$seen info && ! $seen fido" -s c -l check-fips -d "Check if YubiKey is in FIPS Approved mode"

complete -c ykman -n "$seen list" -s s -l serials -d "Output only serial numbers, one per line"
complete -c ykman -n "$seen list" -s r -l readers -d "List available smart card readers"

# TODO ykman config

complete -xc ykman -n "$seen fido && $needs_subcmd" -a info -d "Display general status of the FIDO2 application"
complete -xc ykman -n "$seen fido && $needs_subcmd" -a reset -d "Reset all FIDO applications"
complete -xc ykman -n "$seen fido && $needs_subcmd" -a access -d "Manage the PIN for FIDO"
complete -xc ykman -n "$seen fido && $needs_subcmd" -a credentials -d "Manage discoverable (resident) credentials"
complete -xc ykman -n "$seen fido && $needs_subcmd" -a fingerprints -d "Manage fingerprints"
